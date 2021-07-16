import 'dart:convert';

import 'package:appblood/model/historyuse.dart';
import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Donorlist extends StatefulWidget {
  final projectModel;

  const Donorlist({Key key, this.projectModel}) : super(key: key);

  @override
  _DonorlistState createState() => _DonorlistState();
}

class _DonorlistState extends State<Donorlist> {
  var idp, res, iduse, g;

  HistoryModel historyModel;
  ProjectModel projectModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idp = widget.projectModel;
    print('$idp');
    readata();
  }

  Future<Null> readata() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    //String id = preferences.getString('id');
    //idp = projectModel.iDProject;

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
        // if (g == 'A') {
        //   gA.add(g);
        // } else if (g == 'B') {
        //   gB.add(g);
        // } else if (g == 'O') {
        //   gO.add(g);
        // } else {
        //   gAB.add(g);
        // }
      });
      print('*************************$iduse');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อผู้บริจาค'),
      ),
      body: res == null
          ? Center(child: Text('ไม่มีข้อมูลการบริจาค'))
          : idp == null
              ? MyStyle().showProgress()
              : showColumnhade(),
    );
  }

  Widget showColumnhade() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              titleHead(),
              buildListData(),
            ],
          )
        ],
      ),
    );
  }

  Widget titleHead() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(color: Colors.red[200]),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Title(
              color: Colors.blue,
              child: Text(
                'ลำดับ',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Title(
              color: Colors.blue,
              child: Text(
                'รายชื่อ',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            // flex: 1,
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
              child: Text('     ${index + 1}'),
            ),
            Expanded(
              flex: 2,
              child: Text('        '+
                res[index]['First_name'] + '      ' + res[index]['Last_name'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              //flex: 1,
              child: Text('          '+
                res[index]['Blood_type'],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
}
