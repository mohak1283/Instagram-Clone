import 'package:flutter/material.dart';

class InstaActivityScreen extends StatefulWidget {
  @override
  _InstaActivityScreenState createState() => _InstaActivityScreenState();
}

class _InstaActivityScreenState extends State<InstaActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Activity'),
      ),
      body: Center(
        child: Text('NOT IMPLEMENTED YET'),
      ),
    );
  }
}