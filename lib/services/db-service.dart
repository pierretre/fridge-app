import 'package:fridge_app/models/product.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  static const _db_name = "products.db";
  static const _db_version = 2;

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
          'CREATE TABLE products(id INTEGER PRIMARY KEY NOT NULL, label TEXT NOT NULL, barcode TEXT, addedOn DATE NOT NULL, expiresOn DATE NOT NULL, quantity INTEGER NOT NULL, description TEXT, thumbnail TEXT)',
        );
      },
      version: _db_version,
    );
  }

  Future<int> insert(Product product) async {
    await initDatabase();
    // check product is not already in database :
    final query_barcode = "SELECT * FROM products WHERE barcode = '${product.barcode}'";
    if((await _database.rawQuery(query_barcode)).isNotEmpty) return Future.error("barcode");

    final query_label = "SELECT * FROM products WHERE barcode = '${product.label}'";
    if((await _database.rawQuery(query_label)).isNotEmpty) return Future.error("label");

    // if all good add to database :
    return await _database.insert('products', product.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(Product product) async {
    await initDatabase();
    return await _database.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<int> delete(Product product) async {
    await initDatabase();
    return await _database.delete('products', where: 'id = ?', whereArgs: [product.id]);
  }

  Future<List<Product>> queryAll() async {
    await initDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('products');
    return List.generate(
      maps.length, (index) => Product(
        id: maps[index]['id'], 
        label: maps[index]['label'].toString(), 
        barcode: maps[index]['barcode'].toString(), 
        addedOn: DateTime.parse(maps[index]['expiresOn']), 
        expiresOn: DateTime.parse(maps[index]['expiresOn']), 
        quantity: maps[index]['quantity'],
        description: maps[index]['description'].toString(),
        thumbnail: maps[index]['thumbnail'].toString()
      )
    );
  }

  static dumpDatabase() async {
    databaseFactory.deleteDatabase(join(await getDatabasesPath(), _db_name));
  }
}