import 'package:flutter/material.dart';

const String kLogin = 'Login';
const String kEmail = 'Email';
const String kPassword = 'Password';
const String kForgotPassword = 'Forgot Password?';
const String kSignUp = 'Sign Up';
const String kName = 'Name';
const String kAccount = 'Account';
const String kWorkoutPlans = 'Workout Plans';
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

const List<dynamic> kPriceList = [
  kFree,
  9.99,
  19.99,
  29.99,
  39.99,
  49.99,
  59.99,
  69.99,
  79.99,
  89.99,
  99.99
];
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
    child: Text(kDelete),
  ),
  const PopupMenuItem(
    value: 4,
    child: Text(kSwap),
  ),
];
const List<PopupMenuEntry> kSetCardPopUpMenuList = [
  const PopupMenuItem(
    value: 1,
    child: Text(kEdit),
  ),
  const PopupMenuItem(
    value: 2,
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
    child: Text(kEditSets),
  ),
  const PopupMenuItem(
    value: 3,
    child: Text(kSwap),
  ),
  const PopupMenuItem(
    value: 4,
    child: Text(kDelete),
  ),
];
