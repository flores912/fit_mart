import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/blocs/current_plan_workouts_bloc_provider.dart';
import 'package:fit_mart/blocs/login_bloc_provider.dart';
import 'package:fit_mart/blocs/my_workout_plans_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/current_workout_plan_workouts_screen.dart';
import 'package:fit_mart/screens/home_screen.dart';
import 'package:fit_mart/screens/login_screen.dart';
import 'package:fit_mart/screens/workout_session_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FitMart());
}

class FitMart extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LoginBlocProvider(
      child: CurrentPlanWorkoutsBlocProvider(
        child: MyWorkoutPlansBlocProvider(
          child: MaterialApp(
            title: 'FitMart',
            theme: ThemeData.light().copyWith(
              primaryColor: kPrimaryColor,
              accentColor: kAccentColor,
              cursorColor: kPrimaryColor,
            ),
            initialRoute: LoginScreen.id,
            routes: {
              HomeScreen.id: (context) => HomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              WorkoutSessionScreen.id: (context) => WorkoutSessionScreen(),
              CurrentWorkoutPlanWorkoutsScreen.id: (context) =>
                  CurrentWorkoutPlanWorkoutsScreen(),
            },
          ),
        ),
      ),
    );
  }
}
