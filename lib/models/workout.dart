class Workout {
  final String workoutName;
  final int exercises;
  final int day;
  final bool isSelected;
  final String uid;
  final String weekUid;
  Workout({
    this.weekUid,
    this.isSelected,
    this.day,
    this.workoutName,
    this.exercises,
    this.uid,
  });
}
