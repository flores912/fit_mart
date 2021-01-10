class WorkoutPlan {
  final String userUid;
  final double price;
  final bool isFree;
  final bool isPublished;
  final bool isBeenPaidFor;
  final String uid;
  final int weeks;
  final String title;
  final String description;
  final String coverPhotoUrl;
  final String promoVideoUrl;
  final String trainerName;

  WorkoutPlan(
      {this.userUid,
      this.trainerName,
      this.uid,
      this.isPublished,
      this.isBeenPaidFor,
      this.weeks,
      this.title,
      this.price,
      this.isFree,
      this.description,
      this.coverPhotoUrl,
      this.promoVideoUrl});
}
