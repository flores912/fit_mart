class WorkoutPlan {
  final String userUid;
  final double price;
  final bool isFree;
  final bool isPublished;
  final int weeks;
  final String title;
  final String description;
  final String coverPhotoUrl;
  final String promoVideoUrl;

  WorkoutPlan(
      {this.userUid,
      this.isPublished,
      this.weeks,
      this.title,
      this.price,
      this.isFree,
      this.description,
      this.coverPhotoUrl,
      this.promoVideoUrl});
}
