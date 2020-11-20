import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class WorkoutPlanCardWidget extends StatelessWidget {
  final PickedFile imageUri;

  const WorkoutPlanCardWidget({
    Key key,
    this.imageUri,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: imageUri == null
                      ? Icon(
                          Icons.image,
                          color: Colors.grey.shade800,
                          size: 100,
                        )
                      : Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(imageUri.path),
                            ),
                          ),
                        ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                      child: Text(
                        'Bodybuilding',
                      ),
                    ),
                    Icon(
                      CupertinoIcons.circle_fill,
                      size: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Gym'),
                    ),
                    Icon(
                      CupertinoIcons.circle_fill,
                      size: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Advanced'),
                    ),
                  ],
                ),
                Text(
                  "The Rock's Ultimate Mass Builder Plan",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    SmoothStarRating(
                      rating: 5,
                    ),
                    Text(
                      '5.0(939)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
                Text(
                  '\$9.99',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
