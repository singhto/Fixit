import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixit/utility/my_style.dart';
import 'package:flutter/material.dart';

class AddListProduct extends StatefulWidget {
  @override
  _AddListProductState createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  List<String> typeFixits = List();
  String chooseTypeFixit;

  @override
  void initState() {
    super.initState();
    readTypeFixit();
  }

  Future<Null> readTypeFixit() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference =
        firestore.collection('TypeFixitMan');
    await collectionReference.snapshots().listen((event) {
      for (var snapshot in event.documents) {
        String string = snapshot['Type'];
        print('Type ==>> $string');
        setState(() {
          typeFixits.add(string);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครช่าง'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          showPic(context),
          showTypeFixit(),
          showNameShop(),
          showDetailShop(),
        ],
      ),
    );
  }

  Widget showNameShop() => Container(margin: EdgeInsets.only(top: 16.0),
    child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: MyStyle().showTitleH2('ชื่อร้าน :'),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
  );

    Widget showDetailShop() => Container(margin: EdgeInsets.only(top: 16.0),
    child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: MyStyle().showTitleH2('รายละเอียด :'),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
  );

  Widget showTypeFixit() => Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('เลือกช่าง : '),
          ),
          Expanded(
            flex: 2,
            child: typeFixits.length == 0
                ? MyStyle().showProgress()
                : DropdownButton<String>(
                    value: chooseTypeFixit,
                    items: typeFixits
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    hint: Text('โปรดเลือกช่าง'),
                    onChanged: (value) {
                      print('value ==>> $value');
                      setState(() {
                        chooseTypeFixit = value;
                      });
                    },
                  ),
          )
        ],
      );

  Widget showPic(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () {},
          ),
          Container(
            width: MediaQuery.of(context).size.height * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Image.asset('images/pic.png'),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
