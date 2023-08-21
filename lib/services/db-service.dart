import 'package:fridge_app/models/product.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  static const _db_name = "products.db";
  static const _db_version = 1;

  late Database _database;
  factory DbService() {
    return _instance;
  }

  DbService._internal() {
    initDatabase();
  }  

  initDatabase () async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      join(await getDatabasesPath(), _db_name),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(barcode TEXT PRIMARY KEY, name TEXT, expiresOn DATE, quantity INTEGER)',
        );
      },
      version: _db_version,
    );
  }

  Future<void> insertProduct(Product product) async {
    await _database.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProduct(Product product) async {
    await _database.delete('products', where: 'barcode = ?', whereArgs: [product.barCode]);
  }
}