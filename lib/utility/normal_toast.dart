import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<Null> normalToast(String string) async {
  Fluttertoast.showToast(
    msg: string,
    toastLength: Toast.LENGTH_LONG,
  );
}
