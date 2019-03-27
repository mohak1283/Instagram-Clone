import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/insta_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: new Color(0xfff8faf8),
          centerTitle: true,
          elevation: 1.0,
          title: SizedBox(
              height: 35.0, child: Image.asset("assets/insta_logo.png"))),
      body: Center(
        child: GestureDetector(
          child: Container(
            width: 250.0,
            height: 50.0,
            decoration: BoxDecoration(
                color: Color(0xFF4285F4),
                border: Border.all(color: Colors.black)),
            child: Row(
              children: <Widget>[
                Image.asset('assets/google_icon.jpg'),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text('Sign in with Google',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                )
              ],
            ),
          ),
          onTap: () {
            _repository.signIn().then((user) {
              if (user != null) {
                authenticateUser(user);
              } else {
                print("Error");
              }
            });
          },
        ),
      ),
    );
  }

  void authenticateUser(FirebaseUser user) {
    print("Inside Login Screen -> authenticateUser");
    _repository.authenticateUser(user).then((value) {
      if (value) {
        print("VALUE : $value");
        print("INSIDE IF");
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return InstaHomeScreen();
          }));
        });
      } else {
        print("INSIDE ELSE");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return InstaHomeScreen();
        }));
      }
    });
  }
}
