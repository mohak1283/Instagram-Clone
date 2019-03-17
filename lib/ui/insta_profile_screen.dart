import 'package:flutter/material.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/login_screen.dart';

class InstaProfileScreen extends StatefulWidget {
  @override
  _InstaProfileScreenState createState() => _InstaProfileScreenState();
}

class _InstaProfileScreenState extends State<InstaProfileScreen> {
  
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile'),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.black,
          textColor: Colors.white,
          child: Text('Log Out'),
          onPressed: () {
            _repository.signOut().then((v) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return MyApp();
              }));
            });
          },
        ),
      ),
    );
  }
}
