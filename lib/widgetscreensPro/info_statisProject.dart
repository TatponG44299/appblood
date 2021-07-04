import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/model/historyuse.dart';
import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfostaticsProject extends StatefulWidget {
  final ProjectModel projectModel;

  const InfostaticsProject({Key key, this.projectModel}) : super(key: key);

  @override
  _InfostaticsProjectState createState() => _InfostaticsProjectState();
}

class _InfostaticsProjectState extends State<InfostaticsProject> {
  var res, resUse, idp, iduse;
  ProjectModel projectModel;
  HistoryModel historyModel;
  AccountModel accountModel;
  List<AccountModel> accountModels = List();
  List resUser = List();
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
      });

      print('**************************' + res.toString());
      print(res.length);
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
        title: Text('ผู้ที่บริจาค'),
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
      child: Column(
        children: <Widget>[
          // Title(
          //   color: Colors.blue,
          //   child: Text(
          //     'จำนวนที่บริจาค:  ',
          //     style: TextStyle(fontSize: 18, color: Colors.blue[900]),
          //   ),
          // ),
          titleHead(),
          buildListData(),
        ],
      ),
    );
  }

  Widget titleHead() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.red[200]),
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'คนที่',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'ผู้ที่มาบริจาค',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 1,
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
}
