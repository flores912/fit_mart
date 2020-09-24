import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'buy_workout_plan_card.dart';

class WorkoutPlansList extends StatelessWidget {
  String category;

  WorkoutPlansList(this.category);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Trending in ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('workout plans')
              .where('category', isEqualTo: category)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final workoutPlans = snapshot.data.docs.reversed;
            List<BuyWorkoutPlanCard> workoutPlanCards = [];
            for (var workoutPlan in workoutPlans) {
              final title = workoutPlan.get('title');
              final trainer = workoutPlan.get('trainer');
              final rating = workoutPlan.get('rating');
              final imageUrl = workoutPlan.get('imageUrl');
              final price = workoutPlan.get('price');
              final numOfReviews = workoutPlan.get('reviews');

              final workoutPlanCard = BuyWorkoutPlanCard(
                title: title,
                trainer: trainer,
                rating: rating,
                imageUrl: imageUrl,
                price: price,
                numOfReviews: numOfReviews,
              );
              workoutPlanCards.add(workoutPlanCard);
            }
            return Container(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: workoutPlanCards,
              ),
            );
          },
        ),
      ],
    );
  }
}
