import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  final String tableWords = 'words';
  final String columnId = '_id';
  final String columnWord = 'word';
  final String columnFrequency = 'frequency';

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableWords (
                $columnId INTEGER PRIMARY KEY,
                $columnWord TEXT NOT NULL,
                $columnFrequency INTEGER NOT NULL
              )
              ''');
  }
//  Future<int> insert(T word) async {
//    Database db = await database;
//    int id = await db.insert(tableWords, word.toMap());
//    return id;
//  }

//  Future<T> queryWord(int id) async {
//    Database db = await database;
//    List<Map> maps = await db.query(tableWords,
//        columns: [columnId, columnWord, columnFrequency],
//        where: '$columnId = ?',
//        whereArgs: [id]);
//    if (maps.length > 0) {
//      return Word.fromMap(maps.first);
//    }
//    return null;
//  }

}