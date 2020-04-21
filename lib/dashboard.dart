import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'database_helper.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPage createState() => _DashboardPage();
}


class _DashboardPage extends State<DashboardPage> {

  Position _currentPosition;

  static const timeout = const Duration(seconds: 3);
  static const ms = const Duration(milliseconds: 1);
  double latitude;
  double longitude;
  double distanceInMeters;
  bool showAlert = false;
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {

      setState(() {
        _currentPosition = position;
      });

      print("LAT final: ${latitude}, LNG final: ${longitude}");
      print("LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");
      distanceInMeters = await Geolocator().distanceBetween(latitude, longitude, _currentPosition.latitude, _currentPosition.longitude);
      print(distanceInMeters);

      if(distanceInMeters > 1){
        setState(() {
          showAlert = true;
        });
      } else {
        setState(() {
          showAlert = false;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    Location location = await helper.queryLocation(rowId);
    latitude = location.latitude;
    longitude = location.longitude;
  }

  @override
  void initState() {
    _read();
    const oneSec = const Duration(seconds:10);
    new Timer.periodic(oneSec, (Timer t) => _getCurrentLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body:AnimatedOpacity(
        opacity: showAlert ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
            margin: const EdgeInsets.all(20.0),
            color: Colors.redAccent,
            width: 800.0,
            height: 100.0,
            child: Center(
              child: Text('Go back in your circle please !!!',style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 30),),
            )
        ),
      ),

    );
  }

}