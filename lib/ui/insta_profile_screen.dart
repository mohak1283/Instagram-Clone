import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/like.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/ui/comments_screen.dart';
import 'package:instagram_clone/ui/likes_screen.dart';

class InstaProfileScreen extends StatefulWidget {
  // InstaProfileScreen();

  @override
  _InstaProfileScreenState createState() => _InstaProfileScreenState();
}

class _InstaProfileScreenState extends State<InstaProfileScreen> {
  var _repository = Repository();
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  User _user;
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
    icon = FontAwesomeIcons.heart;
    // _future =_repository.retrieveUserPosts(_user.uid);
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    _future = _repository.retrieveUserPosts(_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: new Color(0xfff8faf8),
          elevation: 1,
          title: Text('Profile'),
        ),
        body: _user != null
            ? ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Container(
                            width: 110.0,
                            height: 110.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              image: DecorationImage(
                                  image: _user.photoUrl.isEmpty
                                      ? AssetImage('assets/no_image.png')
                                      : NetworkImage(_user.photoUrl),
                                  fit: BoxFit.cover),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                detailsWidget(_user.posts, 'posts'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: detailsWidget(
                                      _user.followers, 'followers'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: detailsWidget(
                                      _user.following, 'following'),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 20.0, right: 20.0),
                              child: Container(
                                width: 230.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.grey)),
                                child: Center(
                                  child: Text('Edit Profile',
                                      style: TextStyle(color: Colors.black)),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 30.0),
                    child: Text(_user.displayName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 10.0),
                    child: _user.bio.isNotEmpty
                        ? Text(
                            'Google Certified Android Developer Flutter Developer Technical Writer at codingwithmitch.com')
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(
                            Icons.grid_on,
                            color: _gridColor,
                          ),
                          onTap: () {
                            setState(() {
                              _isGridActive = true;
                              _gridColor = Colors.blue;
                              _listColor = Colors.grey;
                            });
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.stay_current_portrait,
                            color: _listColor,
                          ),
                          onTap: () {
                            setState(() {
                              _isGridActive = false;
                              _listColor = Colors.blue;
                              _gridColor = Colors.grey;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: postImagesWidget(),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
        // body: Center(
        //   child: RaisedButton(
        //     color: Colors.black,
        //     textColor: Colors.white,
        //     child: Text('Log Out'),
        //     onPressed: () {
        //       _repository.signOut().then((v) {
        //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        //           return MyApp();
        //         }));
        //       });
        //     },
        //   ),
        // ),
      ),
    );
  }

  Widget postImagesWidget() {
    
    return _isGridActive == true
        ? FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0),
                    itemBuilder: ((context, index) {
                      return Container(
                        width: 125.0,
                        height: 125.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.data[index].data['imgUrl']),
                                fit: BoxFit.cover)),
                      );
                    }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('No Posts Found'),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
          )
        : FutureBuilder(
            future: _future,
            builder:
                ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 600.0,
                    child: ListView.builder(
                      //shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: ((context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 16.0, 8.0, 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      new Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  _user.photoUrl)),
                                        ),
                                      ),
                                      new SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            _user.displayName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          snapshot.data[index]
                                                      .data['location'] !=
                                                  null
                                              ? new Text(
                                                  snapshot.data[index]
                                                      .data['location'],
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    ],
                                  ),
                                  new IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: null,
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: GestureDetector(
                                onDoubleTap: () {
                                  print("DOUBLE TAPPED");
                                },
                                child: new Image.network(
                                  snapshot.data[index].data['imgUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                          child: new Icon(
                                            // _isLiked == true ? Icons.favorite :FontAwesomeIcons.heart,
                                            icon,
                                            //color: _isLiked == true ? Colors.red : null,
                                            color: color,
                                          ),
                                          onTap: () {
                                            _repository.checkIfUserLikedOrNot(_user.uid, snapshot.data[index].reference).then((isLiked) {
                                              print("reef : ${snapshot.data[index].reference.path}");
                                              if (!isLiked) {
                                                setState(() {
                                                  icon = Icons.favorite;
                                                  color = Colors.red;
                                                });
                                                postLike(snapshot.data[index].reference);
                                              } else {

                                                setState(() {
                                                  icon =FontAwesomeIcons.heart;
                                                  color = null;
                                                });
                                                postUnlike(snapshot.data[index].reference);
                                              }
                                            });
                                            // updateValues(
                                            //     snapshot.data[index].reference);
                                          }),
                                      new SizedBox(
                                        width: 16.0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      CommentsScreen(
                                                        documentReference:
                                                            snapshot.data[index]
                                                                .reference,
                                                        user: _user,
                                                      ))));
                                        },
                                        child: new Icon(
                                          FontAwesomeIcons.comment,
                                        ),
                                      ),
                                      new SizedBox(
                                        width: 16.0,
                                      ),
                                      new Icon(FontAwesomeIcons.paperPlane),
                                    ],
                                  ),
                                  new Icon(FontAwesomeIcons.bookmark)
                                ],
                              ),
                            ),

                            // snapshot.data[index].reference

                            // FutureBuilder(

                            // ),

                            FutureBuilder(
                              future: _repository.fetchPostLikes(
                                  snapshot.data[index].reference),
                              builder: ((context,
                                  AsyncSnapshot<List<DocumentSnapshot>>
                                      likesSnapshot) {
                                if (likesSnapshot.hasData) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: ((context) => LikesScreen(user: _user, documentReference: snapshot.data[index].reference,))
                                      ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: likesSnapshot.data.length > 1
                                          ? Text(
                                              "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(likesSnapshot.data.length == 1
                                              ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
                                              : "0 Likes"),
                                    ),
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                            ),

                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: snapshot.data[index].data['caption'] !=
                                        null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Wrap(
                                            children: <Widget>[
                                              Text(_user.displayName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(snapshot.data[index]
                                                    .data['caption']),
                                              )
                                            ],
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: commentWidget(snapshot
                                                  .data[index].reference))
                                        ],
                                      )
                                    : commentWidget(
                                        snapshot.data[index].reference)),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text("1 Day Ago",
                                  style: TextStyle(color: Colors.grey)),
                            )
                          ],
                        );
                      }),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          );
  }

  void updateValues(DocumentReference reference) {

    print("REEEF : ${reference.path}");
    
    _repository.checkIfUserLikedOrNot(_user.uid, reference).then((isLiked) {
      if (isLiked) {
        
      } else {

      }
    });

    if (_isLiked == false) {
      print("Inside if");
      setState(() {
        _isLiked = true;
       // icon = Icons.favorite;
        //color = Colors.red;
      });
      postLike(reference);
    } else {
      print("Inside else");
      setState(() {
        _isLiked = false;
       // icon = FontAwesomeIcons.heart;
        //color = null;
      });
      postUnlike(reference);
    }
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: _user.displayName,
        ownerPhotoUrl: _user.photoUrl,
        ownerUid: _user.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(_user.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference.collection("likes").document(_user.uid).delete().then((value) {
      print("Post Unliked");
    });
  }

  Widget commentWidget(DocumentReference reference) {
    return FutureBuilder(
      future: _repository.fetchPostComments(reference),
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Text(
              'View all ${snapshot.data.length} comments',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => CommentsScreen(
                            documentReference: reference,
                            user: _user,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Widget detailsWidget(String count, String label) {
    return Column(
      children: <Widget>[
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black)),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child:
              Text(label, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        )
      ],
    );
  }
}
