import 'dart:convert';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCluster extends StatefulWidget {
  //const MapCluster({ Key? key }) : super(key: key);

  @override
  _MapClusterState createState() => _MapClusterState();
}

class _MapClusterState extends State<MapCluster> {
  var res, lat1, lng1, lat2, lng2, lat3, lng3;


  @override
  void initState() {
    super.initState();
    readLocation();
    //timedate = DateTime.now();
  }

  Future<Null> readLocation() async {
    String url = '${Urlcon().domain}/GGB_BD/democlustering.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    Map decoded = json.decode(response.data);

    var name = decoded['data'];
    setState(() {
      ///////////Clust1//////////////////
      lat1 = name[0]['Lat'].toDouble();
      lng1 = name[0]['Lng'].toDouble();
      ////////////Clust2/////////////////
      lat2 = name[1]['Lat'].toDouble();
      lng2 = name[1]['Lng'].toDouble();
      ///////////Clust3//////////////////
      lat3 = name[2]['Lat'].toDouble();
      lng3 = name[2]['Lng'].toDouble();
      ///////////////////////////////////
    });
    print('****************$name');
    print('****************$lat1 + $lng1');
    print('****************$lat2 + $lng2');
    print('****************$lat3 + $lng3');
  }

  static final thai = CameraPosition(
    target: LatLng(13.7204405, 100.4196398),
    zoom: 6,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('จุดที่ควรจัดตั้งโครงการ')),
      body: lat1 == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: thai,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: setMarker(),
            ),
    );
  }

  Marker clus1Marker() {
    return Marker(
      markerId: MarkerId('clusMarker1'),
      position: LatLng(lat1, lng2),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'จุดที่ควรเปิดรับโครงการที่ 1',
          snippet: 'ละติจูด = $lat1,ลองติจูด = $lng1'),
    );
  }

  Marker clus2Marker() {
    return Marker(
      markerId: MarkerId('clusMarker2'),
      position: LatLng(lat2, lng2),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'จุดที่ควรเปิดรับโครงการที่ 2',
          snippet: 'ละติจูด = $lat2,ลองติจูด = $lng2'),
    );
  }

  Marker clus3Marker() {
    return Marker(
      markerId: MarkerId('clusMarker3'),
      position: LatLng(lat3, lng3),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'จุดที่ควรเปิดรับโครงการที่ 3',
          snippet: 'ละติจูด = $lat3,ลองติจูด = $lng3'),
    );
  }

  Set<Marker> setMarker() {
    return <Marker>[
      clus1Marker(),
      clus2Marker(),
      clus3Marker(),
    ].toSet();
  }
}
