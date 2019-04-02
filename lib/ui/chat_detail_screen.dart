import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/message.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:path_provider/path_provider.dart';

class ChatDetailScreen extends StatefulWidget {
  final String photoUrl;
  final String name;
  final String receiverUid;

  ChatDetailScreen({this.photoUrl, this.name, this.receiverUid});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  var _formKey = GlobalKey<FormState>();
  String _senderuid;
  TextEditingController _messageController = TextEditingController();
  final _repository = Repository();
  String receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
  StreamSubscription<DocumentSnapshot> subscription;
  File imageFile;

  @override
  void initState() {
    super.initState();
    print("RCID : ${widget.receiverUid}");
    _repository.getCurrentUser().then((user) {
      setState(() {
        _senderuid = user.uid;
      });
      _repository.fetchUserDetailsById(_senderuid).then((user) {
        setState(() {
          senderPhotoUrl = user.photoUrl;
          senderName = user.displayName;
        });
      });
      _repository.fetchUserDetailsById(widget.receiverUid).then((user) {
        setState(() {
          receiverPhotoUrl = user.photoUrl;
          receiverName = user.displayName;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: new Color(0xfff8faf8),
          elevation: 1,
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.photoUrl),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.name),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: _senderuid == null
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                   
                    ChatMessagesListWidget(),
                    
                    chatInputWidget(),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
        ));
  }

  Widget chatInputWidget() {
    return Container(
      height: 55.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        validator: (String input) {
          if (input.isEmpty) {
            return "Please enter message";
          }
        },
        controller: _messageController,
        decoration: InputDecoration(
            hintText: "Enter message...",
            labelText: "Message",
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(Icons.gradient),
                    color: Colors.black,
                    onPressed: () {
                      pickImage(source: 'Gallery');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: InkWell(
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        sendMessage();
                      }
                    },
                  ),
                ),
              ],
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                pickImage(source: 'Camera');
              },
              color: Colors.black,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
        onFieldSubmitted: (value) {
          _messageController.text = value;
        },
      ),
    );
  }

  Future<void> pickImage({String source}) async {
    var selectedImage = await ImagePicker.pickImage(
        source: source == 'Gallery' ? ImageSource.gallery : ImageSource.camera);

    setState(() {
      imageFile = selectedImage;
    });
    compressImage();
    _repository.uploadImageToStorage(imageFile).then((url) {
      print("URL: $url");
      _repository.uploadImageMsgToDb(url, widget.receiverUid, _senderuid);
    });
    return;
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.copyResize(image, 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  void sendMessage() {
    print("Inside send message");
    var text = _messageController.text;
    print(text);
    Message _message = Message(
        receiverUid: widget.receiverUid,
        senderUid: _senderuid,
        message: text,
        timestamp: FieldValue.serverTimestamp(),
        type: 'text');
    print(
        "receiverUid: ${widget.receiverUid} , senderUid : ${_senderuid} , message: ${text}");
    print(
        "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
    _repository.addMessageToDb(_message, widget.receiverUid).then((v) {
      _messageController.text = "";
      print("Message added to db");
    });
  }

  Widget ChatMessagesListWidget() {
    print("SENDERUID : $_senderuid");
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(_senderuid)
            .collection(widget.receiverUid)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //listItem = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  chatMessageItem(snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: snapshot['senderUid'] == _senderuid
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              snapshot['senderUid'] == _senderuid
                  ? senderLayout(snapshot)
                  : receiverLayout(snapshot)
            ],
          ),
        )
      ],
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    return snapshot['type'] == 'text'
        ? Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(snapshot['message'],
                    style: TextStyle(color: Colors.black, fontSize: 16.0))),
          )
        : FadeInImage(
            fit: BoxFit.cover,
            image: NetworkImage(snapshot['photoUrl']),
            placeholder: AssetImage('assets/blankimage.png'),
            width: 250.0,
            height: 300.0,
          );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white30,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: snapshot['type'] == 'text'
            ? Text(snapshot['message'],
                style: TextStyle(color: Colors.black, fontSize: 16.0))
            : FadeInImage(
                fit: BoxFit.cover,
                image: NetworkImage(snapshot['photoUrl']),
                placeholder: AssetImage('assets/blankimage.png'),
                width: 200.0,
                height: 200.0,
              ),
      ),
    );
  }
}
