import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class BuyWorkoutPlanCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String trainer;
  final double price;
  final int numOfReviews;

  var rating;

  BuyWorkoutPlanCard(
      {@required this.imageUrl,
      @required this.title,
      @required this.trainer,
      @required this.rating,
      @required this.price,
      @required this.numOfReviews});
  //firebase converts doubles with 0 into integers so we gotta do this check first
  double getRating() {
    if (rating is int) {
      rating = rating.toDouble();
    }
    return rating;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.network(
                  imageUrl,
                  width: Size.infinite.width,
                  height: 150.0,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                        child: Text(
                          trainer,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            rating.toDouble().toString(),
                            style: TextStyle(
                              color: Colors.grey.shade900,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                            child: SmoothStarRating(
                                allowHalfRating: true,
                                onRated: (v) {},
                                starCount: 5,
                                rating: getRating(),
                                size: 18.0,
                                isReadOnly: true,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                color: Colors.red,
                                borderColor: Colors.red,
                                spacing: 0.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                            child: Text(
                              '(${numOfReviews.toString()})',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                        child: Text(
                          '\$${price.toString()}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
