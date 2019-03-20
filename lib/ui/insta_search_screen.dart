import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/insta_profile_screen.dart';
import 'package:instagram_clone/ui/post_detail_screen.dart';

class InstaSearchScreen extends StatefulWidget {
  @override
  _InstaSearchScreenState createState() => _InstaSearchScreenState();
}

class _InstaSearchScreenState extends State<InstaSearchScreen> {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>();
  User _user = User();
  List<String> userNameList = List<String>();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoUrl;
      print("USER : ${user.displayName}");
      _repository.retrievePosts(user).then((updatedList) {
        setState(() {
          list = updatedList;
        });
      });
      _repository.fetchAllUserNames(user).then((list) {
        setState(() {
          userNameList = list;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    print("INSIDE BUILD");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(userNameList: userNameList));
            },
          )
        ],
      ),
      body: GridView.builder(
          //  shrinkWrap: true,
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemBuilder: ((context, index) {
            print("LIST : ${list.length}");
            return GestureDetector(
              child: CachedNetworkImage(
                imageUrl: list[index].data['imgUrl'],
                placeholder: ((context, s) => Center(
                      child: CircularProgressIndicator(),
                    )),
                width: 125.0,
                height: 125.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                print("SNAPSHOT : ${list[index].reference.path}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => PostDetailScreen(
                              user: _user,
                              documentSnapshot: list[index],
                            ))));
              },
            );
          })),
    );
  }
}

class DataSearch extends SearchDelegate<String> {

   List<String> userNameList;
   DataSearch({this.userNameList});

  final cities = [
    'New Delhi',
    'Faridabad',
    'Ghaziabad',
    'Janakpuri',
    'Paschim Vihar',
    'Pitampura'
  ];

  final recentCities = ['New Delhi', 'Pitampura'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
   // return Center(child: Container(width: 50.0, height: 50.0, color: Colors.red,),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? recentCities
        : userNameList.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: ((context) => InstaProfileScreen()) 
              ));
              //showResults(context);
            },
            leading: Icon(Icons.account_circle),
            title: Text(suggestionsList[index]),
          )),
    );
  }
}
