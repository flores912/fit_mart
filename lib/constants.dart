import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_mart/providers/firestore_provider.dart';
import 'package:flutter/material.dart';

const String kLogin = 'Login';
const String kEmail = 'Email';
const String kPassword = 'Password';
const String kForgotPassword = 'Forgot Password?';
const String kSignUp = 'Sign Up';
const String kName = 'Name';
const String kAccount = 'Account';
const String kWorkoutPlans = 'Workout Plans';
const String kExerciseCollection = 'Exercise Collection';
const String kExercises = 'Exercises';
const String kWorkouts = 'Workouts';
const String kChangeToClientView = 'Change to client view';
const String kTitle = 'Title';
const String kDescription = 'Description';
const String kOptional = '(Optional)';
const String kPrice = 'Price';
const String kNext = 'Next';
const String kSkip = 'Skip';
const String kSave = 'Save';
const String kFree = 'Free';
const String kRequired = 'Required';
const String kAddWeek = 'Add Week';
const String kRest = 'Rest';
const String kDay = 'Day';
const String kEditExercises = 'Edit Exercises';
const String kEditName = 'Edit Name';
const String kCopy = 'Copy';
const String kDelete = 'Delete';
const String kSwap = 'Swap';
const String kAddExercise = 'Add Exercise';
const String kExerciseName = 'Exercise Name';
const String kWorkoutName = 'Workout Name';
const String kAddVideo = 'Add Video';
const String kChangeVideo = 'Change Video';
const String kReps = 'Reps';
const String kSet = 'Set';
const String kSets = 'Sets';
const String kEdit = 'Edit';
const String kEditSets = 'Edit Sets';
const String kDuplicate = 'Duplicate';
const String kAddToCollection = 'Add to Collection';
const String kUnpublish = 'Unpublish';

const List<String> kTypes = [
  'Bodybuilding',
  'Weightlifting',
  'StrengthTraining',
  'Bodyweight',
  'Prenatal Training',
  'Postpartum  Training',
  'HIIT Training',
  'Sports Training',
  'Circuit Training',
  'Yoga',
];
const List<String> kLevels = [
  'Any level',
  'Beginner',
  'Intermediate',
  'Advanced',
];
const List<String> kLocations = [
  'Anywhere',
  'Home',
  'Gym',
  'Outdoors',
];

const Color kPrimaryColor = Colors.lightBlue;
const Color kAccentColor = Colors.lightBlueAccent;

const List<PopupMenuEntry> kWorkoutCardPopUpMenuList = [
  const PopupMenuItem(
    value: 1,
    child: Text(kEditName),
  ),
  const PopupMenuItem(
    value: 2,
    child: Text(kCopy),
  ),
  const PopupMenuItem(
    value: 3,
    child: Text(kSwap),
  ),
  //add reset button later?
];
const List<PopupMenuEntry> kWeekCardPopUpMenuList = [
  const PopupMenuItem(
    value: 1,
    child: Text(kCopy),
  ),
  const PopupMenuItem(
    value: 2,
    child: Text(kSwap),
  ),
  const PopupMenuItem(
    value: 3,
    child: Text(kDelete),
  ),
];
const List<PopupMenuEntry> kExerciseCardPopUpMenuList = [
  const PopupMenuItem(
    value: 1,
    child: Text(kEditName),
  ),
  const PopupMenuItem(
    value: 2,
    child: Text(kSwap),
  ),
  const PopupMenuItem(
    value: 3,
    child: Text(kDuplicate),
  ),
  const PopupMenuItem(
    value: 4,
    child: Text(kAddToCollection),
  ),
  const PopupMenuItem(
    value: 5,
    child: Text(kDelete),
  ),
];
const List<PopupMenuEntry> kExerciseCardCollectionPopUpMenuList = [
  const PopupMenuItem(
    value: 1,
    child: Text(kEditName),
  ),
  const PopupMenuItem(
    value: 2,
    child: Text(kDuplicate),
  ),
  const PopupMenuItem(
    value: 3,
    child: Text(kDelete),
  ),
];
const List<PopupMenuEntry> kMyCreatedWorkoutPlanCardPopUpMenuList = [
  const PopupMenuItem(
    value: 1,
    child: Text(kEdit),
  ),
  const PopupMenuItem(
    value: 2,
    child: Text(kDelete),
  ),
];
