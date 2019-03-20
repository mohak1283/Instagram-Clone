import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart';
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
  
  Future<User> retrieveUserDetails(FirebaseUser user) => _firebaseProvider.retrieveUserDetails(user);

  Future<List<DocumentSnapshot>> retrieveUserPosts(String userId) => _firebaseProvider.retrieveUserPosts(userId);

  Future<List<DocumentSnapshot>> fetchPostComments(DocumentReference reference) => _firebaseProvider.fetchPostCommentDetails(reference);

  Future<List<DocumentSnapshot>> fetchPostLikes(DocumentReference reference) => _firebaseProvider.fetchPostLikeDetails(reference);

  Future<bool> checkIfUserLikedOrNot(String userId, DocumentReference reference) => _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

   Future<List<DocumentSnapshot>> retrievePosts(FirebaseUser user) => _firebaseProvider.retrievePosts(user);

  Future<List<String>> fetchAllUserNames(FirebaseUser user) => _firebaseProvider.fetchAllUserNames(user);

}