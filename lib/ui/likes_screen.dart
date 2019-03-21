import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:instagram_clone/ui/insta_friend_profile_screen.dart';
import 'package:instagram_clone/ui/insta_profile_screen.dart';

class LikesScreen extends StatefulWidget {
  final DocumentReference documentReference;
  final User user;
  LikesScreen({this.documentReference, this.user});

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: new Color(0xfff8faf8),
        title: Text('Likes'),
      ),
      body: FutureBuilder(
        future: _repository.fetchPostLikes(widget.documentReference),
        builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 16.0),
                  child: ListTile(
                    title: GestureDetector(
                      onTap: () {
                        snapshot.data[index].data['ownerName'] == widget.user.displayName ? 
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) => InstaProfileScreen())
                        )) : Navigator.push(context, MaterialPageRoute(
                          builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                        ));
                      },
                      child: Text(
                        snapshot.data[index].data['ownerName'],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () {
                       snapshot.data[index].data['ownerName'] == widget.user.displayName ? 
                        Navigator.push(context, MaterialPageRoute(
                          builder: ((context) => InstaProfileScreen())
                        )) : Navigator.push(context, MaterialPageRoute(
                          builder: ((context) => InstaFriendProfileScreen(name: snapshot.data[index].data['ownerName'],))
                        ));
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            snapshot.data[index].data['ownerPhotoUrl']),
                        radius: 30.0,
                      ),
                    ),
                    // trailing:
                    //     snapshot.data[index].data['ownerUid'] != widget.user.uid
                    //         ? buildProfileButton(snapshot.data[index].data['ownerName'])
                    //         : null,
                  ),
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('No Likes found'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
