import 'package:flutter/material.dart';

class HRdashboardPage extends StatefulWidget {
  @override
  _HRdashboardPageState createState() => _HRdashboardPageState();
}

class _HRdashboardPageState extends State<HRdashboardPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: const Text('HR statistics',
              style: TextStyle(color: Color(0xff027DC5))),
        ),
        body: Container(),
      ),
    );
  }
}
