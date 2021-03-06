import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/model/historyuse.dart';
import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donorlist.dart';

class InfostaticsProject extends StatefulWidget {
  final ProjectModel projectModel;

  const InfostaticsProject({Key key, this.projectModel}) : super(key: key);

  @override
  _InfostaticsProjectState createState() => _InfostaticsProjectState();
}

class _InfostaticsProjectState extends State<InfostaticsProject> {
  var res, resUse, idp, iduse, ga, gb, go, gab, g;
  ProjectModel projectModel;
  HistoryModel historyModel;
  AccountModel accountModel;
  List<ProjectModel> projectModels = [];
  List<AccountModel> accountModels = [];
  List resUser = [];
  List gA = [];
  List gB = [];
  List gO = [];
  List gAB = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectModel = widget.projectModel;
    readata();
  }

  Future<Null> readata() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //String id = preferences.getString('id');
    idp = projectModel.iDProject;

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url =
        '${Urlcon().domain}/GGB_BD/gethistoryProject.php?isAdd=true&ID_Project=$idp';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print(res.length['ID']);
    //print(res[0]['ID_History']);
    for (var map in res) {
      historyModel = HistoryModel.fromJson(map);
      setState(() {
        iduse = historyModel.iD;
        g = historyModel.bloodType;
        if (g == 'A') {
          gA.add(g);
        } else if (g == 'B') {
          gB.add(g);
        } else if (g == 'O') {
          gO.add(g);
        } else {
          gAB.add(g);
        }
      });
      // print('55555555555555555555555555555555555555555555555' + g);
      // //print('**************************' + res.toString());
      // print("ABABABABABABAB=${gAB.length}");
      // print("AAAAAAAAAAAAAA=${gA.length}");
      // print("BBBBBBBBBBBBBb=${gB.length}");
      // print("OOOOOOOOOOOOOO=${gO.length}");
      //readataUse();
      //setMarker.add(resultMarker());

    }
  }

  // Future<Null> readataUse() async {
  //   String url =
  //       '${Urlcon().domain}/GGB_BD/getUserWhereID.php?isAdd=true&ID=$iduse';

  //   Response response = await Dio().get(url);
  //   resUse = json.decode(response.data);
  //   for (var map in resUse) {
  //     accountModel = AccountModel.fromJson(map);
  //     resUser.add(resUse);
  //   }
  //   // resUser.add(resUse);
  //   print('====================' + resUser.toString());
  //   //print('************************${accountModel.iD}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถิติโครงการ'),
      ),
      body: res == null
          ? Center(child: Text('ไม่มีข้อมูลการบริจาค'))
          : idp == null
              ? MyStyle().showProgress()
              : SingleChildScrollView(child: showColumnhade()),
    );
  }

  Widget showColumnhade() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                  child: Title(
                    color: Colors.blue,
                    child: Text(
                      'จำนวนคนมาที่บริจาค',
                      style: TextStyle(fontSize: 20, color: Colors.blue[900]),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //titleHead(),
          textColum1(),
          textColum2(),
          textgbA(),
          gbA(),
          textgbB(),
          gbB(),
          textgbO(),
          gbO(),
          textgbAB(),
          gbAB(),
          gbAll(),
          detillButton(),
          //buildListData(),
        ],
      ),
    );
  }

  Widget textColum1() {
    return Container(
        margin: EdgeInsets.only(top: 80, left: 30),
        child: Column(
          children: <Widget>[
            Text(
              "หมู่เลือด",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget textColum2() {
    return Container(
        margin: EdgeInsets.only(top: 80, left: 290),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "จำนวน",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget textgbA() {
    return Container(
        margin: EdgeInsets.only(top: 140, left: 55),
        child: Column(
          children: <Widget>[
            Text(
              "A",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget gbA() {
    return Container(
        margin: EdgeInsets.only(top: 140, left: 310),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${gA.length}",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget textgbB() {
    return Container(
        margin: EdgeInsets.only(top: 200, left: 55),
        child: Column(
          children: <Widget>[
            Text(
              "B",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget gbB() {
    return Container(
        margin: EdgeInsets.only(top: 200, left: 310),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${gB.length}",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget textgbO() {
    return Container(
        margin: EdgeInsets.only(top: 260, left: 55),
        child: Column(
          children: <Widget>[
            Text(
              "O",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget gbO() {
    return Container(
        margin: EdgeInsets.only(top: 260, left: 310),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${gO.length}",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget textgbAB() {
    return Container(
        margin: EdgeInsets.only(top: 320, left: 55),
        child: Column(
          children: <Widget>[
            Text(
              "AB",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget gbAB() {
    return Container(
        margin: EdgeInsets.only(top: 320, left: 310),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "${gAB.length}",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget gbAll() {
    return Container(
        margin: EdgeInsets.only(top: 380, left: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "รวมทั้งหมด   ${res.length}   คน",
              style: TextStyle(fontSize: 18),
            )
          ],
        ));
  }

  Widget titleHead() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.red[200]),
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              //flex: 1,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'คนที่',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              //flex: 2,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'ผู้ที่มาบริจาค',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              //flex: 1,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'หมู่เลือด',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListData() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: res.length,
        itemBuilder: (context, index) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text('${index + 1}'),
            ),
            Expanded(
              flex: 2,
              child: Text(
                res[index]['First_name'] + ' ' + res[index]['Last_name'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                res[index]['Blood_type'],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );

  Container detillButton() => Container(
      margin: EdgeInsets.only(top: 460, left: 200),
      //width: 250.0,
      child: ClipRRect(
        //ลดเหลี่ยมปุ่ม
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.redAccent[700],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Donorlist(
                  projectModel: idp,
                ),
              ),
            );

            //Donorlist();
            print('*************************=$idp');
          },
          child: Text(
            'รายชื่อผู้มาบริจาค',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ));
}
