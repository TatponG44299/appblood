import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requestblood extends StatefulWidget {
  @override
  _RequestbloodState createState() => _RequestbloodState();
}

class _RequestbloodState extends State<Requestblood> {
  String announceName,
      recipName,
      bloodType,
      hospitalname,
      place,
      detail,
      endTime;

  List<Marker> useMarker = [];
  double lat, lng;

  @override
  void initState() {
    super.initState();
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

  // Future<Null> dataProject() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String id = preferences.getString('id');

  //   String url =
  //       '${Urlcon().domain}/GGB_BD/editProjectuse.php?isAdd=true&Project_Name=$projecctName&Responsible_Name=$responsible&Place=$place&Lat=$lat&Lng=$lng&ID_Use=$id';

  //   await Dio().get(url).then((data) {
  //     //print("================== + $data");
  //     if (data.toString() == 'true') {
  //       Navigator.pop(context);
  //       normalDialog(context, 'ลงข้อมูลสำเร็จ');
  //     } else {
  //       normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
  //       //Navigator.pop(context);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เตรียมตัวบริจาค'),
      ),
    );
  }
}
