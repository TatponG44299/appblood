import 'dart:convert';

import 'package:appblood/model/useDonate_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/widgetscreensUse/showinfo_donate.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notfic extends StatefulWidget {
  @override
  _NotficState createState() => _NotficState();
}

class _NotficState extends State<Notfic> {
  var res, projectName, date;
  List<UseDonate> useDonates = List();

  @override
  void initState() {
    super.initState();
    readDataDonate();
  }

  Future<Null> readDataDonate() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //String id = preferences.getString('id');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url =
        '${Urlcon().domain}/GGB_BD/getdataUseDonate.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print(res[0]['ID_Project']);
    // int inex = 0;

    for (var map in res) {
      UseDonate useDonate = UseDonate.fromJson(map);
      setState(() {
        useDonates.add(useDonate);
        //print(useDonates);
      });
      //projectModels.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ขอรับบริจาคโลหิตด่วน'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.control_point),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => RequestInfo(),
          //       ),
          //     );
          //   },
          // ),
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
              title: Text("ผู้ที่ต้องการโลหิต: " + res[index]['ReceiverName']),
              subtitle: Text("หมู่โลหิตที่ต้องการ: " + res[index]['BloodType']),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                //print('print============$index');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Detaildonate(useDonateModel: useDonates[index]),
                  ),
                );
              },
            ),
          );
        });
  }
}
