import 'dart:convert';

import 'package:appblood/model/useWantDonate_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:appblood/widgetscreensUse/query.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseWantDanate extends StatefulWidget {
  //const UseWantDanate({ Key? key }) : super(key: key);

  @override
  _UseWantDanateState createState() => _UseWantDanateState();
}

class _UseWantDanateState extends State<UseWantDanate> {
  UserWantDonate userwantDonate;
  var idDonate;
  bool values;
  bool state;
  String type1, type2, v, s;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> updatetype() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    //String type ;
    print('3373737373737373 ===$values');
    print('5555555555555555 ===$state');
    values == true ? type1 = '1' : type1 = '0';
    state == true ? type2 = '1' : type2 = '0';

    String url =
        '${Urlcon().domain}/GGB_BD/userWantDonate.php?isAdd=true&Quick_Donate=$type1&Project_Donate=$type2&ID_Use=$id&ID_UseDonate=$idDonate&acction=updateType';

    await Dio().get(url).then((data) {
      //print("================== + $url");
      if (data.toString() == 'true') {
        //Navigator.pop(context);
        normalDialog(context, 'อัพเดตข้อมูลสำเร็จ');
      } else {
        normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
        //Navigator.pop(context);
      }
    });
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${Urlcon().domain}/GGB_BD/getUserWantDonateWhereID.php?isAdd=true&ID_Use=$id';
    //if (){}

    // String url =
    //     '${Urlcon().domain}/GGB_BD/getUserWantDonateWhereID.php?isAdd=true&ID_Use=$id';
    await Dio().get(url).then((value) {
      //print('Value = $value');
      var result = json.decode(value.data);
      //print('result==$result');
      for (var map in result) {
        //print('fname == ${accountModel.firstName}');
        setState(() {
          userwantDonate = UserWantDonate.fromJson(map);
        });
      }
      idDonate = userwantDonate.iDUseDonate;
      v = userwantDonate.projectDonate;
      s = userwantDonate.quickDonate;

      v == '0' ? values = false : values = true;
      s == '0' ? state = false : state = true;

      //print('*******************************+' + v);
    }).catchError((onError) => print(onError));
  }

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('projectID'),
          position: LatLng(
            double.parse(userwantDonate.lat),
            double.parse(userwantDonate.lng),
          ),
          infoWindow: InfoWindow(
              title: 'ตำแหน่งโครงการ',
              snippet:
                  'ละติจูด = ${userwantDonate.lat},ลองติจูด = ${userwantDonate.lng}'))
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ต้องการบริจาคโลหิต'),
      ),
      body: Stack(
        children: <Widget>[
          userwantDonate == null
              ? MyStyle().showProgress()
              : userwantDonate.nameUser.isEmpty
                  ? showtext() //showNodata(context)
                  : showDatainfo(),
          addUsedata(),
        ],
      ),
    );
  }

  Widget showDatainfo() => Column(
        children: <Widget>[
          nameShow(),
          contactCall(),
          bloodType(),
          switButton1(),
          switButton2(),
          showMap(),

          //testswitch()
          //commitButton(),
          // phontextshow()
        ],
      );

  Padding switButton2() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        height: 40,
        //width: 300,
        child: Row(
          // mainAxisAlignment: ma,
          children: <Widget>[
            Text('การเเจ้งเตือนแบบโครงการ:   ', style: TextStyle(fontSize: 18)),
            Transform.scale(
              scale: 1.5,
              child: Switch.adaptive(
                activeColor: Colors.blueAccent,
                //activeTrackColor: Colors.,
                value: state,
                onChanged: (swi) {
                  setState(() {
                    swi == true ? this.state = true : this.state = false;
                    //this.value = swi;
                  });
                  updatetype();
                  //print('6666666666666666666666666666666666666666666$value');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding switButton1() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          Text('การแจ้งเตือนแบบโลหิตด่วน: ', style: TextStyle(fontSize: 18)),
          Transform.scale(
            scale: 1.5,
            child: Switch.adaptive(
              activeColor: Colors.blueAccent,
              //activeTrackColor: Colors.,
              value: values,
              onChanged: (swi) {
                setState(() {
                  swi == true ? this.values = true : this.values = false;
                  //this.value = swi;
                });
                updatetype();
                //print('6666666666666666666666666666666666666666666$value');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showMap() {
    double lat = double.parse(userwantDonate.lat);
    double lng = double.parse(userwantDonate.lng);

    LatLng latLng = LatLng(lat, lng);

    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Container(
      padding: EdgeInsets.all(10.0),
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: showMarker(),
      ),
    );
  }

  Padding bloodType() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.whatshot), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'หมู่เลือด:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${userwantDonate.bloodType}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Padding contactCall() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.phone), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'ติดต่อ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${userwantDonate.contact}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Padding nameShow() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'ชื่อ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${userwantDonate.nameUser}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Row addUsedata() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => addEditdata(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addEditdata() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (context) => FastDonate());
    Navigator.push(context, materialPageRoute);
  }

  Widget showtext() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ยังไม่มีข้อมูล",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      );

  Container commitButton() => Container(
      width: 250.0,
      child: ClipRRect(
        //ลดเหลี่ยมปุ่ม
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.redAccent[700],
          onPressed: () {
            updatetype();
          },
          child: Text(
            'ยืนยัน',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ));
}
