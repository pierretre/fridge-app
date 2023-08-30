import 'dart:convert';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:openfoodfacts/openfoodfacts.dart';



class BarcodeService {

  static final BarcodeService _instance = BarcodeService._internal();
  static const _apiUrlV2 = "https://world.openfoodfacts.net/api/v3/product/";
  static const _apiUrlV0 = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m";

  factory BarcodeService() {
    return _instance;
  }

  BarcodeService._internal();


  Future<String> barcodeExtract() async {
    return await FlutterBarcodeScanner.scanBarcode("#ff6666", 
                                              "Cancel",
                                              false, 
                                              ScanMode.BARCODE);
  }


  Future<(String?, String?)> barcodeScanningBis() async {

    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Your app name', url: 'Your url, if applicable');

    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.ENGLISH
    ];

    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.FRANCE;

    // String barcode = await barcodeExtract();
    
    // print("[LOG] result : $barcode");

    // if(barcode == "-1") barcode = "3017620422003";
    // print("[LOG] barcode after : $barcode");
    
    final barcode = "3017620422003";

    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      fields: [ProductField.SELECTED_IMAGE, ProductField.NAME_ALL_LANGUAGES],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      print(result.product);
      return (null, null);
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  Future<(String?, String?)> barcodeScanning() async {
    // return barcodeScanningBis();

    String barcode = await barcodeExtract();
    
    print("[LOG] result : $barcode");

    if(barcode == "-1") barcode = "978020137962";
    
    final res = await BarcodeService().getProductName(barcode);

    print("[LOG] res=$res");

    return res;
  }

  Future<(String?, String?)> getProductName(String barcode) async {
    // // cache system
    // final prefs = await SharedPreferences.getInstance();

    // print(prefs.getKeys());
    // if(prefs.containsKey(barcode)) return prefs.get(barcode) as (String?, String?);

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