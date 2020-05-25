import 'package:flutter/material.dart';

class MyStyle {

  Widget showProgress(){
    return Center(child: CircularProgressIndicator(),);
  }

  Widget showTitleH1(String string) {
    return Text(
      string,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget showTitleH2(String string) {
    return Text(
      string,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  Widget backButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.navigate_before,
        size: 36.0,
        color: Colors.yellow.shade900,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  MyStyle();
}
