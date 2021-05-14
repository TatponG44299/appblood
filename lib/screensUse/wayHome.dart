import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'map_search.dart';

class SelectWay extends StatefulWidget {
  @override
  _SelectWayState createState() => _SelectWayState();
}

class _SelectWayState extends State<SelectWay> {
  // static double lower = 1.0;
  // static double upper = 50.0;

  //RangeValues values = RangeValues(lower ,upper);
  int km = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Stack(
            children: <Widget>[
              //trRangeSlider()
              setDis(),
              Container(
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
                            style: TextStyle(
                                fontSize: 54, fontWeight: FontWeight.bold),
                          ),
                          Text('กิโลเมตร(กม.)')
                        ],
                      ),
                    );
                  },
                ),
              ),
              cilckButton(),
            ],
          ),
        ),
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
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Text(
        'กำหนดระยะทาง',
        style: TextStyle(fontSize: 28.0, color: Colors.redAccent[700]),
      ),
    );
  }

  Widget cilckButton() => Container(
      margin: EdgeInsets.only(top: 350),
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
      ));
}
