import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/mySty.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:appblood/widgetscreensUse/query.dart';
import 'locationUser_Widget.dart';
import 'mapsBloc.dart';
import 'mapsEvent.dart';
import 'mapsState.dart';
import 'rangeRadius_Widget.dart';
import 'searchPlace_Widget.dart';

// var latuse , lnguse ;

class Maps extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapState();
  }
}

class _MapState extends State<Maps> {
  var latuse, lnguse, nameProject, idProject, latp, lngp, res;

  ProjectModel projectModel;

  GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Set<Circle> _circle = {};
  double _radius = 1000.0;
  double _zoom = 14.5;
  //double _zoom = 18.0;
  bool _showFixedGpsIcon = false;
  bool _isRadiusFixed = false;
  String error;
  //LatLng _center = LatLng(latuse, lnguse);
  MapType _currentMapType = MapType.normal;
  //LatLng _lastMapPosition = _center;

  MapsBloc _mapsBloc;

  Widget _googleMapsWidget(MapsState state) {
    return GoogleMap(
      onTap: (LatLng location) {
        if (_isRadiusFixed) {
          _mapsBloc.add(GenerateMarkerToCompareLocation(
              mapPosition: location,
              radiusLocation: LatLng(latuse, lnguse),
              //radiusLocation: _lastMapPosition,
              radius: _radius));
        }
      },
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(latuse, lnguse),
        zoom: _zoom,
      ),
      circles: _circle,
      markers: _markers,
      //onCameraMove: _onCameraMove,
      onCameraIdle: () {
        if (_isRadiusFixed != true)
          _mapsBloc.add(
            GenerateMarkerWithRadius(
                lastPosition: LatLng(latuse, lnguse), radius: _radius),
          );
      },
      mapType: _currentMapType,
    );
  }

  @override
  void initState() {
    super.initState();
    findLatLng();
    readDatamapProject();
    _mapsBloc = BlocProvider.of<MapsBloc>(context);
  }

  Future<Null> readDatamapProject() async {
    String url = '${Urlcon().domain}/GGB_BD/getdataProject.php?isAdd=true';

    Response response = await Dio().get(url);
    res = json.decode(response.data);
    //print('***************' + projectModel.iDProject);
    //print(res[0]['ID_Project']);
    // int inex = 0;

    for (var map in res) {
      projectModel = ProjectModel.fromJson(map);
      setState(() {
        //projectModels.add(projectModel);
        latp = double.parse(projectModel.lat);
        lngp = double.parse(projectModel.lng);
        nameProject = projectModel.projectName;
        idProject = projectModel.iDProject;
      });
      _markers.add(resultMarker());
      //setMarker.add(resultMarker());
    }
  }

  Marker resultMarker() {
    return Marker(
      markerId: MarkerId('ID_Project$idProject'),
      position: LatLng(latp, lngp),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
          title: 'ชื่อโครงการ:$nameProject',
          snippet: 'ละติจูด = $latp,ลองติจูด = $lngp'),
    );
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      latuse = locationData.latitude;
      lnguse = locationData.longitude;
    });

    print("lat55555555 ============ $latuse , lng = $lnguse");
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _mapsBloc,
        listener: (BuildContext context, MapsState state) {
          // if (state is LocationUserfound) {
          //   Scaffold.of(context)..hideCurrentSnackBar();
          //   _center = LatLng(state.locationModel.lat, state.locationModel.long);
          //   _animateCamera();
          // }
          if (state is MarkerWithRadius) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _showFixedGpsIcon = false;

            // if (_markers.isNotEmpty) {
            //   _markers.clear();
            // }
            if (_circle.isNotEmpty) {
              _circle.clear();
            }
            _markers.add(state.raidiusModel.marker);
            _circle.add(state.raidiusModel.circle);
          }

          if (state is RadiusFixedUpdate) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _isRadiusFixed = state.radiusFixed;
          }

          if (state is MapTypeChanged) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _currentMapType = state.mapType;
          }
          if (state is RadiusUpdate) {
            Scaffold.of(context)..hideCurrentSnackBar();
            _radius = state.radius;
            _zoom = state.zoom;
            _animateCamera();
          }
          if (state is MarkerWithSnackbar) {
            _markers.add(state.marker);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(state.snackBar);
          }
          // if (state is LocationFromPlaceFound) {
          //   Scaffold.of(context)..hideCurrentSnackBar();
          //   _lastMapPosition =
          //       LatLng(state.locationModel.lat, state.locationModel.long);
          // }
          if (state is Failure) {
            print('Failure');
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Error'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state is Loading) {
            print('loading');
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cargando'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
        },
        child: BlocBuilder(
            bloc: _mapsBloc,
            builder: (BuildContext context, MapsState state) {
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    latuse == null
                        ? MyStyle().showProgress()
                        : _googleMapsWidget(state),
                    // FixedLocationGps(showFixedGpsIcon: _showFixedGpsIcon),
                    // MapOption(mapType: _currentMapType),
                    LocationUser(),
                    // SearchPlace(onPressed: _animateCamera),
                    RangeRadius(isRadiusFixed: _isRadiusFixed),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  // void _onCameraMove(CameraPosition position) {
  //   if (!_isRadiusFixed) _center = position.target;
  //   if (_showFixedGpsIcon != true && _isRadiusFixed != true) {
  //     setState(() {
  //       _showFixedGpsIcon = true;
  //       if (_markers.isNotEmpty) {
  //         _markers.clear();
  //         _circle.clear();
  //       }
  //     });
  //   }
  // }

  void _animateCamera() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latuse, lnguse),
          zoom: _zoom,
        ),
      ),
    );
  }
}
