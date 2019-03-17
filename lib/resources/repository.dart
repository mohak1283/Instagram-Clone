import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/firebase_provider.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(FirebaseUser user) => _firebaseProvider.addDataToDb(user);
  
  Future<FirebaseUser> signIn() => _firebaseProvider.signIn();
  
  Future<bool> authenticateUser(FirebaseUser user) => _firebaseProvider.authenticateUser(user);

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) => _firebaseProvider.uploadImageToStorage(imageFile);

  Future<void> addPostToDb(FirebaseUser currentUser, String imgUrl, String caption, String location) => _firebaseProvider.addPostToDb(currentUser, imgUrl, caption, location);
  

}