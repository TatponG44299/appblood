import 'package:flutter/material.dart';

class Mapsearchuse extends StatefulWidget {
  @override
  _MapsearchuseState createState() => _MapsearchuseState();
}

class _MapsearchuseState extends State<Mapsearchuse> {
  var array = [];

  double lat, lng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Search'),
      ),
    );
  }
}
