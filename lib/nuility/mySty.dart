import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.orange.shade900;
  Color blueColor = Colors.blue.shade500;
  Color tealColor = Colors.teal.shade500;

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget titleCenter(BuildContext context, String string){
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
           style: TextStyle(
             fontSize: 24.0,
             fontWeight: FontWeight.bold,
        )
      ),
      ),
    );
  }
}