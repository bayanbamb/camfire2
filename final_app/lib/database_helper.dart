import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const DBNAME = "Login.db";
  static const TABLENAME = "users";
  static const COL1 = "username";
  static const COL2 = "password";

  static const TABLENAME2 = "items";
  static const COL11 = "id";
  static const COL22 = "name";
  static const COL3 = "description";
  static const COL4 = "price";
  static const COL5 = "image";

  static Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DBNAME);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLENAME ($COL1 TEXT PRIMARY KEY, $COL2 TEXT)");
    await db.execute(
        "CREATE TABLE $TABLENAME2 ($COL11 INTEGER PRIMARY KEY AUTOINCREMENT, $COL22 TEXT, $COL3 TEXT, $COL4 REAL, $COL5 TEXT, username TEXT)");
  }

  Future<Database> get database async {
    return await _openDB();
  }

  Future<bool> insertData(String username, String password) async {
    final db = await database;
    final contentValues = {
      COL1: username,
      COL2: password,
    };
    final result = await db.insert(TABLENAME, contentValues);
    return result != -1;
  }

  Future<bool> checkUsername(String username) async {
    final db = await database;
    final cursor = await db
        .rawQuery("SELECT * FROM $TABLENAME WHERE $COL1 = ?", [username]);
    return cursor.length > 0;
  }

  Future<bool> checkUsernamePassword(String username, String password) async {
    final db = await database;
    final cursor = await db.rawQuery(
        "SELECT * FROM $TABLENAME WHERE $COL1 = ? AND $COL2 = ?",
        [username, password]);
    return cursor.length > 0;
  }

  Future<bool> insertItems(String name, String description, double price,
      String image, String username) async {
    final db = await database;
    final contentValues2 = {
      COL22: name,
      COL3: description,
      COL4: price,
      COL5: image,
      'username': username,
    };
    final result = await db.insert(TABLENAME2, contentValues2);
    return result != -1;
  }

  Future<bool> deleteItem(int id) async {
    final db = await database;
    final result =
        await db.delete(TABLENAME2, where: '$COL11 = ?', whereArgs: [id]);
    return result != 0;
  }

  Future<List<Map<String, dynamic>>> getItems(String loggedInUser) async {
    final db = await database;
    var result = await db.query(
      TABLENAME2,
      where: 'username = ?',
      whereArgs: [loggedInUser],
    );
    return result.toList();
  }
}
