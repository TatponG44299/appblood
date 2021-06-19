import 'package:appblood/nuility/mySty.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../widgetscreensUse/map_search.dart';

class SelectWay extends StatefulWidget {
  @override
  _SelectWayState createState() => _SelectWayState();
}

class _SelectWayState extends State<SelectWay> {
  // static double lower = 1.0;
  // static double upper = 50.0;
  //RangeValues values = RangeValues(lower ,upper);
//Future<Null>
  int _selectedChoice;
  int km = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            setDis(),
            choiceButton(),
            distain(),
            cilckButton(),
          ],
        ),
      ),
    );
  }

  Widget choiceButton() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Center(
        child: ToggleSwitch(
          labels: ['5', '10', '20'],
          onToggle: (index) {
            print("Swictched to :$index");

            _selectedChoice = index;

            print("selectedChoice to :$_selectedChoice");
          },
          activeFgColor: Colors.white,
          inactiveFgColor: Colors.white,
        ),
      ),
    );
  }

  ListTile choiceListTile1() {
    return ListTile(
      title: Text('5 กีโลเมตร'),
      leading: Radio(
        value: 5,
        groupValue: _selectedChoice,
        onChanged: (int value) {
          setState(() {
            _selectedChoice = value;
          });
        },
      ),
    );
  }

  ListTile choiceListTile2() {
    return ListTile(
      title: Text('10 กีโลเมตร'),
      leading: Radio(
        value: 10,
        groupValue: _selectedChoice,
        onChanged: (int value) {
          setState(() {
            _selectedChoice = value;
          });
        },
      ),
    );
  }

  ListTile choiceListTile3() {
    return ListTile(
      title: Text('20 กีโลเมตร'),
      leading: Radio(
        value: 20,
        groupValue: _selectedChoice,
        onChanged: (int value) {
          setState(() {
            _selectedChoice = value;
          });
        },
      ),
    );
  }

  Container slideNum() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: SleekCircularSlider(
        initialValue: 10,
        min: 0,
        max: 51,
        appearance: CircularSliderAppearance(
          size: 250,
          customColors: CustomSliderColors(
            hideShadow: true,
            //shadowColor: Colors.black,
            dotColor: Colors.red[700],
            progressBarColors: [Colors.red, Colors.red[700]],
            progressBarColor: Colors.red[700],
            trackColor: Colors.grey[700],
          ),
          customWidths: CustomSliderWidths(
            trackWidth: 8,
            progressBarWidth: 10,
            //shadowWidth: 20,
            handlerSize: 10,
          ),
          angleRange: 360,
          startAngle: 270,
        ),
        onChange: (v) {
          setState(() {
            km = (v).floor();
          });
        },
        innerWidget: (v) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('ระยะทาง'),
                Text(
                  '$km',
                  style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),
                ),
                Text('กิโลเมตร(กม.)')
              ],
            ),
          );
        },
      ),
    );
  }

  // RangeSlider trRangeSlider() {
  // return RangeSlider(

  // activeColor: Colors.red[700],
  // inactiveColor: Colors.grey[300],
  // divisions: 5,
  // labels: RangeLabels(values.start.toString(),values.end.toString()),
  // min: lower,
  // max: upper,
  // values: values,
  // onChanged: (val){
  //   setState(() {
  //     values = val;
  //   });
  // },
  //         );
  // }
  //
  Widget setDis() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Text(
          'กำหนดระยะทาง',
          style: TextStyle(fontSize: 28.0, color: Colors.redAccent[700]),
        ),
      ),
    );
  }

  Widget distain() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Text(
          'กิโลเมตร(กม.)',
          style: TextStyle(fontSize: 28.0, color: Colors.redAccent[700]),
        ),
      ),
    );
  }

  Widget cilckButton() => Center(
        child: Container(
            margin: EdgeInsets.only(top: 50),
            width: 250.0,
            child: ClipRRect(
              //ลดเหลี่ยมปุ่ม
              borderRadius: BorderRadius.circular(10),
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                color: Colors.redAccent[700],
                onPressed: () {
                  Navigator.pop(context);
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (value) => Mapsearchuse());
                  Navigator.push(context, route);

                  // Navigator.pop(context);
                  // MaterialPageRoute route =
                  //     MaterialPageRoute(builder: (value) => Mapsearchuse());
                  // Navigator.push(context, route);
                  Text('km');
                  print(km);
                },
                child: Text(
                  'ค้นหา',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            )),
      );
}
