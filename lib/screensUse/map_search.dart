import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapsearchuse extends StatefulWidget {
  @override
  _MapsearchuseState createState() => _MapsearchuseState();
}

class _MapsearchuseState extends State<Mapsearchuse> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _makers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  static final CameraPosition _positionl = CameraPosition(
    bearing: 192.883,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );

  Future<void> _goToPositionl() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_positionl));
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = _center;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _makers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Title',
          snippet: 'Snippedt',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Widget button(Function fuction, IconData icon) {
    return FloatingActionButton(
      onPressed: fuction,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.red,
      child: Icon(icon, size: 36.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Search'),
        backgroundColor: Colors.red,
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
          mapType: _currentMapType,
          markers: _makers,
          onCameraMove: _onCameraMove,
          myLocationEnabled: true,
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                button(_onMapTypeButtonPressed, Icons.map),
                SizedBox(height: 16.0),
                button(_onAddMarkerButtonPressed, Icons.add_location),
                SizedBox(height: 16.0),
                button(_goToPositionl, Icons.location_searching),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
