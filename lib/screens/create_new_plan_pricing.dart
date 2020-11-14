import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNewPlanPricingScreen extends StatefulWidget {
  static const String title = ' Step 4 of 4: Pricing';
  static const String id = 'create_new_plan_pricing_screen';

  @override
  CreateNewPlanPricingScreenState createState() =>
      CreateNewPlanPricingScreenState();
}

class CreateNewPlanPricingScreenState
    extends State<CreateNewPlanPricingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreateNewPlanPricingScreen.title),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {},
            textColor: Colors.white,
            child: Text(
              'Publish',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
