
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  
  String ownerName;
  String ownerPhotoUrl;
  String comment;
  FieldValue timeStamp;

  Comment({this.ownerName, this.ownerPhotoUrl, this.comment, this.timeStamp});

   Map toMap(Comment comment) {
    var data = Map<String, dynamic>();
    data['ownerName'] = comment.ownerName;
    data['ownerPhotoUrl'] = comment.ownerPhotoUrl;
    data['comment'] = comment.comment;
    data['timestamp'] = comment.timeStamp;
    return data;
}

  Comment.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.comment = mapData['comment'];
    this.timeStamp = mapData['timestamp'];
  }

}