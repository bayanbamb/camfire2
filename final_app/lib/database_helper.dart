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

  static const TABLENAME3 = "Rented";

  static Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DBNAME);
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLENAME ($COL1 TEXT PRIMARY KEY, $COL2 TEXT)");
    await db.execute(
        "CREATE TABLE $TABLENAME2 ($COL11 INTEGER PRIMARY KEY AUTOINCREMENT, $COL22 TEXT, $COL3 TEXT, $COL4 REAL, $COL5 TEXT, username TEXT, rented INTEGER DEFAULT 0)");
    await db.execute(
        "CREATE TABLE $TABLENAME3 (itemID INTEGER PRIMARY KEY, rentername TEXT)");
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

  Future<List<Map<String, dynamic>>> getItems2() async {
    final db = await database;
    var result = await db.query(
      TABLENAME2,
      where: "rented = ?",
      whereArgs: [false],
    );
    return result.toList();
  }

  Future<void> rentItem(int itemId, String renterName) async {
    final db = await _openDB();
    await db.rawInsert(
      "INSERT INTO $TABLENAME3 (itemID, rentername) "
      "SELECT $COL11, '$renterName' FROM $TABLENAME2 "
      "WHERE $COL11 = ?",
      [itemId],
    );
    await db.update(
      TABLENAME2,
      {"rented": 1},
      where: "$COL11 = ?",
      whereArgs: [itemId],
    );
  }

  Future<void> returnItem(int id) async {
    final db = await _openDB();
    await db.delete(
      TABLENAME3,
      where: "itemID = ?",
      whereArgs: [id],
    );
    await db.update(
      TABLENAME2,
      {"rented": 0},
      where: "$COL11 = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getRentedItems(String user) async {
    final db = await database;
    var result = await db.query(
      TABLENAME2,
      where: "rented = ?",
      whereArgs: [true],
    );
    return result.toList();
  }
}
