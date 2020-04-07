import 'package:flutter/material.dart';
import 'package:location_tracker/database_helper.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPage createState() => _DashboardPage();
}
class _DashboardPage extends State<DashboardPage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//            'Saving data'),
//      ),
//      body: Row(
//        //mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(
//                8.0),
//            child: RaisedButton(
//              child: Text(
//                  'Read'),
//              onPressed: () {
//                _read(
//                );
//              },
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(
//                8.0),
//            child: RaisedButton(
//              child: Text(
//                  'Save'),
//              onPressed: () {
//                _save(
//                );
//              },
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  _read() async {
//    DatabaseHelper helper = DatabaseHelper.instance;
//    int rowId = 1;
//    Word word = await helper.queryWord( rowId);
//    if (word == null) {
//      print( 'read row $rowId: empty');
//    }
//    else {
//      print( 'read row $rowId: ${word.word} ${word.frequency}');
//    }
//  }
//
//  _save() async {
//    Word word = Word();
//    word.word = 'hello';
//    word.frequency = 15;
//    DatabaseHelper helper = DatabaseHelper.instance;
//    int id = await helper.insert(word);
//    print('inserted row: $id');
//  }
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

//            Text("LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
            FlatButton(
              child: Text("Get location"),
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
    }).catchError((e) {
      print(e);
    });
  }
}