import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {

  final String photoUrl;
  final String name;
  final String receiverUid;

  ChatDetailScreen({this.photoUrl, this.name, this.receiverUid});

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(),
    );
  }
}
