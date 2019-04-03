import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/models/like.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/comments_screen.dart';
import 'package:instagram_clone/ui/likes_screen.dart';
import 'package:instagram_clone/ui/post_detail_screen.dart';

class InstaFriendProfileScreen extends StatefulWidget {
  final String name;
  InstaFriendProfileScreen({this.name});

  @override
  _InstaFriendProfileScreenState createState() =>
      _InstaFriendProfileScreenState();
}

class _InstaFriendProfileScreenState extends State<InstaFriendProfileScreen> {
  String currentUserId, followingUserId;
  var _repository = Repository();
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  User _user, currentuser;
  IconData icon;
  Color color;
  Future<List<DocumentSnapshot>> _future;
  bool _isLiked = false;
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;

  fetchUidBySearchedName(String name) async {
    print("NAME : ${name}");
    String uid = await _repository.fetchUidBySearchedName(name);
    setState(() {
      followingUserId = uid;
    });
    fetchUserDetailsById(uid);
    _future = _repository.retrieveUserPosts(uid);
  }

  fetchUserDetailsById(String userId) async {
    User user = await _repository.fetchUserDetailsById(userId);
    setState(() {
      _user = user;
      print("USER : ${_user.displayName}");
    });
  }

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((user) {
      _repository.fetchUserDetailsById(user.uid).then((currentUser) {
        setState(() {
          currentuser = currentUser;
        });
      });
      _repository.checkIsFollowing(widget.name, user.uid).then((value) {
        print("VALUE : ${value}");
        setState(() {
          isFollowing = value;
        });
      });
      setState(() {
        currentUserId = user.uid;
      });
    });
    fetchUidBySearchedName(widget.name);
  }

  followUser() {
    print('following user');
    _repository.followUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = true;
      followButtonClicked = true;
    });
  }

  unfollowUser() {
    _repository.unFollowUser(
        currentUserId: currentUserId, followingUserId: followingUserId);
    setState(() {
      isFollowing = false;
      followButtonClicked = true;
    });
  }

  Widget buildButton(
      {String text,
      Color backgroundcolor,
      Color textColor,
      Color borderColor,
      Function function}) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 210.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: backgroundcolor,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: borderColor)),
        child: Center(
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }

  Widget buildProfileButton() {
    // already following user - should show unfollow button
    if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey,
        function: unfollowUser,
      );
    }

    // does not follow user - should show follow button
    if (!isFollowing) {
      return buildButton(
        text: "Follow",
        backgroundcolor: Colors.blue,
        textColor: Colors.white,
        borderColor: Colors.blue,
        function: followUser,
      );
    }

    return buildButton(
        text: "loading...",
        backgroundcolor: Colors.white,
        textColor: Colors.black,
        borderColor: Colors.grey);
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
                                StreamBuilder(
                                  stream: _repository
                                      .fetchStats(
                                          uid: followingUserId, label: 'posts')
                                      .asStream(),
                                  builder: ((context,
                                      AsyncSnapshot<List<DocumentSnapshot>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      return detailsWidget(
                                          snapshot.data.length.toString(),
                                          'posts');
                                    } else {
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                  }),
                                ),

                                StreamBuilder(
                                  stream: _repository
                                      .fetchStats(
                                          uid: followingUserId,
                                          label: 'followers')
                                      .asStream(),
                                  builder: ((context,
                                      AsyncSnapshot<List<DocumentSnapshot>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 24.0),
                                        child: detailsWidget(
                                            snapshot.data.length.toString(),
                                            'followers'),
                                      );
                                    } else {
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                  }),
                                ),

                                StreamBuilder(
                                  stream: _repository
                                      .fetchStats(
                                          uid: followingUserId,
                                          label: 'following')
                                      .asStream(),
                                  builder: ((context,
                                      AsyncSnapshot<List<DocumentSnapshot>>
                                          snapshot) {
                                    if (snapshot.hasData) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: detailsWidget(
                                            snapshot.data.length.toString(),
                                            'following'),
                                      );
                                    } else {
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                  }),
                                ),

                                //   detailsWidget(_user.posts, 'posts'),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 20.0, right: 20.0),
                              child: buildProfileButton(),
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
                    child: _user.bio.isNotEmpty ? Text(_user.bio) : Container(),
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
                      return GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data[index].data['imgUrl'],
                          placeholder: ((context, s) => Center(
                                child: CircularProgressIndicator(),
                              )),
                          width: 125.0,
                          height: 125.0,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          print(
                              "SNAPSHOT : ${snapshot.data[index].reference.path}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => PostDetailScreen(
                                        user: _user,
                                        currentuser: currentuser,
                                        documentSnapshot: snapshot.data[index],
                                      ))));
                        },
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
                          itemBuilder: ((context, index) => ListItem(
                              list: snapshot.data,
                              index: index,
                              user: _user,
                              currentuser: currentuser))));
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

class ListItem extends StatefulWidget {
  List<DocumentSnapshot> list;
  User user, currentuser;
  int index;

  ListItem({this.list, this.user, this.index, this.currentuser});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  var _repository = Repository();
  bool _isLiked = false;
  Future<List<DocumentSnapshot>> _future;

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
                            user: widget.currentuser,
                          ))));
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    print("INDEX : ${widget.index}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          image: new NetworkImage(widget.user.photoUrl)),
                    ),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        widget.user.displayName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      widget.list[widget.index].data['location'] != null
                          ? new Text(
                              widget.list[widget.index].data['location'],
                              style: TextStyle(color: Colors.grey),
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
        CachedNetworkImage(
          imageUrl: widget.list[widget.index].data['imgUrl'],
          placeholder: ((context, s) => Center(
                child: CircularProgressIndicator(),
              )),
          width: 125.0,
          height: 250.0,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      child: _isLiked
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              FontAwesomeIcons.heart,
                              color: null,
                            ),
                      onTap: () {
                        if (!_isLiked) {
                          setState(() {
                            _isLiked = true;
                          });
                          
                          postLike(widget.list[widget.index].reference);
                        } else {
                          setState(() {
                            _isLiked = false;
                          });
                         
                          postUnlike(widget.list[widget.index].reference);
                        }
                      }),
                  new SizedBox(
                    width: 16.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => CommentsScreen(
                                    documentReference:
                                        widget.list[widget.index].reference,
                                    user: widget.currentuser,
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
        FutureBuilder(
          future:
              _repository.fetchPostLikes(widget.list[widget.index].reference),
          builder:
              ((context, AsyncSnapshot<List<DocumentSnapshot>> likesSnapshot) {
            if (likesSnapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => LikesScreen(
                                user: widget.user,
                                documentReference:
                                    widget.list[widget.index].reference,
                              ))));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: likesSnapshot.data.length > 1
                      ? Text(
                          "Liked by ${likesSnapshot.data[0].data['ownerName']} and ${(likesSnapshot.data.length - 1).toString()} others",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(likesSnapshot.data.length == 1
                          ? "Liked by ${likesSnapshot.data[0].data['ownerName']}"
                          : "0 Likes"),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
        ),
        Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: widget.list[widget.index].data['caption'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Text(widget.user.displayName,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:
                                Text(widget.list[widget.index].data['caption']),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: commentWidget(
                              widget.list[widget.index].reference))
                    ],
                  )
                : commentWidget(widget.list[widget.index].reference)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
        )
      ],
    );
  }

  void postLike(DocumentReference reference) {
    var _like = Like(
        ownerName: widget.currentuser.displayName,
        ownerPhotoUrl: widget.currentuser.photoUrl,
        ownerUid: widget.currentuser.uid,
        timeStamp: FieldValue.serverTimestamp());
    reference
        .collection('likes')
        .document(widget.currentuser.uid)
        .setData(_like.toMap(_like))
        .then((value) {
      print("Post Liked");
    });
  }

  void postUnlike(DocumentReference reference) {
    reference
        .collection("likes")
        .document(widget.currentuser.uid)
        .delete()
        .then((value) {
      print("Post Unliked");
    });
  }
}
