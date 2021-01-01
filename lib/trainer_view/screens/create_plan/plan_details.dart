import 'package:fit_mart/trainer_view/blocs/plan_details_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_mart/constants.dart';

class PlanDetails extends StatefulWidget {
  final bool isEdit;
  final String workoutPlanUid;

  const PlanDetails({Key key, this.isEdit, this.workoutPlanUid})
      : super(key: key);
  @override
  _PlanDetailsState createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {
  PlanDetailsBloc _bloc = PlanDetailsBloc();

  String title;

  String description;

  dynamic price;

  bool isFree;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.isEdit == true) {
      _bloc.getPlanDetails(widget.workoutPlanUid).then((value) {
        title = value.get('title');
        description = value.get('price');
        isFree = value.get('isFree');
        if (isFree == true) {
          price = kFree;
        }
      });
    } else {
      //set default price for new workout - free
      price = kPriceList.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            child: Text(kNext),
            onPressed: () {
              if (widget.isEdit == true) {
                //don't create a new workout and only update fields
              } else {
                //is new so create a new one

                //check if its free to add details to DB accordingly
                checkIfFree();
                //validate fields before creating new plan
                if (_formKey.currentState.validate()) {
                  _bloc.createNewPlan(title, description, price, isFree);
                }
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                validator: (value) {
                  title = value;
                  if (title.isEmpty) {
                    return kRequired;
                  }
                  return null;
                },
                maxLines: 1,
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(
                  labelText: kTitle + '*',
                  alignLabelWithHint: true,
                ),
              ),
              TextFormField(
                maxLines: 6,
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(
                  labelText: kDescription + kOptional,
                  alignLabelWithHint: true,
                ),
              ),
              DropdownButton(
                value: price,
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                },
                items: dropdownMenuItems(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> dropdownMenuItems() {
    List<DropdownMenuItem> items = List();
    for (dynamic price in kPriceList) {
      items.add(
        DropdownMenuItem(
          value: price,
          child: Text('\$' + price.toString()),
        ),
      );
    }
    return items;
  }

  checkIfFree() {
    if (price == kFree) {
      isFree = true;
      price = null;
    } else {
      isFree = false;
    }
  }
}
