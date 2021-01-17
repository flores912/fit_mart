import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  static const String title = 'Sales';

  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  String coverPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          Card(
            child: ExpansionCard(
              margin: EdgeInsets.zero,
              title: ListTile(
                leading: Container(
                  color: CupertinoColors.white,
                  height: 100,
                  width: 100,
                ),
                title: Text('JEFF SEID PLAN'),
                subtitle: Row(
                  children: [
                    Text('100 Sales'),
                    Text(' (\$1,100.99)'),
                  ],
                ),
              ),
              children: [
                //TODO insert listview here
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      height: 100,
                      width: 100,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Karla Flores bought your plan for \$10.99'),
                    subtitle: Text(DateTime.now().toString()),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      height: 100,
                      width: 100,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    title: Text('Karla Flores bought your plan for \$10.99'),
                    subtitle: Text(DateTime.now().toString()),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
