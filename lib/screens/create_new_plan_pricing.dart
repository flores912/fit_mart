import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'create_new_plan_cover.dart';

class CreateNewPlanPricingScreen extends StatefulWidget {
  static const String title = ' Step 5 of 7: Pricing';
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
            onPressed: () {
              Navigator.pushNamed(context, CreateNewPlanCoverScreen.id);
            },
            textColor: Colors.white,
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '\$',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Expanded(
                  child: CustomTextForm(
                    textInputType: TextInputType.number,
                    textInputFormatter: [
                      CurrencyTextInputFormatter(),
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(RegExp('[0-9 .]')),
                    ],
                    labelText: 'Price',
                    obscureText: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'USD',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
