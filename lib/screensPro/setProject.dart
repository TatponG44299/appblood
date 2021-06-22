import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:appblood/screensPro/scanQRcode.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditdataProject extends StatefulWidget {
  final ProjectModel projectModel;

  EditdataProject({Key key, this.projectModel}) : super(key: key);

  @override
  _EditdataProjectState createState() => _EditdataProjectState();
}

class _EditdataProjectState extends State<EditdataProject> {
  String projecctName, responsible, place, idProject;

  double lat, lng;

  DateTime startDate, endDate;

  List<Marker> myMarker = [];
  ProjectModel projectModel;

  Location location = Location();

  @override
  void initState() {
    super.initState();
    projectModel = widget.projectModel;
    findLatLng();
    startDate = DateTime.parse(projectModel.sDate);
    endDate = DateTime.parse(projectModel.eDate);
    // location.onLocationChanged.listen((event) {
    //   setState(() {
    //     lat = event.latitude;
    //     lng = event.longitude;
    //     print("lat ============ $lat , lng = $lng");
    //   });
    // });
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
    //LocationData locationData = await findLocation();
    setState(() {
      // lat = locationData.latitude;
      // lng = locationData.longitude;
      lat = double.parse(projectModel.lat);
      lng = double.parse(projectModel.lng);
    });

    print("lat ============ $lat , lng = $lng");
  }

  // Future<LocationData> findLocation() async {
  //   Location location = Location();
  //   try {
  //     return location.getLocation();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<Null> readDatainfo() async {
  //   //SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String id = projectModel.iDProject;

  //   String url =
  //       '${Urlcon().domain}/GGB_BD/editProjectuse.php?isAdd=true&ID_Project=$id';

  //   Response response = await Dio().get(url);

  //   var result = json.decode(response.data);
  //   for (var map in result) {
  //     setState(() {
  //       projectModel = ProjectModel.fromJson(map);
  //       projecctName = projectModel.projectName;
  //       responsible = projectModel.responsibleName;
  //       place = projectModel.place;
  //       //  lat = double.parse(projectModel.lat);
  //       //  lng = double.parse(projectModel.lng);
  //     });
  //   }
  // }

  Future<Null> dataProject() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String idp = projectModel.iDProject;
    print('===========================' + idp);

    String url =
        '${Urlcon().domain}/GGB_BD/editProjectuse.php?isAdd=true&Project_Name=$projecctName&Responsible_Name=$responsible&Place=$place&SDate=$startDate&EDate=$endDate&Lat=$lat&Lng=$lng&ID_Use=$id&ID_Project=$idp';

    await Dio().get(url).then((data) {
      //print("================== + $data");
      if (data.toString() == 'true') {
        Navigator.pop(context);
        normalDialog(context, 'ลงข้อมูลสำเร็จ');
      } else {
        normalDialog(context, 'ไม่สามารถบันทึกได้ กรุณาลองใหม่');
        //Navigator.pop(context);
      }
      idProject = projectModel.iDProject.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลโครงการ'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.center_focus_strong),
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                  builder: (value) => ScanQRcode(
                        idProject: '${projectModel.iDProject}'.toString(),
                      ));
              Navigator.push(context, route);
              //print('${projectModel.iDProject}');
            },
          )
        ],
      ),
      body: projectModel == null
          ? MyStyle().showProgress()
          : SingleChildScrollView(
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
      firstDate: endDate,
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
      firstDate: startDate,
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
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Save Infomation",
          style: TextStyle(color: Colors.white),
        ));
  }

  RaisedButton deleteButton() {
    return RaisedButton.icon(
        color: Colors.red,
        onPressed: () {
          dataProject();
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Delete Project",
          style: TextStyle(color: Colors.white),
        ));
  }

  Set<Marker> currentMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('myMarkPJ'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'ที่จัดตั้งโครงการของคุณ',
            snippet: 'ละติจูด = $lat ,ลองติจูด = $lng',
          ))
    ].toSet();
  }

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
        markers: currentMarker(),
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
            child: TextFormField(
              onChanged: (value) => place = value.trim(),
              initialValue: projectModel.place,
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
            child: TextFormField(
              onChanged: (value) => responsible = value.trim(),
              initialValue: projectModel.responsibleName,
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
            child: TextFormField(
              onChanged: (value) => projecctName = value.trim(),
              initialValue: projectModel.projectName,
              decoration: InputDecoration(hintText: 'ชื่อโครงการ'),
            ),
          ))
        ],
      ),
    );
  }
}
