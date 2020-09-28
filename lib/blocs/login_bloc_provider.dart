import 'package:fit_mart/blocs/login_bloc.dart';
import 'package:flutter/material.dart';

//This LoginBlocProvider will hold the LoginBloc object and
// provide it to all its children widgets i.e the LoginScreen widget.
class LoginBlocProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoginBlocProvider>().bloc;
  }
}
