import 'dart:convert';

import 'package:appblood/model/useDonate_modail.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgetscreensUse/urgentdonation.dart';

class FastDonate extends StatefulWidget {
  @override
  _FastDonateState createState() => _FastDonateState();
}

class _FastDonateState extends State<FastDonate> {
  var res;

  List<UseDonate> useDonates = List();

  @override
  void initState() {
    super.initState();
    readDataDonate();
  }
  

  Future<Null> readDataDonate() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String code = preferences.getString('code');

    //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
    String url = '${Urlcon().domain}/GGB_BD/getdataUseDonate.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    print(res[0]['ID_request']);
    // int inex = 0;

    for (var map in res) {
      UseDonate useDonate = UseDonate.fromJson(map);
      setState(() {
        useDonates.add(useDonate);
      });
      //projectModels.add(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บริจาคโลหิตด่วน'),
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
              title: Text("ชื่อโครงการ: " + res[index]['AnnounceName']),
              subtitle: Text("วันที่รับบริจาค: " + res[index]['EndTime']),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                //print('print============$index');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReadUrgent(useDonate: useDonates[index]),
                  ),
                );
              },
            ),
          );
        });
  }
}
