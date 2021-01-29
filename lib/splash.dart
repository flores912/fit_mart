import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/providers/dynamic_link_provider.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'login_signup/screens/login.dart';

class Splash extends StatefulWidget {
  static const String id = 'splash';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  initState() {
    DynamicLinkProvider dynamicLinkProvider = DynamicLinkProvider();
    dynamicLinkProvider.handleDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: FirebaseAuth.instance.currentUser != null
              ? HomeTrainer()
              : Login(),
          image: Image.asset('assets/icon/icon_with_text.png'),
          backgroundColor: Colors.black,
          photoSize: 200,
          useLoader: false,
        ),
      ),
    );
  }
}
