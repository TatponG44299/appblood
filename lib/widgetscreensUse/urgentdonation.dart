import 'dart:convert';

import 'package:appblood/model/useDonate_modail.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReadUrgent extends StatefulWidget {
  final UseDonate useDonate;

  ReadUrgent({Key key, this.useDonate}) : super(key: key);

  @override
  _ReadUrgentState createState() => _ReadUrgentState();
}

class _ReadUrgentState extends State<ReadUrgent> {
  var res;

  int index;
  UseDonate model;

  @override
  void initState() {
    super.initState();
    //readDatapDonate();
    model = widget.useDonate;
  }

  @override
  Widget build(BuildContext context) {
    //var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดผู้ขอโลหิต'),
      ),
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            annoName(),
            recName(),
            placeOpen(),
            detailDonate(),
            groupBlood(),
            contactDonate(),
            askDate(),
            showMap(),
          ],
        ),
      ),
    );
  }

  Padding askDate() {
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
                text: 'วันที่:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: ' ${model.endTime}',
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
          infoWindow: InfoWindow(
              title: 'ผู้ขอรับบริจาค',
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

  Padding contactDonate() {
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
                text: 'ติดต่อ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.contact}',
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

  // Padding timeDonate() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
  //     child: Row(
  //       children: <Widget>[
  //         IconButton(icon: Icon(Icons.home), onPressed: null),
  //         Expanded(
  //             child: Container(
  //           margin: EdgeInsets.only(right: 20, left: 10),
  //           child: Text.rich(
  //             TextSpan(
  //               text: 'วันที่:',
  //               style: TextStyle(fontSize: 18), // default text style
  //               children: <TextSpan>[
  //                 TextSpan(
  //                     text: '  ${model.endTime}',
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
  //               ],
  //             ),
  //           ),
  //         ))
  //       ],
  //     ),
  //   );
  // }


  Padding detailDonate() {
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
                text: 'รายละเอียด:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.detail}',
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
                text: 'สถานที่รับโลหิต:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.hospitalName}',
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

  Padding groupBlood() {
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
                text: 'หมู่เลือดที่ต้องการ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.bloodType}',
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

  Padding recName() {
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
                text: 'ผู้ที่ได้รับโลหิต:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${model.receiverName}',
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

  Padding annoName() {
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
                  text: 'ชื่อรับบริจาค:',
                  style: TextStyle(fontSize: 18), // default text style
                  children: <TextSpan>[
                    TextSpan(
                        text: '  ${model.announceName}',
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
