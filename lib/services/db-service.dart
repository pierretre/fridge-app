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
          'CREATE TABLE products(name TEXT PRIMARY KEY, barcode TEXT, expiresOn DATE, quantity INTEGER)',
        );
      },
      version: _db_version,
    );
  }

  Future<int> insertProduct(Product product) async {
    await initDatabase();

    await _database.insert('products', Product("n1", "", DateTime.now(), 1).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await _database.insert('products', Product("n2", "", DateTime.now(), 1).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await _database.insert('products', Product("n3", "", DateTime.now(), 1).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await _database.insert('products', Product("n4", "", DateTime.now(), 1).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await _database.insert('products', Product("n5", "", DateTime.now(), 1).toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return await _database.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteProduct(Product product) async {
    await initDatabase();
    return await _database.delete('products', where: 'name = ?', whereArgs: [product.name]);
  }

  Future<List<Product>> queryAll() async {
    await initDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('products');
    return List.generate(maps.length, (index) {
      return Product(maps[index]['barcode'].toString(), maps[index]['name'].toString(), DateTime.parse(maps[index]['expiresOn']), maps[index]['quantity']);
    });
  }

  Future<int> update(String name, Product product) async {
    await initDatabase();
    return await _database.update('products', product.toMap(), where: 'name = ?', whereArgs: [name]);
  }
}