class Workout {
  final String workoutName;
  final int exercises;
  final int day;
  final bool isSelected;
  final String uid;
  final String weekUid;
  final int week;
  Workout({
    this.week,
    this.weekUid,
    this.isSelected,
    this.day,
    this.workoutName,
    this.exercises,
    this.uid,
  });
}
