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

  DbService._internal();

  Future<void> initDatabase () async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = join(await getDatabasesPath(), _db_name);

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(barcode TEXT PRIMARY KEY, name TEXT, expiresOn DATE, quantity INTEGER)',
        );
      },
      version: _db_version,
    );
  }

  Future<int> insertProduct(Product product) async {
    await initDatabase();
    return await _database.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteProduct(String barCode) async {
    await initDatabase();
    return await _database.delete('products', where: 'barcode = ?', whereArgs: [barCode]);
  }

  Future<List<Map>> queryAll() async {
    await initDatabase();
    return await _database.query('products');
  }

  Future<int> update(Product product) async {
    await initDatabase();
    return await _database.update('products', product.toMap(), where: 'barcode = ?', whereArgs: [product.barCode]);
  }
}