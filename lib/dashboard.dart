import 'package:flutter/material.dart';
import 'package:location_tracker/database_helper.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Saving data'),
      ),
      body: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: RaisedButton(
              child: Text(
                  'Read'),
              onPressed: () {
                _read(
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
                8.0),
            child: RaisedButton(
              child: Text(
                  'Save'),
              onPressed: () {
                _save(
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    Word word = await helper.queryWord( rowId);
    if (word == null) {
      print( 'read row $rowId: empty');
    }
    else {
      print( 'read row $rowId: ${word.word} ${word.frequency}');
    }
  }

  _save() async {
    Word word = Word();
    word.word = 'hello';
    word.frequency = 15;
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(word);
    print('inserted row: $id');
  }
}