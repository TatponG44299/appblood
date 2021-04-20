import 'package:flutter/material.dart';

class Notfic extends StatefulWidget {
  @override
  _NotficState createState() => _NotficState();
}

class _NotficState extends State<Notfic> {
  
  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1980),
      lastDate: DateTime(2020),
    );

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งเตือน'),
      ),
      body: Center(
        child: IconButton(icon: Icon(Icons.calendar_today),
          onPressed: () {
            setState(() {
              _selectDate(context);
            });
          },
        ),
      ),
    );
  }
}
