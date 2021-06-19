import 'dart:convert';

import 'package:appblood/model/clustering_Model.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:appblood/screensUse/statistics.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCluster extends StatefulWidget {
  //const MapCluster({ Key? key }) : super(key: key);

  @override
  _MapClusterState createState() => _MapClusterState();
}

class _MapClusterState extends State<MapCluster> {
  double lat, lng;
  var res;
  //value =[lat,lng]

  ClusteringModel clusteringModel;

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
    //var pons = clusteringModel.data;
    // for (var i in res){
    //   //lat = res[i].lat
    // }
    //print()
    //print("================== + $pons");
    // for (var map in res) {
    //   print(map);
    // }
    // Response response = await Dio().get(url);
    // res = json.decode(response.data);
    //print(res[0]['ID_Project']);
    // int inex = 0;
    //ClusteringModel clusteringModel = ClusteringModel.fromJson(map);
    //print('***********************************$clusteringModel');
    // setState(() {
    //   projectModels.add(projectModel);
    // });
    //projectModels.add(model);
  }

  // Set<Marker> showMarker() {
  //   return <Marker>[
  //     Marker(
  //         markerId: MarkerId('projectID'),
  //         position: LatLng(
  //           double.parse(model.lat),
  //           double.parse(model.lng),
  //         ),
  //         infoWindow: InfoWindow(
  //             title: 'ผู้ขอรับบริจาค',
  //             snippet: 'ละติจูด = ${model.lat},ลองติจูด = ${model.lng}'))
  //   ].toSet();
  // }

  static final thai = CameraPosition(
    target: LatLng(13.7204405, 100.4196398),
    zoom: 6,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: thai,
      mapType: MapType.normal,
      onMapCreated: (controller) {},
      // markers: showMarker(),
    );
  }

  Set<Marker> showMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('projectID'),
        position: LatLng(lat, lng
            //double.parse(model.lat),
            //double.parse(model.lng),
            ),
        // infoWindow: InfoWindow(
        //     title: 'ผู้ขอรับบริจาค',
        //     snippet: 'ละติจูด = ${model.lat},ลองติจูด = ${model.lng}'),
      )
    ].toSet();
  }
}
