import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fit_mart/blocs/create_plan/price_screen_bloc.dart';
import 'package:fit_mart/blocs/create_plan/price_screen_bloc_provider.dart';
import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cover_screen.dart';

class PriceScreen extends StatefulWidget {
  static const String title = ' Step 5 of 7: Price';
  static const String id = 'price_screen';

  final bool isEdit;
  final String workoutPlanUid;
  final double price;

  const PriceScreen({Key key, this.isEdit, this.workoutPlanUid, this.price})
      : super(key: key);

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {
  PriceScreenBloc _bloc;

  String price;

  @override
  void initState() {
    if (widget.price != null) {
      price = widget.price.toString();
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = PriceScreenBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PriceScreen.title),
        centerTitle: true,
        actions: [
          widget.isEdit == true
              ? FlatButton(
                  onPressed: () {
                    _bloc
                        .updateWorkoutPlanPrice(
                          widget.workoutPlanUid,
                          double.parse(price),
                        )
                        .whenComplete(() => Navigator.pop(context));
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              : FlatButton(
                  onPressed: () {
                    _bloc
                        .updateWorkoutPlanPrice(
                          widget.workoutPlanUid,
                          double.parse(price),
                        )
                        .whenComplete(
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CoverScreen(
                                workoutPlanUid: widget.workoutPlanUid,
                              ),
                            ),
                          ),
                        );
                  },
                  textColor: Colors.white,
                  child: Text(
                    'Next',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
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
                    initialValue: price,
                    onChanged: (value) {
                      setState(() {
                        price = value;
                      });
                    },
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
