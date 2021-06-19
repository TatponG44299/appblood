import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/screensPro/addper_proinfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Proinfo extends StatefulWidget {
  @override
  _ProinfoState createState() => _ProinfoState();
}

class _ProinfoState extends State<Proinfo> {
  AccountModel accountModel;

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
      print('Value = $value');
      var result = json.decode(value.data);
      print('result==$result');
      for (var map in result) {
        //print('fname == ${accountModel.firstName}');
        setState(() {
          accountModel = AccountModel.fromJson(map);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.purple[900]),
        backgroundColor: Color(0xff4a148c),
        title: Text('ข้อมูลส่วนตัว'),
      ),
      body: Stack(
        children: <Widget>[
          accountModel == null
              ? MyStyle().showProgress()
              : accountModel.firstName.isEmpty
                  ? showtext() //showNodata(context)
                  : showDatainfo(),
          addUsedata(),
        ],
      ),
    );
  }

  Widget showDatainfo() => Column(
        children: <Widget>[
          showimage(),
          idtextshow(),
          nameTextshow(),
          agetextshow(),
          phontextshow(),
          infotextshowone(),
          infotextshowtwo(),
        ],
      );

  Widget showimage() => Container(
        margin: EdgeInsets.only(top: 25),
        child: ClipOval(
          child: Image.network(
            '${Urlcon().domain}${accountModel.urlPicture}',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget idtextshow() => Container(
        margin: EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ตำแหน่ง/หน้าที่ : ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[900],
              ),
            ),
            Text(
              '${accountModel.idCustom}',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      );

  Widget nameTextshow() => Container(
        margin: EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ชื่อ : ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[900],
              ),
            ),
            Text(
              '${accountModel.firstName}   ${accountModel.lastName} ',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      );

  Widget agetextshow() => Container(
        margin: EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'อายุ : ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[900],
              ),
            ),
            Text(
              '${accountModel.bloodType} ปี',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      );

  Widget phontextshow() => Container(
        margin: EdgeInsets.only(top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'มือถือ : ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[900],
              ),
            ),
            Text(
              '${accountModel.phon}',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      );

  Widget infotextshowone() => Container(
        margin: EdgeInsets.only(top: 25, right: 25, left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ที่อยู่ : ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.purple[900],
              ),
            ),
            Text(
              '${accountModel.addDetail} ${accountModel.tombol} ',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      );
  Widget infotextshowtwo() => Container(
        margin: EdgeInsets.only(top: 25, right: 25, left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' ${accountModel.district} ${accountModel.county}',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      );

  Widget showtext() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ยังไม่มีข้อมูล",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      );

  //ปุ่มกด button
  Row addUsedata() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.purple[900],
                child: Icon(Icons.edit),
                onPressed: () => addEditdata(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addEditdata() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (context) => Addproinfodata());
    Navigator.push(context, materialPageRoute);
  }
}
