import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'info_project.dart';

class ProjectDonate extends StatefulWidget {
  @override
  _ProjectDonateState createState() => _ProjectDonateState();
}

class _ProjectDonateState extends State<ProjectDonate> {
//เปลี่ยนด้วนนะ อย่าลืม
  ProjectModel projectModel;
  var res, projectName, date;

  @override
  void initState() {
    super.initState();
    readDatapDonate();
  }

  Future<Null> readDatapDonate() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String code = preferences.getString('code');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url = '${Urlcon().domain}/GGB_BD/getdataProject.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print(res[0]['ID_Project']);

    for (var index = 0; index < res.length; index++) {
      //print(res[index]);
    }
    //return res;
    // if(projectModel.projectName != null){

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โครงการรับบริจาค'),
      ),
      body: listCardshow(),
    );
  }

  ListView listCardshow() {
    //readDatapDonate();
    print(res);

    return ListView.builder(
        itemCount: res.length,
        itemBuilder: (context, int index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              title: Text("ชื่อโครงการ: " + res[index]['Project_Name']),
              subtitle:
                  Text("วันที่เริ่ม-วันที่จบการรับบริจาค: " + res[index]['Date']),
              onTap: () {

              },
            ),
          );
        });
  }
}
