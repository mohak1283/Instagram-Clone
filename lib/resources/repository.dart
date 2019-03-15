import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/firebase_provider.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDb(FirebaseUser user) => _firebaseProvider.addDataToDb(user);

  //Future<FirebaseUser> signIn(String email, String password) => _firebaseProvider.signIn(email, password);

  Future<FirebaseUser> signIn() => _firebaseProvider.signIn();
  
  Future<bool> authenticateUser(FirebaseUser user) => _firebaseProvider.authenticateUser(user);

  Future<bool> authenticateUserName(String userName) => _firebaseProvider.authenticateUserName(userName);

  Future<bool> checkIfUsernameExists(String username) => _firebaseProvider.checkIfUsernameExists(username);

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();
  

}