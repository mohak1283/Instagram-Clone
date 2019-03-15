import 'package:flutter/material.dart';
import 'package:instagram_clone/blocs/profile_bloc.dart';

class ProfileBlocProvider extends InheritedWidget {

  final ProfileBloc bloc;
  
  ProfileBlocProvider({Key key, Widget child}) : bloc = ProfileBloc() , super(key: key, child: child);

  static ProfileBlocProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ProfileBlocProvider);
  }


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  
}