import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapShowProject extends StatefulWidget {
  //const MapShowProject({ Key? key }) : super(key: key);

  @override
  _MapShowProjectState createState() => _MapShowProjectState();
}

class _MapShowProjectState extends State<MapShowProject> {
  var res;
  double lat, lng;

  List projectModels = [];
  ProjectModel projectModel;

  Set<Marker> setMarker = Set();

  // Future<Null>
  // Set<Marker> setMarker() {
  //   return <Marker>[].toSet();
  // }

  // Marker resultMarker() {
  //   return Marker(
  //     markerId: MarkerId('clusMarker3'),
  //     position: LatLng(
  //         double.parse(projectModel.lat), double.parse(projectModel.lng)),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
  //     //   infoWindow: InfoWindow(
  //     //       title: 'จุดที่ควรเปิดรับโครงการที่ 3',
  //     //       snippet: 'ละติจูด = $lat3,ลองติจูด = $lng3'),
  //   );
  // }

  Marker resultMarker = Marker(
    //position: LatLng(, longitude),
    markerId: MarkerId(''),
    infoWindow: InfoWindow(title: "", snippet: ""),
    //position: LatLng( double.parse(projectModel.lat), double.parse(projectModel.lng)),
    //markers.add(resultMarker);
  );

  @override
  void initState() {
    super.initState();
    readDatamapProject();
    setMarker.add(resultMarker);
  }

  Future<Null> readDatamapProject() async {
    String url = '${Urlcon().domain}/GGB_BD/getdataProject.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print(res[0]['ID_Project']);
    // int inex = 0;

    for (var map in res) {
      projectModel = ProjectModel.fromJson(map);
      setState(() {
        projectModels.add(projectModel);
        lat = double.parse(projectModel.lat);
        lng = double.parse(projectModel.lng);
      });
      print('$lat+$lng');
      print('=======================${projectModels.length}');
      // lat = projectModel.lat;
    }
  }

  static final thai = CameraPosition(
    target: LatLng(13.7204405, 100.4196398),
    zoom: 6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('จุดที่ควรจัดตั้งโครงการ')),
      body: lat == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: thai,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: setMarker,
            ),
    );
  }
}
