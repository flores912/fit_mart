import 'package:fit_mart/blocs/login_bloc.dart';
import 'package:fit_mart/blocs/login_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/home_screen.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                  stream: _bloc.email,
                  builder: (context, snapshot) {
                    return CustomTextForm(
                      errorText: snapshot.error,
                      obscureText: false,
                      onChanged: _bloc.changeEmail,
                      textInputType: TextInputType.emailAddress,
                      labelText: 'Email',
                    );
                  }),
              SizedBox(
                height: 16,
              ),
              StreamBuilder(
                  stream: _bloc.password,
                  builder: (context, snapshot) {
                    return CustomTextForm(
                      errorText: snapshot.error,
                      onChanged: _bloc.changePassword,
                      obscureText: true,
                      textInputType: TextInputType.visiblePassword,
                      labelText: 'Password',
                    );
                  }),
              SizedBox(
                height: 16,
              ),
              StreamBuilder(
                  stream: _bloc.signInStatus,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: kPrimaryColor,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_bloc.validateFields()) {
                          authenticateUser();
                        } else {
                          showErrorMessage(
                              context, 'Please fix all the errors');
                        }
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    ));
  }

  void authenticateUser() {
    _bloc.showProgressBar(true);

    _bloc.submit().then((userCredential) {
      if (userCredential.user == null) {
        //unregistered user\
        showErrorMessage(context, 'User doesn not exist');
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    });
  }

  void showErrorMessage(BuildContext context, String errorMessage) {
    final snackbar = SnackBar(
        content: Text(errorMessage), duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
