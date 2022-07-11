import 'dart:io';

import 'package:adtracker/SERVICE/database.dart';
import 'package:adtracker/SERVICE/local_db.dart';
import 'package:camera/camera.dart';
import 'package:sqflite/sqflite.dart';

import '../../UI/model/record.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'records_state.dart';

class RecordsCubit extends Cubit<RecordsState> {
  RecordsCubit({required LocalDB localDB, required DataBaseRepo dataBaseRepo})
      : _localDB = localDB,
        _dataBaseRepo = dataBaseRepo,
        super(RecordsInitial(const [])) {
    handleLocalDB();
  }
  final DataBaseRepo _dataBaseRepo;
  final LocalDB _localDB;
  late Database _database;
  bool isSyncFinished = false;
  Future<void> handleLocalDB() async {
    await initialDB();
    await _readLocalRecoreds();
  }

  get isEmpty => state.records.isEmpty;
  Future<void> initialDB() async => _database = await _localDB.openDB();

  Future<void> _readLocalRecoreds() async {
    List<Record> currentList = [];
    List<Map> list = await _database.rawQuery('SELECT * FROM app_data');
    currentList = list
        .map((val) => Record(
            rid: val['rid'],
            latitude: val['lati'],
            longitude: val['long'],
            speed: val['vehicle_speed'],
            time: 0,
            dateTime: DateTime.parse(val['date_time']),
            img: val['imgUrl'],
            state: (val['state'] == 1) ? true : false))
        .toList();
    // print(_currentList);
    emit(AddRecord(currentList));
  }

  Future<void> addNewLocalRecord(List values) async {
    // Insert some records in a transaction
    await _database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO app_data(rid, lati, long, vehicle_speed, date_time, imgUrl, state) VALUES(?, ?, ?, ?, ?, ?, ?)',
          values);
      print('inserted: $id1');
      _readLocalRecoreds();
    });
  }

  void addNewRecord(Record value) async {
    emit(RecordsInitial(state.records));
    state.records.add(value);
    emit(AddRecord(state.records));
    // emit(state.copyWith(records: state.records));
  }

  //TODO: edit the update function
  Future<void> updateRecordState(String recordId, bool state) async {
    // Update some record
    int count = await _database.rawUpdate(
        'UPDATE app_data SET state = ? WHERE rid = ?',
        [(state) ? "1" : "0", recordId]);
    print('updated: $count');
  }

  void sync() async {
    List<String> dbData = await _dataBaseRepo.syncData('');
    for (var element in state.records) {
      if (dbData.contains(element.rid)) {
        print("${element.dateTime}: Uploaded ... no action needed.");
      } else {
        print(
            "${element.dateTime}: DID NOT upload .. should re-upload it again");
        var res = await _dataBaseRepo.sendData(
            element.rid,
            element.speed.toString(),
            element.latitude.toString(),
            element.longitude.toString(),
            XFile(element.img.toString()),
            element.dateTime.toString());
        if (res) {
          await updateRecordState(element.rid, true);
        }
      }
    }
    await _readLocalRecoreds();
    isSyncFinished = true;
  }

  // Delete file object
  Future<int> deleteFile(File file) async {
    try {
      await file.delete();
      return 0;
    } catch (e) {
      return 1;
    }
  }

  void deleteLocalRecordHistory() async {
    List<Map> list = await _database.rawQuery('SELECT imgUrl FROM app_data');
    for (var element in list) {
      element.forEach((key, value) {
        deleteFile(File(value));
      });
    }
    _localDB.deleteDB();
    state.records.clear();
  }
}
