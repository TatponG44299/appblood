import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/screensUse/home.dart';
import 'package:appblood/screensUse/wayHome.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapShowProject extends StatefulWidget {
  //final ProjectModel projectModel;

  //MapShowProject({Key key, this.projectModel}) : super(key: key);

  @override
  _MapShowProjectState createState() => _MapShowProjectState();
}

class _MapShowProjectState extends State<MapShowProject> {
  var res, idProject, nameProject;
  double lat, lng, latuse, lnguse;
  ProjectModel projectModel;
  List<Marker> myMarker = [];
  Set<Marker> setMarker = Set();

  Marker resultMarker() {
    return Marker(
      markerId: MarkerId('ID_Project$idProject'),
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'ชื่อโครงการ:$nameProject',
          snippet: 'ละติจูด = $lat,ลองติจูด = $lng'),
    );
  }

  Marker currentMarker() {
    return Marker(
      markerId: MarkerId('myMarkPJ'),
      position: LatLng(latuse, lnguse),
      infoWindow: InfoWindow(
        title: 'ตำแหน่งของคุณ',
        snippet: 'ละติจูด = $lat ,ลองติจูด = $lng',
      ),
    );
  }

  // _handleTap(LatLng tappedPoint) {
  //   lat = tappedPoint.latitude;
  //   lng = tappedPoint.longitude;
  //   setState(() {
  //     myMarker = [];
  //     myMarker.add(
  //       Marker(
  //         markerId: MarkerId(tappedPoint.toString()),
  //         //position: tappedPoint,
  //         position: LatLng(tappedPoint.latitude, tappedPoint.longitude),
  //         infoWindow: InfoWindow(
  //           title: 'ที่จัดตั้งโครงการของคุณ',
  //           snippet: 'ละติจูด = $lat ,ลองติจูด = $lng',
  //         ),
  //       ),
  //     );
  //   });
  //   print("====================================$lat***$lng");
  // }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      latuse = locationData.latitude;
      lnguse = locationData.longitude;
    });
    setMarker.add(currentMarker());
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

  // Marker resultMarker = Marker(
  //   markerId: MarkerId('ID_Project$idProject'),
  //   position: LatLng(lat, lng),
  //   icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
  //   //   infoWindow: InfoWindow(
  //   //       title: 'จุดที่ควรเปิดรับโครงการที่ 3',
  //   //       snippet: 'ละติจูด = $lat3,ลองติจูด = $lng3'),
  // );
  @override
  void initState() {
    super.initState();
    //projectModel = widget.projectModel;
    findLatLng();
    readDatamapProject();
  }

  Future<Null> readDatamapProject() async {
    String url = '${Urlcon().domain}/GGB_BD/getdataProject.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print('***************' + projectModel.iDProject);
    //print(res[0]['ID_Project']);
    // int inex = 0;

    for (var map in res) {
      projectModel = ProjectModel.fromJson(map);
      setState(() {
        //projectModels.add(projectModel);
        lat = double.parse(projectModel.lat);
        lng = double.parse(projectModel.lng);
        nameProject = projectModel.projectName;
        idProject = projectModel.iDProject;
      });
      setMarker.add(resultMarker());
    }
  }

  static final thai = CameraPosition(
    target: LatLng(13.7204405, 100.4196398),
    zoom: 6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (value) => Home());
            Navigator.push(context, route);
          },
        ),
        title: Text('จุดตั้งโครงการ'),
      ),
      body: lat == null || latuse == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: thai,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: setMarker,
             // circles: ,
            ),
    );
  }
}
