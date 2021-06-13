import 'package:appblood/model/accout_model.dart';
import 'package:appblood/screensPro/listProject.dart';
import 'package:appblood/screensUse/login.dart';
import 'package:appblood/screensUse/notifications.dart';
import 'package:appblood/screensUse/personalInfo.dart';
import 'package:appblood/widgetscreensUse/request_info.dart';
import 'package:appblood/screensUse/list_requestblood.dart';
import 'package:appblood/screensUse/project_donate.dart';
import 'package:appblood/screensPro/addproject.dart';
import 'package:appblood/screensUse/query.dart';
import 'package:appblood/screensUse/statistics.dart';
import 'package:appblood/screensUse/wayHome.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String fname, lname, email, resultQR = '';
  AccountModel accountModel;

  //กำหนดหน้าแรกของแอพ01
  Widget currentWidget = SelectWay();

  @override
  void initState() {
    super.initState();
    memUse();
  }

  //จำ User ไม่ต้องไป login  ซ้ำ
  Future<Null> memUse() async {
    //email =  accountModel.email;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fname = preferences.getString('firstName');
    lname = preferences.getString('lastName');
    //String id = preferences.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get & Give Blood'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.fingerprint),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.center_focus_weak),
            onPressed: () {
              print('object');
              scanQR();
            },
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
      // SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
      //       showMap(),
      //     ],
      //   ),
      // ),
    );
  }

  Future<Null> scanQR() async {
    try {
      var qrResult = await BarcodeScanner.scan();
      resultQR = qrResult.rawContent;
      print('resultQR====>$resultQR');
    } catch (e) {}
  }

  Container showMap() {
    LatLng latLng = LatLng(19.0281895, 99.8918563);
    CameraPosition lomap = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );

    return Container(
      height: 550,
      child: GoogleMap(
        initialCameraPosition: lomap,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }

//แทบ Menu ข้างซ้าย
  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showDrawerHeader(),
            //thaimap(),
            usedataMenu(),
            statisticsMenu(),
            notificMenu(),
            queryMenu(),
            Divider(
              color: Colors.grey[700],
            ),
            prodonatMenu(),
            requestbloodMenu(),
            Divider(
              color: Colors.grey[700],
            ),
            logoutMenu()
          ],
        ),
      );

  // ListTile thaimap() {
  //   return ListTile(
  //     leading: Icon(Icons.home),
  //     title: Text('หน้าหลัก'),
  //     onTap: () {
  //       setState(() {
  //         currentWidget = SelectWay();
  //       });
  //       //กดเปลี่ยนหน้า
  //       Navigator.pop(context);
  //       // MaterialPageRoute route =
  //       //     MaterialPageRoute(builder: (value) => Query());
  //       // Navigator.push(context, route);
  //     },
  //   );
  // }

//แทบแบบสอบถาม
  ListTile queryMenu() {
    return ListTile(
      leading: Icon(Icons.book),
      title: Text('ต้องการบริจาคโลหิตด่วน'),
      onTap: () {
        //กดเปลี่ยนหน้า
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => FastDonate());
        Navigator.push(context, route);
      },
    );
  }

//แทบเมนูโครงการที่รับบริจาค
  ListTile prodonatMenu() {
    return ListTile(
      leading: Icon(Icons.location_city),
      title: Text('โครงการรับบริจาค'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => ProjectDonate());
        Navigator.push(context, route);
      },
    );
  }

//แทบเมนูการแจ้งเตือน
  ListTile notificMenu() {
    return ListTile(
      leading: Icon(Icons.notifications),
      title: Text('การแจ้งเตือน'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => ListProject());
        Navigator.push(context, route);
      },
    );
  }

//แทบเมนูสถิติ
  ListTile statisticsMenu() {
    return ListTile(
      leading: Icon(Icons.insert_chart),
      title: Text('สถิติ'),
      onTap: () {
        // setState(() {
        //   currentWidget = Statistics();
        // });
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Statistics());
        Navigator.push(context, route);
      },
    );
  }

//แทบเมนูเตรียมตัว
  ListTile requestbloodMenu() {
    return ListTile(
      leading: Icon(Icons.bookmark_border),
      title: Text('ขอรับบริจาคโลหิตด่วน'),
      onTap: () {
        // setState(() {
        //   currentWidget = Requestblood();
        // });
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Requestblood());
        Navigator.push(context, route);
      },
    );
  }

//แทบเมนูออกจากระบบ
  ListTile logoutMenu() {
    return ListTile(
      leading: Icon(Icons.keyboard_return),
      title: Text('ออกจากระบบ'),
      onTap: () {
        logoutProcees();
        //Navigator.pop(context);
        //MaterialPageRoute route = MaterialPageRoute(builder: (value) => Logout());
        //Navigator.push(context, route);
      },
    );
  }

  Future<Null> logoutProcees() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    MaterialPageRoute route = MaterialPageRoute(builder: (value) => Login());
    Navigator.push(context, route);
  }

//แทบเมนูข้อมูลผู้ใช้
  ListTile usedataMenu() {
    return ListTile(
      leading: Icon(Icons.account_box),
      title: Text('ข้อมูลผู้ใช้'),
      onTap: () {
        // setState(() {
        //   currentWidget = Personal();
        // });
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Personal());
        Navigator.push(context, route);
      },
    );
  }

//UserAccountDrawrHead
  UserAccountsDrawerHeader showDrawerHeader() {
    return UserAccountsDrawerHeader(
        accountName: Text('$fname $lname'), accountEmail: Text('$email'));
  }
}
