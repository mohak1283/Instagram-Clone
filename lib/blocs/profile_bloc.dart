import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/repository.dart';

class ProfileBloc {

  final _repository = Repository();

  Future<FirebaseUser> getCurrentUser() {
    return _repository.getCurrentUser();
  }

  Future<void> signOut() {
    return _repository.signOut();
  }

}