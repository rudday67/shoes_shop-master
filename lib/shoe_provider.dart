import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'shoe.dart';

//mengelola databses produk dan untuk akses kamera dan file produk 

class ShoeProvider with ChangeNotifier {
  List<Shoe> _shoes = [];

  List<Shoe> get shoes => _shoes;

  Future<void> loadShoes() async {
    final dbHelper = DatabaseHelper();
    final shoeMaps = await dbHelper.getShoes();
    _shoes = shoeMaps.map((map) => Shoe.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addShoe(Shoe shoe) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertShoe(shoe.toMap());
    await loadShoes();
  }

  Future<void> updateShoe(Shoe shoe) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.updateShoe(shoe.toMap());
    await loadShoes();
  }

  Future<void> deleteShoe(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteShoe(id);
    await loadShoes();
  }

  Future<String> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) return '';

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final savedImage = await File(pickedFile.path)
        .copy('${appDir.path}/$fileName');

    return savedImage.path;
  }
}
