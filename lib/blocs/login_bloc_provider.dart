import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/blocs/login_bloc.dart';

class LoginBlocProvider extends InheritedWidget {

  final LoginBloc bloc;
  
  LoginBlocProvider({Key key, Widget child}) : bloc = LoginBloc() , super(key: key, child: child);

  static LoginBlocProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(LoginBlocProvider);
  }


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  
}