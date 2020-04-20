import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPage createState() => _DashboardPage();
}


class _DashboardPage extends State<DashboardPage> {

  Position _currentPosition;

  static const timeout = const Duration(seconds: 3);
  static const ms = const Duration(milliseconds: 1);


  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

      setState(() {
        _currentPosition = position;
      });
      print("LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");

    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    const oneSec = const Duration(seconds:20);
    new Timer.periodic(oneSec, (Timer t) => _getCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text("Welcome"),


          ],
        ),
      ),
    );
  }

}