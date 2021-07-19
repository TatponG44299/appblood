import 'dart:io';
import 'dart:math';

import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/nuility/normal_Dialog.dart';
import 'package:appblood/screensUse/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addproinfodata extends StatefulWidget {
  @override
  _AddproinfodataState createState() => _AddproinfodataState();
}

// class Region {
//   int id_GEO;
//   String name_GEO;

//   Region(this.id_GEO,this.name_GEO);

//   static List<Region> getRegion = List();

//   Future<Null> getGeo() async {
//     var response = await http.get('',headers: {'Accept':'application/json'});
//     var jsonBody = response.body;
//     var jsonData = json.decode(jsonBody);

//   }
// }

class _AddproinfodataState extends State<Addproinfodata> {
  String fname,
      lname,
      phon,
      idCustom,
      address,
      tumbol,
      district,
      county,
      urlimage;
  ImagePicker _picker = ImagePicker();
  PickedFile image;

  DateTime timedate;

  @override
  void initState() {
    super.initState();
    timedate = DateTime.now();
  }
  //String adXDate,labelText;
  //DateTime datepicker = new DateTime.now();
  //final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  //Future <Null> _selcetDate(BuildContext context) async {
  //final DateTime picked = await showDatePicker(
  //context: context,
  //initialDate: datepicker,
  //firstDate: DateTime(DateTime.now().year - 70),
  //lastDate: DateTime(DateTime.now().year + 1),);

  //if (picked != null && picked != datepicker) {
  //setState(() {
  //datepicker = picked;
  //adXDate = new DateFormat.yMd().format(datepicker);
  //});
  //} else {
  //}
  //}

  var selectedType;
  List<String> _bloodType = <String>['A', 'B', 'AB', 'O'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เพิ่ม/แก้ข้อมูลส่วนตัว')),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            imagprofile(),
            cimage(),
            gimage(),
            fnamefield(),
            //lnamefield(),
            //idfield(),
            phonfield(),
            //nameblood(),
            //bloodTypeDrop(),
            //dateHBD(),
            addressfield(),
            tumbolfield(),
            districtfield(),
            countyfield(),
            // pssp(),
            // psst(),
            // pssa(),
            // pssj(),
            saveButton(),
          ],
        ),
      ),
    );
  }

//แผนที่
  // Container addMap() {
  //   LatLng latLng = LatLng(19.027820, 99.900087);
  //   CameraPosition cameraPosition = CameraPosition(
  //     target: latLng,
  //     zoom: 16,
  //   );

  //   return Container(
  //     margin: EdgeInsets.only(top: 600),
  //     height: 300,
  //     child: GoogleMap(
  //       initialCameraPosition: cameraPosition,
  //       mapType: MapType.normal,
  //       onMapCreated: (controller) {},
  //     ),
  //   );
  // }

  Widget gimage() {
    return Container(
      margin: EdgeInsets.only(top: 100, right: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            color: Colors.red,
            iconSize: 32,
            onPressed: () => chooseImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget cimage() {
    return Container(
      margin: EdgeInsets.only(top: 100, left: 70),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            color: Colors.red,
            iconSize: 28,
            onPressed: () => chooseImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var iMage = await _picker.getImage(
        source: imageSource,
        maxHeight: 1000.0,
        maxWidth: 1000,
      );
      setState(() {
        image = iMage;
      });
    } catch (e) {}
  }

  Widget imagprofile() => Container(
        margin: EdgeInsets.only(top: 10),
        child: Center(
            child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 70.0,
              backgroundImage: image == null
                  ? AssetImage('images/pimages.png')
                  : FileImage(File(image.path)),
            )
          ],
        )),
      );

  //DateDropDown dateHBD(BuildContext context) {
  //return DateDropDown(
  //      labelText: labelText,
  //    valueText: new DateFormat.yMd().format(datepicker),
  //  onPressed: (){
  //  _selcetDate(context);
  // },
  //);
  //}

  Widget dateHBD() {
    return Container(
      margin: EdgeInsets.only(top: 318, right: 25),
      width: 230,
      child: ListTile(
        title: Text(
          'วันเกิด: ' + new DateFormat.yMMMd().format(timedate),
          style: TextStyle(fontSize: 18.0),
        ),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: dateti,
      ),
    );
  }

  dateti() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: timedate,
      firstDate: DateTime(DateTime.now().year - 70),
      lastDate: DateTime.now(),
    );

    if (date != null && date != timedate)
      setState(() {
        timedate = date;
      });
  }

  Widget saveButton() => Center(
        child: Container(
          margin: EdgeInsets.only(top: 640, left: 25, right: 25),
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: RaisedButton(
              color: Colors.red,
              onPressed: () {
                if (fname == null ||
                    fname.isEmpty ||
                    phon == null ||
                    phon.isEmpty ||
                    address == null ||
                    address.isEmpty ||
                    tumbol == null ||
                    tumbol.isEmpty ||
                    district == null ||
                    district.isEmpty ||
                    county == null ||
                    county.isEmpty) {
                  normalDialog(context, 'มีช่องว่าง กรุณากรอกให้ครบ');
                } else {
                  checkImage();
                  //checkData();
                  //print(selectedType);
                  editUser();
                }
              },
              child: Text(
                'บันทึก',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
        ),
      );

  Future<Null> checkImage() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameImage = 'Avata$i.jpg';

    //String url = '${Urlcon().domain}/GGB_BD/upLoadimage.php';
    String url = '${Urlcon().domain}/GGB_BD/upLoadimage.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(image.path, filename: nameImage);

      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('Reponse =====>$value');
        urlimage = '/GGB_BD/upImges/$nameImage';
        print('urlImage = $urlimage');
        editUser();
      });
    } catch (e) {}
  }

  Future<Null> editUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String iD = preferences.getString('id');

    String
        url = //'${Urlcon().domain}/GGB_BD/editProfileuser.php?isAdd=true&ID=$iD&First_name=$fname&Last_name=$lname&Phon=$phon&Blood_type=$selectedType&Add_detail=$address&Tombol=$tumbol&District=$district&County=$county&UrlPicture=$urlimage';
        '${Urlcon().domain}/GGB_BD/editProfileuser.php?isAdd=true&ID=$iD&First_name=$fname&Phon=$phon&Add_detail=$address&Tombol=$tumbol&District=$district&County=$county&UrlPicture=$urlimage';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(builder: (value) => Home());
        Navigator.push(context, route);
      } else {
        normalDialog(context, 'กรุณากรอกข้อมูลใหม่');
      }
    });
  }

  // Future<Null> checkData() async {
  //   String url =
  //       '${Urlcon().domain}/GGB_BD/addData.php?isAdd=true&Email=$email&First_name=$fname&Last_name=$lname&Phon=$phon&Blood_type=$selectedType&Birthday=$birthday&Add_detail=$address&Tombol=$tumbol&District=$district&County=$county';
  //   try {
  //     Response response = await Dio().get(url);
  //     print('res = $response');

  //   } catch (e) {}
  // }

  Widget fnamefield() => Container(
        margin: EdgeInsets.only(top: 150, left: 25, right: 25),
        //width: 140,
        child: TextField(
          onChanged: (value) => fname = value.trim(),
          decoration: InputDecoration(labelText: 'ชื่อ'),
        ),
      );

  Widget lnamefield() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(top: 150, right: 25),
            width: 140,
            child: TextField(
              onChanged: (value) => lname = value.trim(),
              decoration: InputDecoration(labelText: 'นามสกุล'),
            ),
          ),
        ],
      );

  Widget idfield() => Container(
        margin: EdgeInsets.only(top: 200, left: 25, right: 25),
        child: TextField(
          onChanged: (value) => idCustom = value.trim(),
          decoration: InputDecoration(labelText: 'ตำแหน่ง/หน้าที่'),
        ),
      );

  Widget phonfield() => Container(
        margin: EdgeInsets.only(top: 230, left: 25, right: 25),
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => phon = value.trim(),
          decoration: InputDecoration(labelText: 'เบอร์โทรศัพท์มือถือ'),
        ),
      );

  Widget addressfield() => Container(
        margin: EdgeInsets.only(top: 320, left: 25, right: 25),
        child: TextField(
          onChanged: (value) => address = value.trim(),
          decoration: InputDecoration(labelText: 'รายละเอียดที่อยู่'),
        ),
      );

  Widget tumbolfield() => Container(
        margin: EdgeInsets.only(top: 400, left: 25, right: 25),
        child: TextField(
          onChanged: (value) => tumbol = value.trim(),
          decoration: InputDecoration(labelText: 'ตำบล/แขวง'),
        ),
      );

  Widget districtfield() => Container(
        margin: EdgeInsets.only(top: 480, left: 25, right: 25),
        child: TextField(
          onChanged: (value) => district = value.trim(),
          decoration: InputDecoration(labelText: 'อำเภอ/เขต'),
        ),
      );

  Widget countyfield() => Container(
        margin: EdgeInsets.only(top: 560, left: 25, right: 25),
        child: TextField(
          onChanged: (value) => county = value.trim(),
          decoration: InputDecoration(labelText: 'จังหวัด'),
        ),
      );

  // Widget pssp() =>
  //         Container(
  //           margin: EdgeInsets.only(top: 420, left: 25, right: 25),
  //          // width: 120,
  //           child: DropdownButton(
  //             items: _bloodType.map((value) {
  //               var dropdownMenuItem = DropdownMenuItem(
  //                 child: Text(
  //                   value,
  //                 ),
  //                 value: value,
  //               );
  //               return dropdownMenuItem;
  //             }).toList(),
  //             onChanged: (selectBloodType) {
  //               setState(() {
  //                 selectedType = selectBloodType;
  //               });
  //             },
  //             value: selectedType,
  //             hint: Text('เลือกภูมิภาค', style: TextStyle(fontSize: 18)),
  //           ),
  //         );

  // // Widget psst() => Row(
  // //       mainAxisAlignment: MainAxisAlignment.end,
  // //       children: [
  // //         Container(
  // //           margin: EdgeInsets.only(
  // //             top: 470,
  // //             left: 25,
  // //             right: 25,
  // //           ),
  // //           child: DropdownButton(
  // //             items: _bloodType.map((value) {
  // //               var dropdownMenuItem = DropdownMenuItem(
  // //                 child: Text(
  // //                   value,
  // //                 ),
  // //                 value: value,
  // //               );
  // //               return dropdownMenuItem;
  // //             }).toList(),
  // //             onChanged: (selectBloodType) {
  // //               setState(() {
  // //                 selectedType = selectBloodType;
  // //               });
  // //             },
  // //             value: selectedType,
  // //             hint: Text('เลือกตำบล/แขวง', style: TextStyle(fontSize: 18)),
  // //           ),
  // //         ),
  // //       ],
  // //     );

  // Widget pssa() => Container(
  //       margin: EdgeInsets.only(top: 470, left: 25, right: 25),
  //       child: DropdownButton(
  //         items: _bloodType.map((value) {
  //           var dropdownMenuItem = DropdownMenuItem(
  //             child: Text(
  //               value,
  //             ),
  //             value: value,
  //           );
  //           return dropdownMenuItem;
  //         }).toList(),
  //         onChanged: (selectBloodType) {
  //           setState(() {
  //             selectedType = selectBloodType;
  //           });
  //         },
  //         value: selectedType,
  //         hint: Text('เลือกอำเภอ/เขต', style: TextStyle(fontSize: 18)),
  //       ),
  //     );

  // Widget pssj() => Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.only(
  //             top: 420,
  //             left: 25,
  //             right: 25,
  //           ),
  //           child: DropdownButton(
  //             items: _bloodType.map((value) {
  //               var dropdownMenuItem = DropdownMenuItem(
  //                 child: Text(
  //                   value,
  //                 ),
  //                 value: value,
  //               );
  //               return dropdownMenuItem;
  //             }).toList(),
  //             onChanged: (selectBloodType) {
  //               setState(() {
  //                 selectedType = selectBloodType;
  //               });
  //             },
  //             value: selectedType,
  //             hint: Text('กรุณาเลือกจังหวัด', style: TextStyle(fontSize: 18)),
  //           ),
  //         ),
  //       ],
  //     );
}
