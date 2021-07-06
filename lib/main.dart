import 'package:appblood/screensPro/Addproject.dart';
import 'package:appblood/screensPro/proInfo.dart';
import 'package:appblood/screensPro/pronotification.dart';
import 'package:appblood/screensUse/home.dart';
import 'package:appblood/screensUse/login.dart';
import 'package:appblood/widgetscreensUse/map_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screensPro/scanQRcode.dart';
import 'screensPro/searchCluster.dart';
import 'widgetscreensUse/mapShow_Project.dart';
import 'widgetscreensUse/qrcode.dart';

//เมื่อโปรเจ็คทงาน Constructor Method หรือเม็ธตอดหลักทำการ call object จากคลาสตัวล่าง
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

//class ตัวนี้ดึง widget ที่มาจาก home มาแสดง
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
      title: 'Get&Give Blood',
      home: Login(), //เริ่มต้นRun
    );
  }
}
//taskkill /F /IM dart.exe
