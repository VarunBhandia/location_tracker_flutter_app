import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracker/login_page.dart';

class LocationPermission extends StatefulWidget {
  @override
  _LocationPermissionPage createState() => _LocationPermissionPage();
}
class _LocationPermissionPage extends State<LocationPermission> {

  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            FlatButton(
              child: Text("Allow location access"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {

    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

      setState(() {
        _currentPosition = position;
      });
      print("LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

    }).catchError((e) {
      print(e);
    });
  }
}