import 'package:flutter/material.dart';
import 'package:instagram_clone/ui/chat_screen.dart';

class InstaFeedScreen extends StatefulWidget {
  @override
  _InstaFeedScreenState createState() => _InstaFeedScreenState();
}

class _InstaFeedScreenState extends State<InstaFeedScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        centerTitle: true,
        elevation: 1.0,
        leading: new Icon(Icons.camera_alt),
        title:
            SizedBox(height: 35.0, child: Image.asset("assets/insta_logo.png")),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => ChatScreen())
                ));
              },
            ),
          )
        ],
      ),
      body: Container(),
    );
  }
}
