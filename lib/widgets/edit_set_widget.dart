import 'package:fit_mart/widgets/custom_text_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditSetWidget extends StatelessWidget {
  final int set;
  final int reps;
  final int rest;
  final Function onChangedReps;
  final Function onChangedRest;

  const EditSetWidget(
      {Key key,
      this.set,
      this.reps,
      this.rest,
      this.onChangedReps,
      this.onChangedRest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Set ' + set.toString())),
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextForm(
                    textInputType: TextInputType.number,
                    obscureText: false,
                    onChanged: onChangedReps,
                    initialValue: reps != null ? reps.toString() : '',
                    labelText: 'reps',
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextForm(
                    textInputType: TextInputType.number,
                    obscureText: false,
                    onChanged: onChangedRest,
                    initialValue: rest != null ? rest.toString() : '',
                    labelText: 'rest(s)',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
