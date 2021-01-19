class Set {
  final int set;
  final int reps;
  final int rest;
  final String setUid;
  final bool isTimed;
  final bool isFailure;
  final bool isSetInMin;
  final bool isRestInMin;

  Set({
    this.isSetInMin,
    this.isRestInMin,
    this.isTimed,
    this.isFailure,
    this.set,
    this.reps,
    this.rest,
    this.setUid,
  }); //in secs
}
