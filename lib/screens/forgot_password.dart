import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixit/utility/my_style.dart';
import 'package:fixit/utility/normal_dialog.dart';
import 'package:fixit/utility/normal_toast.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            MyStyle().backButton(context),
            showContent(),
          ],
        ),
      ),
    );
  }

  Future<Null> sentEmailThread() async {
    if (email == null || email.isEmpty) {
      normalDialog(context, 'กรุณากรอก Email ด้วยครับ');
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .sendPasswordResetEmail(email: email)
          .then(
            (value){
              normalToast('ส่ง Email สำเร็จแล้วครับ');
              Navigator.pop(context);
            },
          )
          .catchError((value) {
            String string = value.code;
            normalDialog(context, string);
          });
    }
  }

  Widget showContent() {
    return Center(
      child: Container(
        width: 250.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value.trim(),
              decoration: InputDecoration(
                labelText: 'Email :',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            Container(
              width: 250.0,
              child: OutlineButton.icon(
                  onPressed: () => sentEmailThread(),
                  icon: Icon(Icons.cloud_upload),
                  label: Text('Sent Email')),
            )
          ],
        ),
      ),
    );
  }
}
