import 'dart:convert';

import 'package:appblood/model/accout_model.dart';
import 'package:appblood/model/useDonate_model.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'urgentdonation.dart';

class FastDonate extends StatefulWidget {
  //final AccountModel accountModel;

  //FastDonate({Key key, this.accountModel}) : super(key: key);

  @override
  _FastDonateState createState() => _FastDonateState();
}

var selectedType;
List<String> _bloodType = <String>[
  'A',
  'B',
  'AB',
  'O',
];

class _FastDonateState extends State<FastDonate> {
  var res, name, contact;
  //String name ;

  double lat, lng;
  List<Marker> myMarker = [];
  AccountModel accountModel;
  //List<UseDonate> useDonates = List();

  @override
  void initState() {
    super.initState();
    findLatLng();
    //memUse();

    //accountModel = widget.accountModel;
    //readDataDonate();
  }

  Future<Null> addUserDonate() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');

    String url =
        '${Urlcon().domain}/GGB_BD/userWantDonate.php?isAdd=true&Name_User=$name&Contact=$contact&BloodType=$selectedType&Lat=$lat&Lng=$lng&ID_Use=$id';

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

    // String url =
    //     '${Urlcon().domain}/GGB_BD/getUserWhereID.php?isAdd=true&ID=$id';
    // await Dio().get(url).then((value) {
    //   // print('Value = $value');
    //   var result = json.decode(value.data);
    //   //print('result==$result');
    //   for (var map in result) {
    //     //print('fname == ${accountModel.firstName}');
    //     setState(() {
    //       accountModel = AccountModel.fromJson(map);
    //       name = ('${accountModel.firstName}' + ' ${accountModel.lastName}');
    //     });
    //   }
    //   print(
    //       '***************************************************************$name');
    // });
  }

  // Future<Null> memUse() async {
  //   //email =  accountModel.email;
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   fname = preferences.getString('firstName');
  //   lname = preferences.getString('lastName');
  //   setState(() {
  //     name = '$fname' + ' $lname';
  //   });
  //   print(
  //       '***************************************************************$name');
  //   //selectedType = preferences.getString('selectedType');
  //   //name = accountModel.lastName;
  //   //String id = preferences.getString('id');
  // }

  // Future<Null> readDataDonate() async {
  //   // SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // String code = preferences.getString('code');

  //   //เปลี่ยนเป็นตารางของ โครงการบริจาคด้วย
  //   String url = '${Urlcon().domain}/GGB_BD/getdataUseDonate.php?isAdd=true';

  //   Response response = await Dio().get(url);
  //   res = json.decode(response.data);
  //   print(res[0]['ID_request']);
  //   // int inex = 0;

  //   for (var map in res) {
  //     UseDonate useDonate = UseDonate.fromJson(map);
  //     setState(() {
  //       useDonates.add(useDonate);
  //     });
  //     //projectModels.add(model);
  //   }
  // }
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

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      // lat = double.parse(projectModel.lat);
      // lng = double.parse(projectModel.lng);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่ม/แก้ไขข้อมุลบริจาคโลหิต'),
      ),
      //body: res == null ? MyStyle().showProgress() : listCardshow(),
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            donateName(),
            contactUse(),
            bloodTypeDrop(),
            lat == null ? MyStyle().showProgress() : showmap(),
            saveButton(),
            // Stack(
            //   children:
            //     RaisedButton(onPressed: null),
            //     RaisedButton(onPressed: null)
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  RaisedButton saveButton() {
    return RaisedButton.icon(
        color: Colors.red,
        onPressed: () {
          addUserDonate();
        },
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          "Save Infomation",
          style: TextStyle(color: Colors.white),
        ));
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

  Padding bloodTypeDrop() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.invert_colors), onPressed: null),
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

  // Padding bloodType() {
  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Row(
  //       children: <Widget>[
  //         IconButton(icon: Icon(Icons.video_label), onPressed: null),
  //         Expanded(
  //             child: Container(
  //           margin: EdgeInsets.only(right: 20, left: 10),
  //           child: TextFormField(
  //             //onChanged: (value) => projecctName = value.trim(),
  //             //initialValue: projectModel.projectName,
  //             decoration: InputDecoration(hintText: 'หมู่เลือด'),
  //           ),
  //         ))
  //       ],
  //     ),
  //   );
  // }

  Padding contactUse() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.phone_android), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextFormField(
              onChanged: (value) => contact = value.trim(),
              //initialValue: projectModel.projectName,
              decoration: InputDecoration(hintText: 'ติดต่อ'),
            ),
          ))
        ],
      ),
    );
  }

  Padding donateName() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.person), onPressed: null),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(right: 20, left: 10),
            child: TextFormField(
              onChanged: (value) => name = value.trim(),
              // initialValue:
              //     ('${accountModel.firstName}' + ' ${accountModel.lastName}'),
              decoration: InputDecoration(hintText: 'ชื่อ'),
            ),
          ))
        ],
      ),
    );
  }

  // ListView listCardshow() {
  //   return ListView.builder(
  //       itemCount: res.length,
  //       itemBuilder: (context, int index) {
  //         return Card(
  //           elevation: 5,
  //           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
  //           child: ListTile(
  //             title: Text("ชื่อผู้ขอรับบริจาค: " + res[index]['AnnounceName']),
  //             subtitle: Text("หมู่โลหิตที่ต้องการ: " + res[index]['BloodType']),
  //             trailing: Icon(Icons.arrow_forward_ios),
  //             onTap: () {
  //               //print('print============$index');

  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) =>
  //                       ReadUrgent(useDonate: useDonates[index]),
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       });
  // }
}
