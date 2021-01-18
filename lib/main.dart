import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/providers/dynamic_link_provider.dart';
import 'package:fit_mart/trainer_view/screens/home/home_trainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'login_signup/screens/login.dart';

void main() async {
  configLoading();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() async {
    DynamicLinkProvider dynamicLinkProvider = DynamicLinkProvider();
    await dynamicLinkProvider.handleDynamicLinks();
  });
  runApp(Fitpo());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = kPrimaryColor
    ..backgroundColor = Colors.green
    ..indicatorColor = kPrimaryColor
    ..textColor = kPrimaryColor
    ..maskColor = kPrimaryColor.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation;
}

class Fitpo extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      title: 'Fitpo',
      theme: ThemeData.dark().copyWith(
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: kAccentColor),
          toggleableActiveColor: kPrimaryColor,
          accentColor: kAccentColor,
          scaffoldBackgroundColor: Colors.black,
          bottomAppBarColor: Colors.black,
          canvasColor: Colors.black,
          brightness: Brightness.dark,
          buttonColor: kPrimaryColor,
          primaryColor: kPrimaryColor,
          cardColor: Colors.white10,
          indicatorColor: kAccentColor,
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(primary: kPrimaryColor)),
          appBarTheme: AppBarTheme(
            color: Colors.black,
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
