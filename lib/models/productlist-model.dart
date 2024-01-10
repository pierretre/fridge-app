import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/services/db-service.dart';
import 'package:fridge_app/services/local-notifications-service.dart';

class ProductListModel extends ChangeNotifier {
  
  List<Product> _products = [];
  List<Product> get products => _products;
  static final ProductListModel _instance = ProductListModel._internal();

  factory ProductListModel() => _instance;

  ProductListModel._internal();

  void initialize() async {
    await refreshProducts();
  }

  Future<void> add(Product product) async {
    await DbService().insert(product).then((value) => refreshProducts());
  }
  
  void remove(Product product) async {
    await DbService().delete(product).then((value) async {
      await refreshProducts();
      log("[delete => $value");
    });
  }

  void update(String name, Product product) async {
    await DbService().update(product).then((value) async {
      await refreshProducts();
    });
  }
  
  refreshProducts() async {
    _products = await DbService().queryAll(); 
    LocalNotificationsService().scheduleNotificationBasedOnProducts(_products);
    notifyListeners();
  }

  Product? containsProduct(String barcode, String label) {
    return _products.firstWhere((item) => item.barcode == barcode || item.label == label);
  }
}