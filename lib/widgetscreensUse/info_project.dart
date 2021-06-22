import 'dart:convert';

import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:appblood/model/project_madel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectInfo extends StatefulWidget {
  final ProjectModel projectModel;

  ProjectInfo({Key key, this.projectModel}) : super(key: key);

  @override
  _ProjectInfoState createState() => _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  var res;

  int index;
  ProjectModel model;

  @override
  void initState() {
    super.initState();
    //readDatapDonate();
    model = widget.projectModel;
  }

  @override
  Widget build(BuildContext context) {
    //var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดโครงการ'),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            proName(),
            resName(),
            placeOpen(),
            startDate(),
            endDate(),
            showMap(),
          ],
        ),
      ),
    );
  }

  Padding endDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.date_range), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'ถึงวันที่:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${model.eDate}',
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

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('projectID'),
          position: LatLng(
            double.parse(model.lat),
            double.parse(model.lng),
          ),
          // target: LatLng(0.0, 0.0),
          infoWindow: InfoWindow(
              title: 'ตำแหน่งโครงการ',
              snippet: 'ละติจูด = ${model.lat},ลองติจูด = ${model.lng}'))
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(model.lat);
    double lng = double.parse(model.lng);

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

  Padding startDate() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.date_range), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'เริ่มวันที่:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${model.sDate}',
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

  Padding placeOpen() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.home), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'สถานที่รับบริจาค:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.place}',
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

  Padding resName() {
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
                text: 'ผู้รับผิดชอบโครงการ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.responsibleName}',
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

  Padding proName() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.video_label), onPressed: null),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 20, left: 10),
              child: Text.rich(
                TextSpan(
                  text: 'ชื่อโครงการ:',
                  style: TextStyle(fontSize: 18), // default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: '  ${model.projectName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
