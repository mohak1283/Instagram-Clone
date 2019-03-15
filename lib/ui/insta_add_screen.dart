import 'package:flutter/material.dart';

class InstaAddScreen extends StatefulWidget {
  @override
  _InstaAddScreenState createState() => _InstaAddScreenState();
}

class _InstaAddScreenState extends State<InstaAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Photo'),
      ),
      body: Container(),
    );
  }
}