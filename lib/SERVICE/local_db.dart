import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDB {
  late String _DB_path;
  late Database _database;

  LocalDB() {
    openDB();
  }
  Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();
    _DB_path = join(databasesPath, 'local_db.db');
    // open the database
    _database = await openDatabase(_DB_path,
        version: 1,
        onOpen: (d) => print("Database created: $d"),
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE app_data (id INTEGER PRIMARY KEY, rid TEXT, lati REAL, long REAL, vehicle_speed REAL, date_time TEXT, score REAL, imgUrl TEXT, state INTEGER)');
        });
    return _database;
  }

  void insertRecord() async {
    // Insert some records in a transaction
    await _database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO app_data(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO app_data(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });
  }

  void readRecords() async {
    // Get the records
    List<Map> list = await _database.rawQuery('SELECT * FROM app_data');
    List<Map> expectedList = [
      {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
      {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    ];
    print(list);
    print(expectedList);
    // assert(const DeepCollectionEquality().equals(list, expectedList));
  }

  // Delete DB
  void deleteDB() async {
    // Delete the database
    await deleteDatabase(_DB_path);
  }
}
