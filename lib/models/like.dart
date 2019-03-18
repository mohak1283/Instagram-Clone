
class Like {
  
  String ownerName;
  String ownerPhotoUrl;
  String ownerUid;

  Like({this.ownerName, this.ownerPhotoUrl});

   Map toMap(Like like) {
    var data = Map<String, String>();
    data['ownerName'] = like.ownerName;
    data['ownerPhotoUrl'] = like.ownerPhotoUrl;
    data['ownerUid'] = like.ownerUid;
    return data;
}

  Like.fromMap(Map<String, String> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
  }

}