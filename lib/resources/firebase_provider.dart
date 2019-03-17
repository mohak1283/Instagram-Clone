import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/like.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  User user;
  Post post;
  Like like;
  Comment comment;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  StorageReference _storageReference;

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    print("Inside addDataToDb Method");

    _firestore
        .collection("display_names")
        .document(currentUser.displayName)
        .setData({'displayName': currentUser.displayName});

    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        displayName: currentUser.displayName,
        photoUrl: currentUser.photoUrl,
        followers: '0',
        following: '0',
        bio: '',
        posts: '0');

    Map<String, String> mapdata = Map<String, String>();

    mapdata = user.toMap(user);

    return _firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(mapdata);
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    print("EMAIL ID : ${currentUser.email}");
    return currentUser;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> addPostToDb(FirebaseUser currentUser, String imgUrl,
      String caption, String location) {
    CollectionReference _collectionRef = _firestore
        .collection("users")
        .document(currentUser.uid)
        .collection("posts");

    post = Post(
        currentUserUid: currentUser.uid,
        imgUrl: imgUrl,
        caption: caption,
        location: location,
        postOwnerName: currentUser.displayName,
        postOwnerPhotoUrl: currentUser.photoUrl,
        time: FieldValue.serverTimestamp());

    comment = Comment();
    like = Like();

    return _collectionRef.add(post.toMap(post)).then((documentReference) {
      documentReference.collection("comments").add(comment.toMap(comment));
      documentReference.collection("likes").add(like.toMap(like));
    });
  }
}
