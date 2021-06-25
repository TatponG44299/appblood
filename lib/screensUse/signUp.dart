import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:appblood/screensUse/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //field
  String email, password, confpassword, chooseType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          BlackButtonWidget(),

          //
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.mail), onPressed: null),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: TextField(
                    onChanged: (value) => email = value.trim(),
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                ))
              ],
            ),
          ),

          //
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) => password = value.trim(),
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                ))
              ],
            ),
          ),

          //
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.lock), onPressed: null),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(right: 20, left: 10),
                  child: TextField(
                    onChanged: (value) => confpassword = value.trim(),
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Confirm password'),
                  ),
                ))
              ],
            ),
          ),

          //
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Row(
              children: [
                Radio(
                  value: 'user',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text('ผู้ใช้ที่ต้องการบริจาคโลหิต'),
              ],
            ),
          ),

          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Row(
              children: [
                Radio(
                  value: 'project',
                  groupValue: chooseType,
                  onChanged: (value) {
                    setState(() {
                      chooseType = value;
                    });
                  },
                ),
                Text('ผู้ใช้ที่ต้องการเปิดโครงการ'),
              ],
            ),
          ),

          //
          SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 60,
                child: RaisedButton(
                  onPressed: () {
                    if (password == null ||
                        password.isEmpty ||
                        email == null ||
                        email.isEmpty ||
                        confpassword == null ||
                        confpassword.isEmpty ||
                        chooseType == null) {
                      normalDialog(context, 'Please fill in all fields.');
                    } else if (password != confpassword ||
                        confpassword != password) {
                      normalDialog(context, 'Password mismatch.');
                    } else {
                      checkEmail();
                    }
                  },
                  color: Colors.redAccent[700],
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

//
  Future<Null> checkEmail() async {
    String url =
        '${Urlcon().domain}/GGB_BD/getUserWhereUser.php?isAdd=true&Email=$email';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerAccount();
      } else {
        normalDialog(context,
            'This $email is duplicated. Please change your email address.');
      }
    } catch (e) {
      print(e);
    }
  }

//จัดการ data
  Future<Null> registerAccount() async {
    String url =
        '${Urlcon().domain}/GGB_BD/addRegister.php?isAdd=true&Email=$email&Password=$password&ChooseType=$chooseType';
    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Login());
        Navigator.push(context, route);
      } else {
        normalDialog(context, 'Please try again.');
      }
    } catch (e) {
      print(e);
    }
  }
}

class BlackButtonWidget extends StatelessWidget {
  const BlackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('images/Ib.jpg'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        MaterialPageRoute route =
                            MaterialPageRoute(builder: (value) => Login());
                        Navigator.push(context, route);
                      })
                ],
              )),
          Positioned(
            bottom: 20,
            child: Text(
              '  Create New Account',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      )),
    );
  }
}
