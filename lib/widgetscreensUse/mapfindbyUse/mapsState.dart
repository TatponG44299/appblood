import 'package:appblood/model/location_model.dart';
import 'package:appblood/model/radius_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

var latuse, lnguse;

@immutable
class MapsState extends Equatable {
  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    //setState(() {
    latuse = locationData.latitude;
    lnguse = locationData.longitude;
    // });

    print("lat ============ $latuse , lng = $lnguse");
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  final MapType mapType;
  MapsState({@required this.mapType});

  factory MapsState.changeMap(MapType _mapType) {
    return MapsState(mapType: _mapType);
  }
}

class InitialMapsState extends MapsState {}

class MapTypeChanged extends MapsState {
  final MapType mapType;

  MapTypeChanged({@required this.mapType});
  @override
  String toString() {
    return 'MapTypeChanged $mapType';
  }
}

class LocationUserfound extends MapsState {
  final LocationModel locationModel;
  LocationUserfound({@required this.locationModel});
  @override
  String toString() {
    return 'LocationUserfound locationModel ${locationModel.toString()} ';
  }
}

// class LocationFromPlaceFound extends MapsState {
//   final LocationModel locationModel;
//   LocationFromPlaceFound({@required this.locationModel});
//   @override
//   String toString() {
//     return 'LocationFromPlaceFound: { locationModel ${locationModel.toString()} } ';
//   }
// }

class MarkerWithRadius extends MapsState {
  final RadiusModel raidiusModel;
  MarkerWithRadius({@required this.raidiusModel});
  @override
  String toString() {
    return 'MarkerWithRadius: radiusModel $raidiusModel';
  }
}

class RadiusUpdate extends MapsState {
  final double radius;
  final double zoom;
  RadiusUpdate({@required this.radius, @required this.zoom});
  @override
  String toString() {
    return 'RadiusUpdate:  Radius $radius, Zoom $zoom';
  }
}

class RadiusFixedUpdate extends MapsState {
  final bool radiusFixed;
  RadiusFixedUpdate({@required this.radiusFixed});
  @override
  String toString() {
    return 'RadiusFixedUpdate: radiusFixed $radiusFixed';
  }
}

class MarkerWithSnackbar extends MapsState {
  final Marker marker;
  final SnackBar snackBar;
  MarkerWithSnackbar({@required this.marker, @required this.snackBar});
  @override
  String toString() {
    return 'MarkerWithSnackbar: { marker ${marker.toString()}, snacknar ${snackBar.toString()}';
  }
}

class Loading extends MapsState {}

class Failure extends MapsState {}
