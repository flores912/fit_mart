import 'package:firebase_core/firebase_core.dart';
import 'package:fit_mart/blocs/add_exercises_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/categories_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/cover_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/details_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/plan_length_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_new_exercise_title_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/price_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/promo_video_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/create_plan/workouts_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/edit_workout_plan_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/home/discover_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/library_screen_bloc_provider.dart';
import 'package:fit_mart/blocs/my_plan_workouts_bloc_provider.dart';
import 'package:fit_mart/blocs/exercises_bloc_provider.dart';
import 'package:fit_mart/blocs/login_bloc_provider.dart';
import 'package:fit_mart/blocs/my_workout_plans_bloc_provider.dart';
import 'package:fit_mart/blocs/plan_overview_screen_bloc_provider.dart';
import 'package:fit_mart/constants.dart';
import 'package:fit_mart/screens/edit_workout_plan_screen.dart';
import 'package:fit_mart/screens/library_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_workout/exercises_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_exercise/new_exercise_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/workouts_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/categories_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/cover_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/plan_length_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/price_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/details_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_plan/promo_video_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/create_workout/workout_name_screen.dart';
import 'file:///C:/Users/elhal/AndroidStudioProjects/fit_mart/lib/screens/home/home_screen.dart';
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
      child: PlanOverviewScreenBlocProvider(
        child: DiscoverScreenBlocProvider(
          child: PromoVideoScreenBlocProvider(
            child: CoverScreenBlocProvider(
              child: EditWorkoutPlanScreenBlocProvider(
                child: PriceScreenBlocProvider(
                  child: WorkoutsScreenBlocProvider(
                    child: PlanLengthScreenBlocProvider(
                      child: CategoriesScreenBlocProvider(
                        child: DetailsScreenBlocProvider(
                          child: LibraryScreenBlocProvider(
                            child: AddExercisesScreenBlocProvider(
                              child: CreateNewExerciseTitleScreenBlocProvider(
                                child: ExercisesBlocProvider(
                                  child: MyPlanWorkoutsBlocProvider(
                                    child: MyWorkoutPlansBlocProvider(
                                      child: MaterialApp(
                                        title: 'FitMart',
                                        theme: ThemeData.dark().copyWith(
                                            scaffoldBackgroundColor:
                                                Colors.black,
                                            floatingActionButtonTheme:
                                                FloatingActionButtonThemeData(
                                                    backgroundColor:
                                                        kPrimaryColor),
                                            primaryColor: kPrimaryColor,
                                            primaryColorDark: kPrimaryColor,
                                            accentColor: kAccentColor,
                                            backgroundColor: Colors.black,
                                            appBarTheme: AppBarTheme(
                                                color: Colors.black),
                                            bottomAppBarTheme:
                                                BottomAppBarTheme(
                                              color: Colors.black,
                                            ),
                                            highlightColor: kPrimaryColor),
                                        initialRoute: LoginScreen.id,
                                        routes: {
                                          HomeScreen.id: (context) =>
                                              HomeScreen(),
                                          LoginScreen.id: (context) =>
                                              LoginScreen(),
                                          DetailsScreen.id: (context) =>
                                              DetailsScreen(),
                                          WorkoutsScreen.id: (context) =>
                                              WorkoutsScreen(),
                                          WorkoutNameScreen.id: (context) =>
                                              WorkoutNameScreen(),
                                          NewExerciseScreen.id: (context) =>
                                              NewExerciseScreen(),
                                          ExercisesScreen.id: (context) =>
                                              ExercisesScreen(),
                                          CategoriesScreen.id: (context) =>
                                              CategoriesScreen(),
                                          PlanLengthScreen.id: (context) =>
                                              PlanLengthScreen(),
                                          LibraryScreen.id: (context) =>
                                              LibraryScreen(),
                                          EditWorkoutPlanScreen.id: (context) =>
                                              EditWorkoutPlanScreen(),
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
