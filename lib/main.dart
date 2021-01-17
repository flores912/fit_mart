import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/providers/dynamic_link_provider.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_signup/screens/login.dart';

void main() async {
  DynamicLinkProvider dynamicLinkProvider = DynamicLinkProvider();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dynamicLinkProvider.handleDynamicLinks();
  runApp(Fitpo());
}

class Fitpo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitpo',
      theme: ThemeData.dark().copyWith(
          dialogBackgroundColor: Colors.blueGrey.shade900,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: kAccentColor),
          scaffoldBackgroundColor: Colors.blueGrey.shade900,
          cardColor: Colors.blueGrey.shade800,
          accentColor: kAccentColor,
          canvasColor: Colors.blueGrey.shade900,
          primaryColor: kPrimaryColor,
          appBarTheme: AppBarTheme(
            color: Colors.blueGrey.shade900,
            brightness: Brightness.dark,
          )),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? Login.id : HomeTrainer.id,
      routes: {
        Login.id: (context) => Login(),
        HomeTrainer.id: (context) => HomeTrainer(),
      },
    );
  }
}
