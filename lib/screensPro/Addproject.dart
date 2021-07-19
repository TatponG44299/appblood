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

var selectedClutter;
List<String> _pointClutter = <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
];

class _AddprojectState extends State<Addproject> {
  String projecctName, responsible, place;
  var res, lat1, lat2, lat3, lng1, lng2, lng3, latc, lngc, i;

  ProjectModel projectModel;

  AccountModel model;

  //field
  double lat, lng;
  bool values;
  DateTime startDate, endDate;
  String tokenProject;
  //List<Marker> useMarker = [];
  //Set<Marker> setMarker = Set();
  List<Marker> myMarker = [];
  List latall = [];
  List lngall = [];

  //var _clusLatLng = LatLng(lat1, lng2),

  @override
  void initState() {
    super.initState();
    findLatLng();
    readLocation();
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

    //print("lat ============ $lat , lng = $lng");
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> readLocation() async {
    String url =
        '${Urlcon().domain}/GGB_BD/democlustering.php?isAdd=true&Cuspoint=$selectedClutter';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    Map decoded = json.decode(response.data);

    var name = decoded['data'];
    setState(() {
      ///////////Clust1//////////////////
      lat1 = name[0]['Lat'].toDouble();
      lng1 = name[0]['Lng'].toDouble();
      ////////////Clust2/////////////////
      lat2 = name[1]['Lat'].toDouble();
      lng2 = name[1]['Lng'].toDouble();
      ///////////Clust3//////////////////
      lat3 = name[2]['Lat'].toDouble();
      lng3 = name[2]['Lng'].toDouble();
      ///////////////////////////////////
    });
    print('1****************$lat1 + $lng1');
    print('2****************$lat2 + $lng2');
    print('3****************$lat3 + $lng3');

    // for (i = 0; i < int.parse(selectedClutter); i++) {
    //   setState(() {
    //     latc = name[i]['Lat'].toDouble();
    //     lngc = name[i]['Lng'].toDouble();
    //     print('lat*******$latc +  lng*******$lngc');
    //     //setMarker.add(resultMarker(latc, lngc));
    //   });
    //   setMarker.add(resultMarker());
    // }

    //setMarker.add(resultMarker());
    //print('****************$name');
  }

  // Marker resultMarker() {
  //   return Marker(
  //     markerId: MarkerId('ID_Project$id'),
  //     position: //_clusLatLng,
  //         LatLng(latc, lngc),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
  //     infoWindow: InfoWindow(
  //         title: 'จุดที่ควรจัดจุดที่:$selectedClutter',
  //         snippet: 'ละติจูด = $latc,ลองติจูด = $lngc'),
  //   );
  // }

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
        //_______________________>>>>
      } else {
        normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
        //Navigator.pop(context);
      }
    });
  }

  Set<Marker> setMarker() {
    return <Marker>[
      clus1Marker(),
      clus2Marker(),
      clus3Marker(),
    ].toSet();
  }

  Marker clus1Marker() {
    return Marker(
      markerId: MarkerId('clusMarker1'),
      position: LatLng(lat1, lng2),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'จุดที่ควรเปิดรับโครงการที่ 1',
          snippet: 'ละติจูด = $lat1,ลองติจูด = $lng1'),
    );
  }

  Marker clus2Marker() {
    return Marker(
      markerId: MarkerId('clusMarker2'),
      position: LatLng(lat2, lng2),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'จุดที่ควรเปิดรับโครงการที่ 2',
          snippet: 'ละติจูด = $lat2,ลองติจูด = $lng2'),
    );
  }

  Marker clus3Marker() {
    return Marker(
      markerId: MarkerId('clusMarker3'),
      position: LatLng(lat3, lng3),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'จุดที่ควรเปิดรับโครงการที่ 3',
          snippet: 'ละติจูด = $lat3,ลองติจูด = $lng3'),
    );
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
            //switButton1(),
            SizedBox(
              height: 5,
            ),
            //clustereDrop(),
            SizedBox(
              height: 5,
            ),
            lat == null || lng1 == null ? MyStyle().showProgress() : showmap(),
            //selectedClutter == null ? MyStyle().showProgress() : showmap(),
            SizedBox(
              height: 5,
            ),
            saveButton()
          ],
        ),
      ),
    );
  }

  Padding clustereDrop() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.map_sharp), onPressed: null),
          Text('จุดต้องการบริจาค:  '),
          DropdownButton(
            items: _pointClutter.map((value) {
              var dropdownMenuItem = DropdownMenuItem(
                child: Text(
                  value,
                ),
                value: value,
              );
              return dropdownMenuItem;
            }).toList(),
            onChanged: (selectBloodType) {
              setState(() {
                selectedClutter = selectBloodType;
                readLocation();
              });
              //readLocation();
            },
            value: selectedClutter,
            hint: Text(
              '-',
              //style: TextStyle(fontSize: 20)
            ),
          ),
        ],
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
          notificationProject();
          //sendNotificationProject();
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
        markers: setMarker(),
        //markers: Set.from(myMarker),
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

  // Padding switButton1() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
  //     child: Row(
  //       children: <Widget>[
  //         Text('ประกาศโครงการ: ', style: TextStyle(fontSize: 18)),
  //         Transform.scale(
  //           scale: 1.5,
  //           child: Switch.adaptive(
  //             activeColor: Colors.blueAccent,
  //             //activeTrackColor: Colors.,
  //             value: values,
  //             onChanged: (swi) {
  //               setState(() {
  //                 swi == true ? this.values = true : this.values = false;
  //                 //this.value = swi;
  //                 //updateStatus();
  //               });

  //               notificationProject();
  //               print('6666666666666666666666666666666666666666666$values');
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<Null> notificationProject() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String iD = preferences.getString('id');
    String urlFindToken =
        '${Urlcon().domain}/GGB_BD/notifybyStatusQD.php?isAdd=true';
    //'${Urlcon().domain}/GGB_BD/getUserWhereID.php?isAdd=true&ID=$iD';
    print('==================================> $iD');
    //ใช้ iD เพื่อให้คายตัว model ออกมาเพื่อหา token และใช้ค่านี้ยิงต่อไปที่ apiNotification เพื่อแจ้งเตือน
    await Dio().get(urlFindToken).then((value) {
      print('======================> $urlFindToken');
      var result = json.decode(value.data);
      print('result ======================> $result');
      for (var json in result) {
        AccountModel model = AccountModel.fromJson(json);
        tokenProject = model.token;

        print('tokenProject =======================> $tokenProject/////////');
      }
      sendNotificationProject();
    });
  }

  Future<Null> sendNotificationProject() async {
    String text = 'มีโครงการ $projecctName จัดตั้งขึ้น ณ $place';
    //'มีโครงการจัคตั้งขึ้น';
    String urlSendtoken =
        '${Urlcon().domain}/GGB_BD/Line_notify.php?token=$tokenProject&text=$text';
    await Dio().get(urlSendtoken);
    print(
        'urlSendtoken = =========================================>>>>>$urlSendtoken');
    //sendNotificationProject(urlSendtoken);
    //then((value) => normalDialog(context, 'ประกาศโครงการสำเร็จ'));
  }
}
