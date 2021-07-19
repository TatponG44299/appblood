import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestInfo extends StatefulWidget {
  //const RequestInfo({ Key? key }) : super(key: key);

  @override
  _RequestInfoState createState() => _RequestInfoState();
}

var selectedType;
List<String> _bloodType = <String>[
  'A',
  'B',
  'AB',
  'O',
];

class _RequestInfoState extends State<RequestInfo> {
  String announceName, recipName, phone, hospitalname, detail;

  List<Marker> useMarker = [];
  double lat, lng;
  String tokenUser;
  bool values;
  DateTime timedate;
  AccountModel model;
  List tokenUsers = [];

  @override
  void initState() {
    super.initState();
    findLatLng();
    timedate = DateTime.now();
  }

  _handleTap(LatLng tappedPoint) {
    lat = tappedPoint.latitude;
    lng = tappedPoint.longitude;
    setState(() {
      useMarker = [];
      useMarker.add(
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

  Future<Null> dataRequestUse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${Urlcon().domain}/GGB_BD/bloodrequestUse.php?isAdd=true&AnnounceName=$announceName&ReceiverName=$recipName&BloodType=$selectedType&HospitalName=$hospitalname&Detail=$detail&Contact=$phone&EndTime=$timedate&Lat=$lat&Lng=$lng&ID_Use=$id';

    await Dio().get(url).then((data) {
      //print("================== + $data");
      if (data.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'ลงข้อมูลสำเร็จ');
      } else {
        normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
        //Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ขอรับบริจาคโลหิต')),
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            annoName(),
            recipientName(),
            hostalname(),
            detaildata(),
            calluser(),
            bloodTypeDrop(),
            starttime(),
            //switButton1(),
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

  RaisedButton saveButton() {
    return RaisedButton.icon(
        color: Colors.red,
        onPressed: () {
          dataRequestUse();
          notificationProject();
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Save Infomation",
          style: TextStyle(color: Colors.white),
        ));
  }

  Padding starttime() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 5, right: 20.0, bottom: 20.0, top: 20.0),
      child: ListTile(
        leading: IconButton(icon: Icon(Icons.announcement), onPressed: null),
        title: Text(
          'วันที่ลงประกาศ: ' + new DateFormat.yMMMd().format(timedate),
          //style: TextStyle(fontSize: 18.0),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: dateti,
      ),
    );
  }

  dateti() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: timedate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (date != null && date != timedate)
      setState(() {
        timedate = date;
      });
  }

  Padding bloodTypeDrop() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.whatshot), onPressed: null),
          DropdownButton(
            items: _bloodType.map((value) {
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
                selectedType = selectBloodType;
              });
            },
            value: selectedType,
            hint: Text(
              'กรุณาเลือกหมู่เลือด',
              //style: TextStyle(fontSize: 20)
            ),
          ),
        ],
      ),
    );
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
        markers: Set.from(useMarker),
        onTap: _handleTap,
      ),
    );
  }

  Padding calluser() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.phone), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => phone = value.trim(),
              decoration: InputDecoration(hintText: 'ติดต่อ'),
            ),
          ))
        ],
      ),
    );
  }

  Padding detaildata() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.details), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => detail = value.trim(),
              decoration: InputDecoration(hintText: 'รายละเอียดเบืองต้น'),
            ),
          ))
        ],
      ),
    );
  }

  Padding hostalname() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.hotel), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => hospitalname = value.trim(),
              decoration: InputDecoration(hintText: 'โรงพยาบาล / สถานที่'),
            ),
          ))
        ],
      ),
    );
  }

  Padding recipientName() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => recipName = value.trim(),
              decoration: InputDecoration(hintText: 'ผู้ที่ได้รับเลือด'),
            ),
          ))
        ],
      ),
    );
  }

  Padding annoName() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.video_label), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextField(
              onChanged: (value) => announceName = value.trim(),
              decoration: InputDecoration(hintText: 'ชื่อประกาศ'),
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
  //         Text('ประกาศขอรับบริจาค: ', style: TextStyle(fontSize: 18)),
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
        '${Urlcon().domain}/GGB_BD/notifybyStatusQD.php?isAdd=true&Quick_Donate=1';
    //'${Urlcon().domain}/GGB_BD/getUserWhereID.php?isAdd=true&ID=$iD';
    print('==================================> $iD');
    //ใช้ iD เพื่อให้คายตัว model ออกมาเพื่อหา token และใช้ค่านี้ยิงต่อไปที่ apiNotification เพื่อแจ้งเตือน
    await Dio().get(urlFindToken).then((value) {
      print('======================> $urlFindToken');
      var result = json.decode(value.data);
      print('result ======================> $result');
      for (var json in result) {
        AccountModel model = AccountModel.fromJson(json);
        tokenUser = model.token;
        tokenUsers.add(tokenUser);

        print('tokenUser ========= $tokenUser');

        sendNotificationProject();
      }
    });
  }

  Future<Null> sendNotificationProject() async {
    //text ใน notification
    String text =
        'มีผู้ป่วย $announceName ต้องการหมู่เลือด $selectedType ที่ $hospitalname';
    String urlSendtoken =
        '${Urlcon().domain}/GGB_BD/Line_notify.php?token=$tokenUser&text=$text';
    await Dio().get(urlSendtoken);
    print(
        'urlSendtoken = =========================================>>>>>$urlSendtoken');
    //sendNotificationProject(urlSendtoken);
    //then((value) => normalDialog(context, 'ประกาศขอรับบริจาคสำเร็จ'));
  }
}
