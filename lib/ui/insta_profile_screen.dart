import 'package:flutter/material.dart';
import 'package:instagram_clone/blocs/login_bloc_provider.dart';
import 'package:instagram_clone/blocs/profile_bloc.dart';
import 'package:instagram_clone/blocs/profile_bloc_provider.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/ui/login_screen.dart';

class InstaProfileScreen extends StatefulWidget {
  @override
  _InstaProfileScreenState createState() => _InstaProfileScreenState();
}

class _InstaProfileScreenState extends State<InstaProfileScreen> {
  ProfileBloc bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = ProfileBlocProvider.of(context).bloc;
  }

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
            bloc.signOut().then((v) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return LoginBlocProvider(child: MyApp());
              }));
            });
          },
        ),
      ),
    );
  }
}
