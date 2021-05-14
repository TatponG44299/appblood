import 'package:appblood/model/accout_model.dart';
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
  AccountModel pDonateModel;

  @override
  void initState() {
    super.initState();
    readDatapDonate();
  }

  Future<Null> readDatapDonate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String code = preferences.getString('code');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url =
        '${Urlcon().domain}/GGB_BD/getUserWhereUser.php?isAdd=true&Email=$code';
    await Dio().get(url).then((value) {
      print('value = $value');
    });
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
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, int index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              title: Text("ชื่อโครงการ"),
              subtitle: Text("วันที่เริ่ม-วันที่จบการรับบริจาค"),
              onTap: () {
                Navigator.pop(context);
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => ProjectInfo());
                Navigator.push(context, route);
              },
            ),
          );
        });
  }
}
