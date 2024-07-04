// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstance {
  final _databaseName = 'my_database.db';
  final int _databaseVersion = 1;

  //Produk table
  final String table = 'produk';
  final String id = 'id';
  final String name = 'nama';

  Database? _database;
  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE $table ($id INTEGER PRIMARY KEY, $name TEXT)');
  }

  Future<List<ProdukModel>> all() async {
    final data = await _database!.query(table);
    List<ProdukModel> result =
        data.map((e) => ProdukModel.fromJson(e)).toList();
    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final query = await _database!.insert(table, row);
    return query;
  }

  Future<int> update(int idParam, Map<String, dynamic> row) async {
    final query = await _database!
        .update(table, row, where: '$id = ?', whereArgs: [idParam]);
    return query;
  }

  Future delete(
    int idParam,
  ) async {
    await _database!.delete(table, where: '$id = ?', whereArgs: [idParam]);
  }
}

class ProdukModel {
  final int id;
  String name;
  ProdukModel({required this.id, required this.name});
  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(id: json['id'], name: json['nama']);
  }
}
