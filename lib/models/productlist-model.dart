import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/services/db-service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListModel extends ChangeNotifier {
  
  List<Product> _products = [];
  List<Product> get products => _products;
  static final ProductListModel _instance = ProductListModel._internal();

  factory ProductListModel() => _instance;

  ProductListModel._internal();

  void initialize() {
    refreshProducts();
  }

  Future<void> add(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    await DbService().insert(product).then((value) async {
      if (product.barcode != null) {
        await prefs.setString(product.barcode!, product.name);
      }
    });
    await refreshProducts();
  }
  
  void remove(Product product) async {
    final result = await DbService().delete(product);
    print("[LOG] delete => $result");
    await refreshProducts();
  }

  void update(String name, Product product) async {
    final result = await DbService().update(product);
    print("[LOG] update => $result");
    await refreshProducts();
  }
  
  refreshProducts() async {
    _products = await DbService().queryAll();  
    // print("[LOG] _products refreshed $_products");
    notifyListeners();
  }
}