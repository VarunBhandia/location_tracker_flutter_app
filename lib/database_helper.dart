import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableUsers = 'users';
final String columnId = '_id';
final String columnUser = 'user';

final String tableLocation = 'location';
final String columnLocationId = '_id';
final String columnLatitude = 'latitude';
final String columnLongitude = 'longitude';

// data model class
class User {

  int id;
  String username;

  User();

  // convenience constructor to create a User object
  User.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    username = map[columnUser];
  }

  // convenience method to create a Map from this User object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUser: username,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class Location {

  int id;
  double latitude;
  double longitude;

  Location();

  // convenience constructor to create a Location object
  Location.fromLocationMap(Map<String, dynamic> map) {
    id = map[columnId];
    latitude = map[columnLatitude];
    longitude = map[columnLongitude];
  }

  // convenience method to create a Map from this Location object
  Map<String, dynamic> toLocationMap() {
    var map = <String, dynamic>{
      columnLatitude: latitude,
      columnLongitude: longitude,
    };
    if (id != null) {
      map[columnLocationId] = id;
    }
    return map;
  }
}
// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database, can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUsers (
            $columnId INTEGER PRIMARY KEY,
            $columnUser TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableLocation (
            $columnLocationId INTEGER PRIMARY KEY,
            $columnLatitude DOUBLE NOT NULL,
            $columnLongitude DOUBLE NOT NULL
            
          )
          ''');
  }

  // Database helper methods:

  Future<int> insert(User user) async {
    Database db = await database;
    int id = await db.insert(tableUsers, user.toMap());
    return id;
  }

  Future<User> queryUser(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableUsers,
        columns: [columnId, columnUser],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> queryAllUsers() async {
    Database db = await database;
    List<Map> maps = await db.query(tableUsers);
    if (maps.length > 0) {
      List<User> users = [];
      maps.forEach((map) => users.add(User.fromMap(map)));
      return users;
    }
    return null;
  }

  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(tableUsers, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    Database db = await database;
    return await db.update(tableUsers, user.toMap(),
        where: '$columnId = ?', whereArgs: [user.id]);
  }

  Future<int> insertLocation(Location location) async {
    Database db = await database;
    int id = await db.insert(tableLocation, location.toLocationMap());
    return id;
  }

  Future<Location> queryLocation(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableLocation,
        columns: [columnLocationId, columnLatitude,columnLongitude],
        where: '$columnLocationId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Location.fromLocationMap(maps.first);
    }
    return null;
  }

  Future<List<Location>> queryAllLocations() async {
    Database db = await database;
    List<Map> maps = await db.query(tableLocation);
    if (maps.length > 0) {
      List<Location> locations = [];
      maps.forEach((map) => locations.add(Location.fromLocationMap(map)));
      return locations;
    }
    return null;
  }

  Future<int> deleteLocation(int id) async {
    Database db = await database;
    return await db.delete(tableLocation, where: '$columnLocationId = ?', whereArgs: [id]);
  }

  Future<int> updateLocation(Location location) async {
    Database db = await database;
    return await db.update(tableLocation, location.toLocationMap(),
        where: '$columnLocationId = ?', whereArgs: [location.id]);
  }

}
