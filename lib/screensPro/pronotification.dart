// import 'package:appblood/screensUse/notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class Pronoti extends StatefulWidget {
//   @override
//   _PronotiState createState() => _PronotiState();
// }

// class _PronotiState extends State<Pronoti> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     notification();
//     Pronoti();
//   }

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> notification() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings("@mipmap/ic_launcher");

//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   @override
//   Future<void> _showNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('Id', 'การแจ้งเตือนโครงการ', 'รายละเอียด',
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');

//     const NotificationDetails plantformChannelDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         001,
//         'มีการจัดตั้งโครงการรับบริจาคขึ้น!',
//         'กดเพื่อดูรายละเอียด',
//         plantformChannelDetails);
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Give&Get Blood'),
//         ),
//         body: Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 child: RaisedButton(
//                   onPressed: () {
//                     _showNotification();
//                   },
//                   child: Text('แจ้งเตือน'),
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
