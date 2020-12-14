import 'package:flutter/cupertino.dart';

class WorkoutPlan {
  final String title;
  final String trainer;
  final double progress;
  final String uid;
  final String category;
  final String coverPhotoUrl;
  final String description;
  final bool isFree;
  final bool isPublished;
  final String location;
  final int numberOfDays;
  final double price;
  final int rating;
  final String skillLevel;
  final String userUid; //Todo change to trainerUid
  final String videoOverviewUrl;
  final int numberOfReviews;

  WorkoutPlan({
    this.numberOfReviews,
    this.category,
    this.coverPhotoUrl,
    this.description,
    this.isFree,
    this.isPublished,
    this.location,
    this.numberOfDays,
    this.price,
    this.rating,
    this.skillLevel,
    this.userUid,
    this.videoOverviewUrl,
    this.title,
    this.trainer,
    this.progress,
    this.uid,
  });
}
