import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';

class InstaProfileScreen extends StatefulWidget {
  @override
  _InstaProfileScreenState createState() => _InstaProfileScreenState();
}

class _InstaProfileScreenState extends State<InstaProfileScreen> {
  var _repository = Repository();
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;
  User _user;

  @override
  void initState() {
    super.initState();
    retrieveUserDetails();
  }

  retrieveUserDetails() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();
    User user = await _repository.retrieveUserDetails(currentUser);
    setState(() {
      _user = user;
    });
    // Alternate Way
    // _repository.getCurrentUser().then((currentUser) {
    //   print("Current User : ${currentUser.displayName}");
    //   _repository.retrieveUserDetails(currentUser).then((user) {
    //     setState(() {
    //       _user = user;
    //     });
    //   }).catchError((e) => print("Error retrieving user details : $e"));
    // }).catchError((e) => print("Error retrieving current user"));
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
            future: _repository.retrieveUserPosts(_user.uid),
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
        : Container();
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
