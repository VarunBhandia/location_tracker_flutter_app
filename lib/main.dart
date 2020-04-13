import 'package:flutter/material.dart';
import 'location_permission.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Tracker',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LocationPermission(),
    );
  }
}
