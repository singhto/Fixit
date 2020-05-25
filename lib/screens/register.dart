import 'package:fixit/screens/my_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString;

  // Method
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('You Click Upload');
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'name = $nameString, email = $emailString, password =$passwordString');
          registerThread();
        }
      },
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Register Success for Email =  $emailString');
      setupDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title, message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nameString;
      response.updateProfile(userUpdateInfo);

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MyService());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              leading: Icon(
                Icons.add_alert,
                color: Colors.red,
                size: 48.0,
              ),
              title: Text(
                title,
                style: TextStyle(color: Colors.red),
              ),
            ),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget nameText() {
    return TextFormField(
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          color: Colors.yellow.shade800,
          size: 48.0,
        ),
        labelText: 'Name :',
        labelStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        helperText: 'กรอกชื่อของคุณ',
        helperStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'กรุณากรอกชื่อในช่องว่าง';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          color: Colors.yellow.shade800,
          size: 48.0,
        ),
        labelText: 'Email :',
        labelStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        helperText: 'กรอก Email ของคุณ',
        helperStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
      validator: (String value) {
        if (!((value.contains('@')) && (value.contains('.')))) {
          return 'พิมพ์รูปแบบ Email ให้ถูกต้อง you@email.com';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      style: TextStyle(color: Colors.grey),
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: Colors.yellow.shade800,
          size: 48.0,
        ),
        labelText: 'PassWord :',
        labelStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        helperText: 'กรอกรหัสผ่าน 6 หลัก',
        helperStyle: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
      validator: (String value) {
        if (value.length < 6) {
          return 'Password จะต้องไม่ต่ำกว่า 6 ตัวอักษร';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value.trim();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        title: Text('Register'),
        actions: <Widget>[registerButton()],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }
}
