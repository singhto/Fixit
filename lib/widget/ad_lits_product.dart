import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fixit/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:image_picker/image_picker.dart';

class AddListProduct extends StatefulWidget {
  @override
  _AddListProductState createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  List<String> typeFixits = List();
  String chooseTypeFixit,
      showName,
      showDetail,
      showPro,
      showAmp,
      showDis,
      urlPicture;
  File file;

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
          showProvince(),
          showAmphures(),
          showDistricts(),
          uploadButton(),
        ],
      ),
    );
  }

  Widget showDistricts() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: MyStyle().showTitleH2('ตำบล :'),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (String string) {
                  showDis = string.trim();
                },
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

  Widget showAmphures() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: MyStyle().showTitleH2('อำเภอ :'),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (String string) {
                  showAmp = string.trim();
                },
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

  Widget showProvince() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: MyStyle().showTitleH2('จังหวัด :'),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (String string) {
                  showPro = string.trim();
                },
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

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: Colors.grey.shade500,
            onPressed: () {
              print('you Click up');

              if (file == null) {
                showAlert('ไม่ได้เลือกภาพ', 'กรุณาเลือกภาพ');
              } else if (showName == null || showName.isEmpty) {
                showAlert('ไม่ได้ใส่ชื่อร้าน', 'กรุณาใส่ด้วยครับ');
              } else if (showDetail == null || showDetail.isEmpty) {
                showAlert('ไม่ได้ใส่รายละเอียด', 'กรุณาใส่รายละเอียดด้วยครับ');
              } else if (showPro == null || showPro.isEmpty) {
                showAlert('ไม่ได้เลือกจังหวัด', 'กรุณาเลือกจังหวัดด้วยครับ');
              } else if (showAmp == null || showAmp.isEmpty) {
                showAlert('ไม่ได้เลือกอำเภอ', 'กรุณาเลือกอำเภอด้วยครับ');
              } else if (showDis == null || showDis.isEmpty) {
                showAlert('ไม่ได้เลือกตำบล', 'กรุณาเลือกตำบลด้วยครับ');
              } else {
                // Upload Value To Firebase
                uploadPictureToStorage();
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.yellow.shade800,
            ),
            label: Text(
              'Upload Data',
              style: TextStyle(color: Colors.yellow.shade800),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Product/product$i.jpg');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('urlPicture = $urlPicture');
    insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    Firestore firestore = Firestore.instance;

    Map<String, dynamic> map = Map();
    map['NameShop'] = showName;
    map['Detail'] = showDetail;
    map['Province'] = showPro;
    map['Amp'] = showAmp;
    map['Tritric'] = showDis;
    map['Photo'] = urlPicture;

    await firestore
        .collection('Fixitman')
        .document()
        .setData(map)
        .then((value) {
          print('Inser Success');
        });
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  }

  Widget showNameShop() => Container(
        margin: EdgeInsets.only(top: 16.0),
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
                onChanged: (String string) {
                  showName = string.trim();
                },
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

  Widget showDetailShop() => Container(
        margin: EdgeInsets.only(top: 16.0),
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
                onChanged: (String string) {
                  showDetail = string.trim();
                },
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
        children: <Widget>[
          Expanded(
            flex: 1,
            child: MyStyle().showTitleH2('เลือกช่าง :'),
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

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget showPic(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_a_photo,
              size: 36.0,
              color: Colors.yellow.shade800,
            ),
            onPressed: () {
              chooseImage(ImageSource.camera);
            },
          ),
          Container(
            width: MediaQuery.of(context).size.height * 0.25,
            height: MediaQuery.of(context).size.height * 0.25,
            child:
                file == null ? Image.asset('images/pic.png') : Image.file(file),
          ),
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
              color: Colors.yellow.shade800,
            ),
            onPressed: () {
              chooseImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
