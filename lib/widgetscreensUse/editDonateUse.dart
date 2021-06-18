import 'package:appblood/model/useDonate_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDonateUse extends StatefulWidget {
  final UseDonate useDonateModel;
  const EditDonateUse({Key key, this.useDonateModel}) : super(key: key);

  @override
  _EditDonateUseState createState() => _EditDonateUseState();
}

var selectedType;
List<String> _bloodType = <String>[
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-'
];

class _EditDonateUseState extends State<EditDonateUse> {
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
    findLatLng();
    timedate = DateTime.parse(useDonateModel.endTime);
    //timedate = DateTime.now();
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
    //LocationData locationData = await findLocation();
    setState(() {
      lat = double.parse(useDonateModel.lat);
      lng = double.parse(useDonateModel.lng);
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

  Future<Null> dataRequestUse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    String idr = useDonateModel.iDRequest;

    String url =
        '${Urlcon().domain}/GGB_BD/bloodrequestUse.php?isAdd=true&AnnounceName=$announceName&ReceiverName=$recipName&BloodType=$selectedType&HospitalName=$hospitalname&Detail=$detail&Contact=$phone&EndTime=$timedate&Lat=$lat&Lng=$lng&ID_Use=$id&ID_request=$idr';

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
      firstDate: timedate,
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

  Set<Marker> myMarker() {
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
        markers: myMarker(),
        //markers: Set.from(useMarker),
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
            child: TextFormField(
              onChanged: (value) => phone = value.trim(),
              initialValue: useDonateModel.contact,
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
            child: TextFormField(
              onChanged: (value) => detail = value.trim(),
              initialValue: useDonateModel.detail,
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
            child: TextFormField(
              onChanged: (value) => hospitalname = value.trim(),
              initialValue: useDonateModel.hospitalName,
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
            child: TextFormField(
              onChanged: (value) => recipName = value.trim(),
              initialValue: useDonateModel.receiverName,
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
            child: TextFormField(
              onChanged: (value) => announceName = value.trim(),
              initialValue: useDonateModel.announceName,
              decoration: InputDecoration(hintText: 'ชื่อประกาศ'),
            ),
          ))
        ],
      ),
    );
  }
}
