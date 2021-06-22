import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/screensUse/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRcode extends StatefulWidget {
  //const QRcode({ Key? key }) : super(key: key);

  @override
  _QRcodeState createState() => _QRcodeState();
}

class _QRcodeState extends State<QRcode> {
  String qrData; // already generated qr code when the page opens

  final qrdataFeed = TextEditingController();
  AccountModel accountModel;
  String data = '';
  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  //อ่านข้อมูลจากตาราง data
  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${Urlcon().domain}/GGB_BD/getUserWhereID.php?isAdd=true&ID=$id';
    await Dio().get(url).then((value) {
      //print('Value = $value');
      var result = json.decode(value.data);
      //print('result==$result');
      for (var map in result) {
        //print('fname == ${accountModel.firstName}');
        setState(() {
          accountModel = AccountModel.fromJson(map);
        });
        data = accountModel.iD.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (value) => Home());
            Navigator.push(context, route);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              qrData == null
                  ? showText()
                  : QrImage(
                      //plce where the QR Image will be shown
                      data: qrData,
                    ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "รหัสประจำตัว: $data",
                style: TextStyle(fontSize: 20.0),
              ),
              // TextField(
              //   controller: qrdataFeed,
              //   decoration: InputDecoration(
              //     hintText: "Input your link or data",
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: FlatButton(
                  padding: EdgeInsets.all(15.0),
                  onPressed: () async {
                    // if (qrdataFeed.text.isEmpty) {
                    //   //a little validation for the textfield
                    //   setState(() {
                    //     qrData = "";
                    //   });
                    // } else {
                    setState(() {
                      qrData = data;
                      //qrdataFeed.text;
                    });
                    //}
                  },
                  child: Text(
                    "Generate QR",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Generator QR Code',
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }
}
