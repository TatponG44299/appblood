import 'package:appblood/screensUse/home.dart';
import 'package:appblood/screensUse/login.dart';
import 'package:appblood/widgetscreensUse/map_search.dart';
import 'package:flutter/material.dart';

import 'screensPro/searchCluster.dart';
import 'widgetscreensUse/mapShow_Project.dart';

//เมื่อโปรเจ็คทงาน Constructor Method หรือเม็ธตอดหลักทำการ call object จากคลาสตัวล่าง
void main() {
  runApp(MyApp());
}

//class ตัวนี้ดึง widget ที่มาจาก home มาแสดง
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      title: 'Get&Give Blood',
      home: MapShowProject(), //เริ่มต้นRun
    );
  }
}
