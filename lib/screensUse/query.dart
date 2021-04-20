import 'package:flutter/material.dart';

class Query extends StatefulWidget {
  @override
  _QueryState createState() => _QueryState();
}

class _QueryState extends State<Query> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แบบสอบถาม'),),
    );
  }
}