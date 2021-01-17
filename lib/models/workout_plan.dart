class WorkoutPlan {
  final String userUid;
  final bool isPublished;
  final String uid;
  final String type;
  final String location;
  final String level;
  final int weeks;
  final String title;
  final String description;
  final String coverPhotoUrl;
  final String promoVideoUrl;
  final String trainerName;

  WorkoutPlan(
      {this.userUid,
      this.type,
      this.location,
      this.level,
      this.trainerName,
      this.uid,
      this.isPublished,
      this.weeks,
      this.title,
      this.description,
      this.coverPhotoUrl,
      this.promoVideoUrl});
}
