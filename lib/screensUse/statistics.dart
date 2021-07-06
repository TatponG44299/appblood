import 'dart:convert';

import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appblood/model/historyuse.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

var count;

class _StatisticsState extends State<Statistics> {
  var res;
  var count;

  HistoryModel historyModl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readata();
  }

  Future<Null> readata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url =
        '${Urlcon().domain}/GGB_BD/gethistoryUser.php?isAdd=true&ID=$id';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    for (var map in res) {
      setState(() {
        historyModl = HistoryModel.fromJson(map);
      });
      //print(historyModl.firstName);

    }
    //print('fname ==========${res.}');
    count = res.length;
    print(count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการบริจาคโลหิต'),
      ),
      body: res == 0
          ? MyStyle().showProgress()
          : res == null
              ? Text('ไม่มีข้อมูลการบริจาค')
              : SingleChildScrollView(child: showColumnhade()),
    );
  }

  Widget showColumnhade() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Title(
            color: Colors.blue,
            child: Text(
              'จำนวนที่บริจาค: $count ',
              style: TextStyle(fontSize: 18, color: Colors.blue[900]),
            ),
          ),
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
                  'ครั้งที่',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'โครงการที่บริจาค',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Title(
                color: Colors.blue,
                child: Text(
                  'ผู้รับผิดชอบ',
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
                res[index]['Project_Name'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                res[index]['Responsible_Name'],
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
}
