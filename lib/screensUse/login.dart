import 'dart:convert';


import 'package:appblood/model/accout_model.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:appblood/screensUse/home.dart';
import 'package:appblood/screensUse/signUp.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Field
  String email, password;
  Response response;
  Dio dio = new Dio();

  //ภาพโลโก้
  Widget showLogo() {
    return Container(
        width: 130.0, height: 140.0, child: Image.asset('images/Logo.png'));
  }

  //ชื่อแอป
  Widget showAppname() {
    return Text(
      'Get & Give Blood',
      style: TextStyle(fontSize: 28.0, color: Colors.redAccent[700]),
    );
  }

  Widget showUsername() {
    return Text('Email:                                          ',
        style: TextStyle(
          fontSize: 18.0,
        ));
  }

  Widget showPassword() {
    return Text('Password:                                 ',
        style: TextStyle(
          fontSize: 18.0,
        ));
  }

  Widget showText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Don,t have an Account?", style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            MaterialPageRoute route =
                MaterialPageRoute(builder: (value) => SignUp());
            Navigator.push(context, route);
          },
          child: Text(
            ' Sign Up',
            style: TextStyle(color: Colors.red[300]),
          ),
        ),
      ],
    );
  }

//เเสดงผลออกหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              mySizebox(),
              showAppname(),
              mySizebox(),
              showUsername(),
              emailForm(),
              mySizebox(),
              showPassword(),
              passForm(),
              mySizebox(),
              loginButton(),
              mySizebox(),
              showText(),
            ],
          ),
        )),
      ),
    );
  }

  // ปุ่ม login
  Container loginButton() => Container(
      width: 250.0,
      child: ClipRRect(
        //ลดเหลี่ยมปุ่ม
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.redAccent[700],
          onPressed: () {
            //print('username=$username ,password=$password');
            if (email == null ||
                email.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'Please fill in all fields.');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ));

  //ตรวจข้อมูลกับดาจ้าเบสก่อนเข้าระบบ
  Future<Null> checkAuthen() async {
    String url =
        '${Urlcon().domain}/GGB_BD/getUserWhereUser.php?isAdd=true&Email=$email';
    try {
      Response response = await Dio().get(url);
      //print('res = $response');
      //print(response);

      var result = json.decode(response.data);
      //print('result = $result');
      for (var map in result) {
        AccountModel accountModel = AccountModel.fromJson(map);
        if (password == accountModel.password) {
          routeLoginpage(Home(), accountModel);
        } else {
          normalDialog(context, 'Password Fail. Please try again.');
        }
      }
    } catch (e) {
      normalDialog(context, 'Wrong email or password . Please try again.');
    }
  }

  //เมื่อ login เสร็จจะเข้าหน้า Home
  Future<Null> routeLoginpage(
      Widget myWidget, AccountModel accountModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //แชร์ข้อมูลไปส่วนต่างๆได้หลังจาก login
    preferences.setString('id', accountModel.iD);
    preferences.setString('email', accountModel.email);
    preferences.setString('firstName', accountModel.firstName);
    preferences.setString('firstName', accountModel.lastName);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (value) => myWidget,
    );

    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  //ระยะห่างระหว่างบรรทัดrtert
  mySizebox() => SizedBox(
        width: 8.0,
        height: 20.0,
      );

//กรอกข้อมูลการเข้าสู่ระบบ
  Widget emailForm() => Container(
        width: 250.0,
        child: TextField(
          onChanged: (value) => email = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent[700],
            ),
          ),
        ),
      );
//กรอกรหัสผ่าน
  Widget passForm() => Container(
        width: 250.0,
        child: TextField(
          obscureText: true,
          onChanged: (value) => password = value.trim(),
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.redAccent[700],
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.visibility),
                onPressed: () {
                  Visibility(
                    child: TextField(
                      obscureText: false,
                    ),
                  );
                },
              )),
        ),
      );
}
