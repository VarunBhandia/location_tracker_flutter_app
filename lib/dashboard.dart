import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPage createState() => _DashboardPage();
}
class _DashboardPage extends State<DashboardPage> {
  Position _currentPosition;

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

  void main() {
    const oneMin = const Duration(seconds:60);
    new Timer.periodic(oneMin, (Timer t) => _getCurrentLocation());
  }



  @override
  void initState() {
    main();
    super.initState();
  }
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