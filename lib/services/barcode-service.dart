import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeService {

  static final BarcodeService _instance = BarcodeService._internal();
  static final _apiUrl = "https://world.openfoodfacts.net/api/v2/product/";

  factory BarcodeService() {
    return _instance;
  }

  BarcodeService._internal();

  Future<String?> getProductName(String barcode) async {
    // cache system
    final prefs = await SharedPreferences.getInstance();

    print(prefs.getKeys());
    if(prefs.containsKey(barcode)) return prefs.getString(barcode);
    
    final response = await http.get(Uri.parse('$_apiUrl$barcode'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['product']['product_name'];
    } 
    return null;
  }
}