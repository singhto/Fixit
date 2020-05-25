import 'package:flutter/material.dart';

Future<Null> normalDialog(BuildContext context, String title) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(title),
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(width: 150.0,
              child: OutlineButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
