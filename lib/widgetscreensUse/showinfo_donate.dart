import 'package:appblood/model/useDonate_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Detaildonate extends StatefulWidget {
  final UseDonate useDonateModel;
  const Detaildonate({Key key, this.useDonateModel}) : super(key: key);

  @override
  _DetaildonateState createState() => _DetaildonateState();
}

class _DetaildonateState extends State<Detaildonate> {
  String announceName, recipName, phone, hospitalname, detail;

  List<Marker> useMarker = [];
  double lat, lng;

  DateTime timedate;

  var res;

  int index;
  UseDonate useDonateModel;

  @override
  void initState() {
    super.initState();
    useDonateModel = widget.useDonateModel;
    //findLatLng();
    //timedate = DateTime.parse(useDonateModel.endTime);
    //timedate = DateTime.now();
  }

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('projectID'),
          position: LatLng(
            double.parse(useDonateModel.lat),
            double.parse(useDonateModel.lng),
          ),
          infoWindow: InfoWindow(
              title: 'ตำแหน่งโครงการ',
              snippet:
                  'ละติจูด = ${useDonateModel.lat},ลองติจูด = ${useDonateModel.lng}'))
    ].toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ต้องการบริจาคโลหิต'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            useDonateModel == null ? MyStyle().showProgress() : showDatainfo(),
            //addUsedata(),
          ],
        ),
      ),
    );
  }

  Widget showDatainfo() => Column(
        children: <Widget>[
          nameShow(),
          nameShowre(),
          detaildata(),
          contactCall(),
          bloodType(),
          //switButton1(),
          //switButton2(),
          showMap(),

          //testswitch()
          //commitButton(),
          // phontextshow()
        ],
      );

  Padding nameShow() {
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
                text: 'ผู้ประกาศ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${useDonateModel.announceName}',
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

  Padding nameShowre() {
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
                text: 'ผู้รับโลหิต:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${useDonateModel.receiverName}',
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

  Padding detaildata() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.details), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'รายละเอียดเบืองต้น:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${useDonateModel.detail}',
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

  Padding contactCall() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.phone), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: Text.rich(
              TextSpan(
                text: 'ติดต่อ:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${useDonateModel.contact}',
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

  Padding bloodType() {
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
                text: 'หมู่เลือด:',
                style: TextStyle(fontSize: 18), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: '  ${useDonateModel.bloodType}',
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

  Widget showMap() {
    double lat = double.parse(useDonateModel.lat);
    double lng = double.parse(useDonateModel.lng);

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
}
