import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fit_mart/models/workout_plan.dart';
import 'package:fit_mart/trainer_view/blocs/plan_overview_bloc.dart';
import 'package:fit_mart/trainer_view/screens/home/workout_plan_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

class DynamicLinkProvider {
  PlanOverviewBloc _bloc = PlanOverviewBloc();

  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    WorkoutPlan workoutPlan;
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      var isWorkoutPlan = deepLink.pathSegments.contains('workoutplan');
      if (isWorkoutPlan) {
        //get the uid of the workout plan
        var workoutPlanUid = deepLink.queryParameters['uid'];
        printInfo(info: workoutPlanUid.toString());
        //if we have a uid get workout plan details
        if (workoutPlanUid != null) {
          await _bloc.getPlanDetails(workoutPlanUid).then((element) async {
            workoutPlan = WorkoutPlan(
              uid: element.id,
              users: element.get('users'),
              trainerName: await element.get('trainerName'),
              type: await element.get('type'),
              weeks: await element.get('weeks'),
              location: await element.get('location'),
              level: await element.get('level'),
              description: await element.get('description'),
              promoVideoUrl: await element.get('promoVideoUrl'),
              isPublished: await element.get('isPublished'),
              coverPhotoUrl: await element.get('coverPhotoUrl'),
              userUid: await element.get('userUid'),
              title: await element.get('title'),
            );

            //then send user to the workout plan preview screen
          }).whenComplete(() async {
            if (workoutPlan.uid != null) {
              if (FirebaseAuth.instance.currentUser != null) {
                await Get.to(WorkoutPlanPreview(
                  workoutPlan: workoutPlan,
                ));
              } else {
                await Get.off(WorkoutPlanPreview(
                  workoutPlan: workoutPlan,
                ));
              }
            } else {
              //todo: do nothing or go to another screen?
            }
          });
        }
      }
    }
  }

  Future<String> createWorkoutPlanLink(WorkoutPlan workoutPlan) async {
    String workoutPlanUid = workoutPlan.uid;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fitpoapp.page.link',
      link: Uri.parse(
          'https://fitpoapp.page.link/workoutplan?uid=$workoutPlanUid'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
      ),
      // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
      //todo As noted on issue 20761, package_info on iOS requires the Xcode build folder to be rebuilt after changes to the version string in pubspec.yaml. Clean the Xcode build folder with: XCode Menu -> Product -> (Holding Option Key) Clean build folder.
      iosParameters: IosParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: workoutPlan.title,
        description:
            'Check out this workout plan by ' + workoutPlan.trainerName,
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    return dynamicUrl.toString();
  }
}
