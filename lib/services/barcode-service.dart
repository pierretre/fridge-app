import 'dart:convert';

import 'package:http/http.dart' as http;

class BarcodeService {
  static final BarcodeService _instance = BarcodeService._internal();

  factory BarcodeService() {
    return _instance;
  }

  BarcodeService._internal();

  Future<String?> getProductName(String barcode) async {
    final response = await http.get(Uri.parse('https://world.openfoodfacts.net/api/v2/product/$barcode'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['product']['product_name'];
    } 
    return null;
  }
}