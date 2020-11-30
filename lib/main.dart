import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/blocs/create_plan_workouts_provider.dart';
import 'package:fit_mart/blocs/my_plan_workouts_bloc_provider.dart';
import 'package:fit_mart/blocs/exercises_bloc_provider.dart';
import 'package:fit_mart/blocs/login_bloc_provider.dart';
import 'package:fit_mart/blocs/my_workout_plans_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/add_exercises_list_screen.dart';
import 'package:fit_mart/screens/add_exercises_screen.dart';
import 'package:fit_mart/screens/add_workouts_list_screen.dart';
import 'package:fit_mart/screens/create_new_exercise_title_screen.dart';
import 'package:fit_mart/screens/create_new_plan_add_workouts_screen.dart';
import 'package:fit_mart/screens/create_new_plan_categories.dart';
import 'package:fit_mart/screens/create_new_plan_cover.dart';
import 'package:fit_mart/screens/create_new_plan_length_screen.dart';
import 'package:fit_mart/screens/create_new_plan_pricing.dart';
import 'package:fit_mart/screens/create_new_plan_step_description_screen.dart';
import 'package:fit_mart/screens/create_new_plan_video_overview.dart';
import 'package:fit_mart/screens/create_new_workout_title_screen.dart';
import 'package:fit_mart/screens/home_screen.dart';
import 'package:fit_mart/screens/login_screen.dart';
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
      child: CreatePlanWorkoutsBlocProvider(
        child: ExercisesBlocProvider(
          child: MyPlanWorkoutsBlocProvider(
            child: MyWorkoutPlansBlocProvider(
              child: MaterialApp(
                title: 'FitMart',
                theme: ThemeData.light().copyWith(
                    primaryColor: kPrimaryColor,
                    accentColor: kAccentColor,
                    cursorColor: kPrimaryColor,
                    highlightColor: kPrimaryColor),
                initialRoute: LoginScreen.id,
                routes: {
                  HomeScreen.id: (context) => HomeScreen(),
                  LoginScreen.id: (context) => LoginScreen(),
                  CreateNewPlanStepDescriptionScreen.id: (context) =>
                      CreateNewPlanStepDescriptionScreen(),
                  CreateNewPlanAddWorkoutsScreen.id: (context) =>
                      CreateNewPlanAddWorkoutsScreen(),
                  AddWorkoutsListScreen.id: (context) =>
                      AddWorkoutsListScreen(),
                  CreateNewWorkoutStep1Screen.id: (context) =>
                      CreateNewWorkoutStep1Screen(),
                  AddExercisesListScreen.id: (context) =>
                      AddExercisesListScreen(),
                  CreateNewExerciseTitleScreen.id: (context) =>
                      CreateNewExerciseTitleScreen(),
                  AddExercisesScreen.id: (context) => AddExercisesScreen(),
                  CreateNewPlanCoverScreen.id: (context) =>
                      CreateNewPlanCoverScreen(),
                  CreateNewPlanPricingScreen.id: (context) =>
                      CreateNewPlanPricingScreen(),
                  CreateNewPlanVideoOverview.id: (context) =>
                      CreateNewPlanVideoOverview(),
                  CreateNewPlanCategoriesScreen.id: (context) =>
                      CreateNewPlanCategoriesScreen(),
                  CreateNewPlanLengthScreen.id: (context) =>
                      CreateNewPlanLengthScreen(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
