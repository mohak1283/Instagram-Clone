
class Like {
  
  String ownerName;
  String ownerPhotoUrl;

  Like({this.ownerName, this.ownerPhotoUrl});

   Map toMap(Like like) {
    var data = Map<String, String>();
    data['ownerName'] = like.ownerName;
    data['ownerPhotoUrl'] = like.ownerPhotoUrl;
    return data;
}

  Like.fromMap(Map<String, String> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
  }

}