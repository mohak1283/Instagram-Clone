import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:instagram_clone/models/user.dart';

class FirebaseProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
   User user;
   final GoogleSignIn _googleSignIn = GoogleSignIn();

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
        posts: '0'
      );

      Map<String, String> mapdata = Map<String, String>();

      mapdata = user.toMap(user);
        

    return _firestore.collection("users").document(currentUser.uid).setData(mapdata);
  }

  // Future<void> signIn(String email, String password) async {
  //   FirebaseUser user = await _auth.signInWithEmailAndPassword(
  //       email: email, password: password);
  //   return user;
  // }

  Future<bool> checkIfUsernameExists(String username) async {
    final DocumentReference _documentReference =
        _firestore.collection("username").document(username);

    DocumentSnapshot _documentSnapshot = await _documentReference.get();

    if (_documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserExists(String uid) async {
    final DocumentReference _documentReference =
        _firestore.collection("users").document(uid);

    DocumentSnapshot _documentSnapshot = await _documentReference.get();

    if (_documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    print("Inside authenticateUser");
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0 ) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> authenticateUserName(String userName) async {
   final QuerySnapshot userNameResult = await _firestore
        .collection("usernames")
        .where("username", isEqualTo: userName)
        .getDocuments();

    

     final List<DocumentSnapshot> userNameDocs = userNameResult.documents;
    

    if (userNameDocs.length == 0 ) {
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





}
