import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addproject extends StatefulWidget {
  @override
  _AddprojectState createState() => _AddprojectState();
}

class _AddprojectState extends State<Addproject> {
  String projecctName, responsible, place;

  //field
  double lat, lng;

  List<Marker> useMarker = [];

  List<Marker> myMarker = [];

  @override
  void initState() {
    super.initState();
    findLatLng();
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
        '${Urlcon().domain}/GGB_BD/editProjectuse.php?isAdd=true&Project_Name=$projecctName&Responsible_Name=$responsible&Place=$place&Lat=$lat&Lng=$lng&ID_Use=$id';

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
      appBar: AppBar(title: Text('เพิ่ม/แก้ไขข้อมูลโครงการ')),
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
          dataProject();
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
}
