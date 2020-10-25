import 'package:fit_mart/models/set.dart';
import 'package:flutter/cupertino.dart';

class Exercise {
  final int sets;
  final String title;
  final String uid;
  final String videoUrl;
  final bool isSelected;
  Exercise({
    @required this.sets,
    @required this.isSelected,
    @required this.videoUrl,
    @required this.uid,
    @required this.title,
  });
}
