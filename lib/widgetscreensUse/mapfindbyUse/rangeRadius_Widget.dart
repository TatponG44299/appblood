import 'dart:convert';

import 'package:appblood/model/project_madel.dart';
import 'package:appblood/nuility/my_con.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'mapsBloc.dart';
import 'mapsEvent.dart';
import 'mapsState.dart';

class RangeRadius extends StatefulWidget {
  final bool isRadiusFixed;
  const RangeRadius({@required this.isRadiusFixed});

  @override
  _RangeRadiusState createState() => _RangeRadiusState();
}

class _RangeRadiusState extends State<RangeRadius> {
  double _radius = 1000;
  MapsBloc _mapsBloc;
  var res, lat, lng, nameProject, idProject;
  ProjectModel projectModel;

  @override
  void initState() {
    super.initState();
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
        lat = double.parse(projectModel.lat);
        lng = double.parse(projectModel.lng);
        nameProject = projectModel.projectName;
        idProject = projectModel.iDProject;
      });
      //setMarker.add(resultMarker());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _mapsBloc,
      listener: (context, state) {
        if (state is RadiusUpdate) {
          _radius = state.radius;
        }
      },
      child: Positioned(
        bottom: 20.0,
        left: 10.0,
        right: 10.0,
        child: Card(
            child: BlocBuilder(
          bloc: _mapsBloc,
          builder: (context, state) {
            return Column(
              children: <Widget>[
                Text(_radius.toInt().toString() + ' กิโลเมตร'),
                Slider(
                  max: 20000,
                  min: 1000,
                  value: _radius,
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey,
                  divisions: 12,
                  onChanged: (double value) {
                    if (!widget.isRadiusFixed) {
                      _mapsBloc.add(UpdateRangeValues(radius: value));
                    }
                  },
                ),
                FlatButton(
                  child: Text(widget.isRadiusFixed != true
                      ? 'Fijar Radio'
                      : 'Cancelar'),
                  onPressed: () =>
                      //readDatamapProject(isRadiusFixed: widget.isRadiusFixed),
                      _mapsBloc.add(
                    IsRadiusFixedPressed(isRadiusFixed: widget.isRadiusFixed),
                  ),
                  color:
                      widget.isRadiusFixed != true ? Colors.blue : Colors.red,
                )
              ],
            );
          },
        )),
      ),
    );
  }
}
