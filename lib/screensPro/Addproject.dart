import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addproject extends StatefulWidget {
  @override
  _AddprojectState createState() => _AddprojectState();
}

class _AddprojectState extends State<Addproject> {
  String projecctName, responsible, place;

  ProjectModel projectModel;

  AccountModel model;

  //field
  double lat, lng;

  DateTime startDate, endDate;

  //List<Marker> useMarker = [];

  List<Marker> myMarker = [];

  @override
  void initState() {
    super.initState();
    findLatLng();
    //notification();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  _handleTap(LatLng tappedPoint) {
    lat = tappedPoint.latitude;
    lng = tappedPoint.longitude;
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint.toString()),
          //position: tappedPoint,
          position: LatLng(tappedPoint.latitude, tappedPoint.longitude),
          infoWindow: InfoWindow(
            title: 'ที่จัดตั้งโครงการของคุณ',
            snippet: 'ละติจูด = $lat ,ลองติจูด = $lng',
          ),
        ),
      );
    });
    print("====================================$lat***$lng");
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });

    print("lat ============ $lat , lng = $lng");
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> dataProject() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${Urlcon().domain}/GGB_BD/editProjectuse.php?isAdd=true&Project_Name=$projecctName&Responsible_Name=$responsible&Place=$place&SDate=$startDate&EDate=$endDate&Lat=$lat&Lng=$lng&ID_Use=$id';

    await Dio().get(url).then((data) {
      //print("================== + $data");
      if (data.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'ลงข้อมูลสำเร็จ');
        notificationProject(
            projectModel.iDProject); //_______________________>>>>
      } else {
        normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
        //Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่มข้อมูลโครงการ')),
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            proName(),
            SizedBox(
              height: 5,
            ),
            resName(),
            SizedBox(
              height: 5,
            ),
            placeOpen(),
            SizedBox(
              height: 5,
            ),
            starttime(),
            SizedBox(
              height: 5,
            ),
            endtime(),
            SizedBox(
              height: 5,
            ),
            lat == null ? MyStyle().showProgress() : showmap(),
            SizedBox(
              height: 5,
            ),
            saveButton()
          ],
        ),
      ),
    );
  }

  Padding endtime() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 5, right: 20.0, bottom: 20.0, top: 20.0),
      child: ListTile(
        leading: IconButton(icon: Icon(Icons.announcement), onPressed: null),
        title: Text(
          'ถึงวันที่: ' + new DateFormat.yMMMd().format(endDate),
          //style: TextStyle(fontSize: 18.0),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: enddate,
      ),
    );
  }

  enddate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (date != null && date != endDate)
      setState(() {
        endDate = date;
      });
  }

  Padding starttime() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 5, right: 20.0, bottom: 20.0, top: 20.0),
      child: ListTile(
        leading: IconButton(icon: Icon(Icons.announcement), onPressed: null),
        title: Text(
          'เริ่มวันที่: ' + new DateFormat.yMMMd().format(startDate),
          //style: TextStyle(fontSize: 18.0),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: startdate,
      ),
    );
  }

  startdate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (date != null && date != startDate)
      setState(() {
        startDate = date;
      });
  }

  RaisedButton saveButton() {
    return RaisedButton.icon(
        color: Colors.red,
        onPressed: () {
          dataProject();
          //_showNotification();
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Save Infomation",
          style: TextStyle(color: Colors.white),
        ));
  }

  // Set<Marker> myMarker() {
  //   return <Marker>[
  //     Marker(
  //       markerId: MarkerId('myMarkPJ'),
  //       position: LatLng(lat, lng),
  //       infoWindow: InfoWindow(
  //         title: 'ที่จัดตั้งโครงการของคุณ',
  //         snippet: 'ละติจูด = $lat ,ลองติจูด = $lng',
  //       )
  //     )
  //   ].toSet();
  // }

  Container showmap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16,
    );

    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        // markers: myMarker(),
        markers: Set.from(myMarker),
        onTap: _handleTap,
      ),
    );
  }

  Padding placeOpen() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.home), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => place = value.trim(),
              decoration: InputDecoration(hintText: 'สถานที่เปิดรับบริจาค'),
            ),
          ))
        ],
      ),
    );
  }

  Padding resName() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => responsible = value.trim(),
              decoration: InputDecoration(hintText: 'ผู้รับผิดชอบ'),
            ),
          ))
        ],
      ),
    );
  }

  Padding proName() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.video_label), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => projecctName = value.trim(),
              decoration: InputDecoration(hintText: 'ชื่อโครงการ'),
            ),
          ))
        ],
      ),
    );
  }

  Future<Null> notificationProject(String iDProject) async {
    String urlFindToken =
        '${Urlcon().domain}/GGB_BD/getUserWhereID.php?isAdd=true&ID=$iDProject';
    //นำ token มาเก็บไว้ใน iDProject
    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      print('result =======> $result');
      for (var json in result) {
        String tokenProject = model.token;
        print('tokenProject ========= $tokenProject');
        //text ใน notification
        String title = 'มีโครงกาจัดตั้งขึ้น';
        String body = 'กดเพื่อเข้าไปดูรายละเอียด';
        String urlSendtoken =
            '${Urlcon().domain}/GGB_BD/apiNotification.php?isAdd=true&token=$tokenProject&title=$title&body=$body';
        sendNotificationProject(urlSendtoken);
      }
    });
  }

  Future<Null> sendNotificationProject(String urlSendtoken) async {
    await Dio().get(urlSendtoken);
    //.then((value) => normalDialog(context, ''));
  }
}
