import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/resources/repository.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc {

  final _repository = Repository();

  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _username = BehaviorSubject<String>();
  final _displayName = BehaviorSubject<String>();

  Observable<String> get email => _email.stream.transform(emailValidator);
  Observable<String> get password => _password.stream.transform(passwordValidator);
  Observable<String> get username => _username.stream;
  Observable<String> get displayName => _displayName.stream.transform(displayNameTransformer);

  Observable<bool> get submitCheck => Observable.combineLatest4(email, password, username, displayName, (e, p, u, d) => true);




  // Change data
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(String) get changeUsername => _username.sink.add;

  Function(String) get changeDisplayName => _displayName.sink.add;

  void dispose() {
    _email?.close();
    _password?.close();
    _username?.close();
    _displayName?.close();
  }

  final displayNameTransformer = StreamTransformer<String, String>.fromHandlers(
    handleData: (displayName, sink) {
      if (displayName.length > 5) {
        sink.add(displayName);
      } else {
        sink.addError('Display name should be greater than 5 characters');
      }
    }
  );

  final emailValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@') && email.isNotEmpty) {
        sink.add(email);
      } else {
        sink.addError('Invalid email');
      }
    }
  );

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length > 5 && password.isNotEmpty) {
        sink.add(password);
      } else {
        sink.addError('Password should be greater than 5 characters');
      }
    }
  );

  // final userNameValidator = StreamTransformer<String, String>.fromHandlers(
  //   handleData: (password, sink) {
  //     if (password.length > 5 && password.isNotEmpty) {
  //       sink.add(password);
  //     } else {
  //       sink.addError('Invalid password');
  //     }
  //   }
  // );

  //  _usernameTransformer() {
  //   return ScanStreamTransformer<String, Future<bool>>(
  //     (Future<bool> status, String username, int index) {
  //       print("USERNAME : $username");
  //       status =_repository.checkIfUsernameExists(username);
  //       return status;
  //     }
  //   );
  // }

  // final usernameTransformer = 
  //   StreamTransformer<String, String>.fromHandlers(
  //         handleData: (username, sink) {
  //           _usernameTransformer().then((value) {
  //             if (!value) {
  //               sink.add(username);
  //             } else {
  //               sink.addError('Username already exists');
  //             }
  //           });
  //         }
  //       );

  // final _usernameTransformer = StreamTransformer<String, String>.fromHandlers(
  //   handleData: (username, sink) {
  //     if (username.) {
        
  //     } else {
  //     }
  //   }
  // );
  
  Future<bool> authenticateUserName() {
    return _repository.authenticateUserName(_username.value);
  }


  Future<bool> authenticateUser(FirebaseUser user) {
    return _repository.authenticateUser(user);
  }

  Future<void> registerUser(FirebaseUser user) {
    return _repository.addDataToDb(user);
  }

  Future<FirebaseUser> signInWithGoogle() {
    return _repository.signIn();
  }

  Future<FirebaseUser> getCurrentUser() {
    return _repository.getCurrentUser();
  }
  

  
}