import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addproject.dart';
import 'setProject.dart';

class ListProject extends StatefulWidget {
  //const ListProject({ Key? key }) : super(key: key);

  @override
  _ListProjectState createState() => _ListProjectState();
}

class _ListProjectState extends State<ListProject> {
  var res, projectName, date;
  List<ProjectModel> projectModels = List();

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
        title: Text('เปิดโครงการรับบริจาค'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.control_point),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Addproject(),
                ),
              );
            },
          ),
        ],
      ),
      body: res == null ? MyStyle().showProgress() : listCardshow(),
    );
  }

  ListView listCardshow() {
    // buttonBar();
    return ListView.builder(
        itemCount: res.length,
        itemBuilder: (context, int index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              title: Text("ชื่อโครงการ: " + res[index]['Project_Name']),
              subtitle: Text("วันที่รับบริจาค: " + res[index]['SDate']),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                //print('print============$index');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditdataProject(projectModel: projectModels[index]),
                  ),
                );
              },
            ),
          );
        });
  }
}
