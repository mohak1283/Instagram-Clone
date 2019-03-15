import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/blocs/login_bloc.dart';
import 'package:instagram_clone/blocs/login_bloc_provider.dart';
import 'package:instagram_clone/ui/insta_home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = LoginBlocProvider.of(context).bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    bloc?.dispose();
  }

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
            bloc.signInWithGoogle().then((user) {
              if (user != null) {
                authenticateUser(user);
              } else {
                print("Error");
              }
            });
            // FutureBuilder(
            //     future: bloc.signInWithGoogle(),
            //     builder: ((context, AsyncSnapshot<FirebaseUser> snapshot) {
            //       if (snapshot.hasData) {
            //         print("INSIDE IF");
            //         print("Email : ${snapshot.data.email}");
            //         authenticateUser(snapshot.data);
            //       } else {
            //         print("Error : ${snapshot.error}");
            //       }
            //     }));
          },
        ),
        // child: RaisedButton(
        //     color: Color(0xFF4285F4),
        //     child: Row(
        //       children: <Widget>[
        //         Image.asset(
        //           'assets/google_icon.jpg',
        //           height: 48.0,
        //         ),
        //         new Expanded(
        //           child: Text('Sign in with Google',
        //               style: TextStyle(color: Colors.white)),
        //         ),
        //       ],
        //     ),
        //     onPressed: () {
        //       FutureBuilder(
        //           future: bloc.signInWithGoogle(),
        //           builder: ((context, AsyncSnapshot<FirebaseUser> snapshot) {
        //             if (snapshot.hasData) {
        //                 authenticateUser(snapshot.data);
        //             } else {
        //               print("Error : ${snapshot.error}");
        //             }
        //           }));
        //     }),
      ),
    );
  }

  void authenticateUser(FirebaseUser user) {
    print("Inside Login Screen -> authenticateUser");
    bloc.authenticateUser(user).then((value) {
      if (value) {
        print("VALUE : $value");
        print("INSIDE IF");
        bloc.registerUser(user).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return InstaHomeScreen();
          }));
        });
      } else {
        print("INSIDE ELSE");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return InstaHomeScreen();
        }));
      }
    });
  }
}
