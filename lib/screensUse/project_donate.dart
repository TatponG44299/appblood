import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgetscreensUse/info_project.dart';

class ProjectDonate extends StatefulWidget {
  @override
  _ProjectDonateState createState() => _ProjectDonateState();
}

class _ProjectDonateState extends State<ProjectDonate> {
//เปลี่ยนด้วนนะ อย่าลืม
  //ProjectModel projectModel;
  var res, projectName, date;

  //ProjectModel projectModel = ProjectModel();
  List<ProjectModel> projectModels = List();

  @override
  void initState() {
    super.initState();
    readDataDonate();
  }

  Future<Null> readDataDonate() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String code = preferences.getString('code');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url = '${Urlcon().domain}/GGB_BD/getdataProject.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    print(res[0]['ID_Project']);
    // int inex = 0;

    for (var map in res) {
      ProjectModel projectModel = ProjectModel.fromJson(map);
      setState(() {
        projectModels.add(projectModel);
      });
      //projectModels.add(model);
    }

  }

  //  Future<Null> routeLoginpage(
  //     Widget myWidget, ProjectModel projectModel) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   //แชร์ข้อมูลไปส่วนต่างๆได้หลังจาก login
  //   preferences.setString('iDProject', projectModel.iDProject);
  //   preferences.setString('email', projectModel.email);

  //   MaterialPageRoute route = MaterialPageRoute(
  //     builder: (value) => myWidget,
  //   );

  //   Navigator.pushAndRemoveUntil(context, route, (route) => false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โครงการรับบริจาค'),
      ),
      body: res == null ? MyStyle().showProgress() : listCardshow(),
    );
  }

  ListView listCardshow() {
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
                        ProjectInfo(projectModel: projectModels[index]),
                  ),
                );

              },
            ),
          );
        });
  }
}
