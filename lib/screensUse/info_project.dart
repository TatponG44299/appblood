import 'package:flutter/material.dart';

class ProjectInfo extends StatefulWidget {
  @override
  _ProjectInfoState createState() => _ProjectInfoState();
}

class _ProjectInfoState extends State<ProjectInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('รายละเอียดโครงการ'),),
    );
  }
}