import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class WorkoutPlanCardWidget extends StatelessWidget {
  final Widget image;

  final String category;

  final int rating;

  final int numberOfReviews;

  final String title;

  final String location;

  final String skillLevel;

  final double price;

  final bool isFree;

  const WorkoutPlanCardWidget({
    Key key,
    this.image,
    this.category,
    this.rating,
    this.numberOfReviews,
    this.title,
    this.location,
    this.skillLevel,
    this.price,
    this.isFree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: image == null
                  ? Container(
                      height: MediaQuery.of(context).size.width / 1.5 / 1.78,
                      child: Icon(
                        Icons.image,
                        color: Colors.grey.shade800,
                        size: 100,
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.width / 1.5 / 1.78,
                      child: image,
                    ),
            ),
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: category != null
                        ? Text(
                            category,
                          )
                        : Text(
                            '(Category)',
                          )),
                Icon(
                  CupertinoIcons.circle_fill,
                  size: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: location != null
                      ? Text(
                          location,
                        )
                      : Text(
                          '(Location)',
                        ),
                ),
                Icon(
                  CupertinoIcons.circle_fill,
                  size: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: skillLevel != null
                      ? Text(
                          skillLevel,
                        )
                      : Text(
                          '(Skill Level)',
                        ),
                ),
              ],
            ),
            title != null
                ? Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                : Text(
                    '(No title Added)',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
            Row(
              children: [
                SmoothStarRating(
                  rating: rating == null ? 0 : rating.toDouble(),
                ),
                rating != null
                    ? Text(
                        rating.toString() + '(${numberOfReviews})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : Text(
                        0.toString() + '(${0})',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      )
              ],
            ),
            isFree == true
                ? Text(
                    'Free',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    price != null ? '\$ ${price}' : '(No Price Added)',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
