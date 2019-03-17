
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {

   String currentUserUid;
   String imgUrl;
   String caption; 
   String location; 
   FieldValue time;
   String postOwnerName; 
   String postOwnerPhotoUrl;

  Post({this.currentUserUid, this.imgUrl, this.caption, this.location, this.time, this.postOwnerName, this.postOwnerPhotoUrl});

   Map toMap(Post post) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = post.currentUserUid;
    data['imgUrl'] = post.imgUrl;
    data['caption'] = post.caption;
    data['location'] = post.location;
    data['time'] = post.time;
    data['postOwnerName'] = post.postOwnerName;
    data['postOwnerPhotoUrl'] = post.postOwnerPhotoUrl;
    return data;
  }

  Post.fromMap(Map<String, dynamic> mapData) {
    this.currentUserUid = mapData['ownerUid'];
    this.imgUrl = mapData['imgUrl'];
    this.caption = mapData['caption'];
    this.location = mapData['location'];
    this.time = mapData['time'];
    this.postOwnerName = mapData['postOwnerName'];
    this.postOwnerPhotoUrl = mapData['postOwnerPhotoUrl'];
  }

}