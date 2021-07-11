import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/model/useDonate_model.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/widgetscreensPro/info_statisProject.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisicsProject extends StatefulWidget {
  //final ProjectModel projectModel;
  //const StatisicsProject({Key key, this.projectModel}) : super(key: key);

  @override
  _StatisicsProjectState createState() => _StatisicsProjectState();
}

class _StatisicsProjectState extends State<StatisicsProject> {
  var res;
  List<ProjectModel> projectModels = [];

  @override
  void initState() {
    super.initState();
    readDataDonate();
  }

  Future<Null> readDataDonate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url =
        '${Urlcon().domain}/GGB_BD/getdataProjectbyID.php?isAdd=true&ID_Use=$id';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print(res[0]['ID_Project']);
    // int inex = 0;

    for (var map in res) {
      ProjectModel projectModel = ProjectModel.fromJson(map);
      setState(() {
        projectModels.add(projectModel);
      });

      //projectModels.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการจัดตั้งโครงการ'),
      ),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      itemCount: res.length,
      itemBuilder: (context, int index) {
        return ListTile(
          title: Text('โครงการ: ' + res[index]['Project_Name']),
          subtitle: Text('วันที่สิ้นสุด: ' + res[index]['EDate']),
          leading: Icon(Icons.hotel),
          trailing: Icon(Icons.zoom_in),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InfostaticsProject(
                  projectModel: projectModels[index],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
