import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'database_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPage createState() => _DashboardPage();
}


class _DashboardPage extends State<DashboardPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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

    super.initState();
    _read();
    const oneSec = const Duration(seconds:10);
    new Timer.periodic(oneSec, (Timer t) => _getCurrentLocation());
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
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
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              color: Colors.redAccent,
              width: 800.0,
              height: 100.0,
              child: Center(
                child: Text('Go back in your circle please !!!',style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 30),),
              )
            ),
            new RaisedButton(
              onPressed: _showNotificationWithDefaultSound,
              child: new Text('Show Notification Without Sound'),
            ),
          ],
        )


    ),
    );
  }
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}