import 'dart:convert';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class BarcodeService {

  static final BarcodeService _instance = BarcodeService._internal();
  static const _apiUrlV2 = "https://world.openfoodfacts.net/api/product/";

  factory BarcodeService() {
    return _instance;
  }

  BarcodeService._internal() {
    OpenFoodAPIConfiguration.userAgent = const UserAgent(name: 'Frdge app', url: 'https://github.com/pierretre/fridge-app');

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.ENGLISH
    ];

    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.FRANCE;
  }

  Future<String> barcodeExtract() async {
    return await FlutterBarcodeScanner.scanBarcode("#ff6666", 
                                              "Cancel",
                                              false, 
                                              ScanMode.BARCODE);
  }

  Future<Map<String, String?>> getProductInfosFromAPI(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      fields: [ProductField.SELECTED_IMAGE, ProductField.GENERIC_NAME, ProductField.NAME],
      version: ProductQueryVersion.v3,
      country: OpenFoodAPIConfiguration.globalCountry
    );
    final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      return {
        'product_label' : result.product?.productName,
        'product_description' : result.product?.genericName,
        'product_thumbnail' : ""
      };
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  Future<(String?, String?)> barcodeScanning() async {
    String barcode = await barcodeExtract();
    if(barcode == "-1") return (null, null);
    
    final res = await getProductInfosFromAPI(barcode);

    return (null, null);
  }

  Future<(String?, String?)> getProductName(String barcode) async {
    // cache system
    final prefs = await SharedPreferences.getInstance();

    print(prefs.getKeys());
    if(prefs.containsKey(barcode)) return prefs.get(barcode) as (String?, String?);

    print("[LOG] getProductName($barcode)");

    final Uri url = Uri.parse('$_apiUrlV2$barcode');
    // final Uri url = Uri.parse('$_apiUrlV0');

    final Map<String, String> headers = {
      // 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/116.0',
      'User-Agent': 'Fridge App - Android - https://github.com/pierretre/fridge-app',
    };

    final response = await http.Client(). get(url, headers: headers);
    // final response = await http.Client(). get(url);

    print("[LOG] response=${response.statusCode}");

    if (response.statusCode == 200) {
      final responseProduct = json.decode(response.body)['product'];
      return (responseProduct['product_name'].toString(), responseProduct['selected_images']['thumb']['fr'].toString());
    } 
    return (null, null);
  }
}