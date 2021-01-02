import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/material.dart';

import 'login_signup/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Fitpo());
}

class Fitpo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitpo',
      theme: ThemeData.light(),
      initialRoute: Login.id,
      routes: {
        Login.id: (context) => Login(),
        HomeTrainer.id: (context) => HomeTrainer(),
      },
    );
  }
}
