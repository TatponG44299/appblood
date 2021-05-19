import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Addproject extends StatefulWidget {
  @override
  _AddprojectState createState() => _AddprojectState();
}

class _AddprojectState extends State<Addproject> {
  String projecctName, responsible, place;

  @override
  void initState() {
    super.initState();
    //readDataUser();
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
            showmap(),
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
        onPressed: () {},
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Save Infomation",
          style: TextStyle(color: Colors.white),
        ));
  }

  Container showmap() {
    LatLng latLng = LatLng(19.027820, 99.900087);
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
