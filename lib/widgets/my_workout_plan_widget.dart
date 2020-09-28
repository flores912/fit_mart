import 'package:fit_mart/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWorkoutPlanWidget extends StatelessWidget {
  final String title;
  final double progressValue;
  final String trainer;
  final String imageUrl;

  MyWorkoutPlanWidget(
      this.title, this.progressValue, this.trainer, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Wrap(
      children: [
        Container(
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                height: 100,
                width: 100,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      trainer,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      color: Colors.black,
                      height: 2,
                      child: LinearProgressIndicator(
                        value:
                            progressValue, //in percentage - 1.0 is equal to 100%!!
                        backgroundColor: Colors.red.shade100,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${(progressValue * 100).round()}% complete',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
