import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class BarcodeService {

  static final BarcodeService _instance = BarcodeService._internal();
  
  factory BarcodeService() {
    return _instance;
  }

  BarcodeService._internal() {
    OpenFoodAPIConfiguration.userAgent = const UserAgent(name: 'Fridge app', url: 'https://github.com/pierretre/fridge-app');
    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.ENGLISH
    ];
    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.FRANCE;
  }

  Future<String> _barcodeExtract() async {
    return await FlutterBarcodeScanner.scanBarcode("#ff6666", 
                                              "Cancel",
                                              false, 
                                              ScanMode.BARCODE);
  }

  Future<Map<String, String?>> _getProductInfosFromAPI(String barcode) async {
    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      fields: [ProductField.IMAGE_FRONT_SMALL_URL, ProductField.GENERIC_NAME, ProductField.NAME],
      version: ProductQueryVersion.v3,
      country: OpenFoodAPIConfiguration.globalCountry
    );
    final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(configuration);
    if (result.status == ProductResultV3.statusSuccess) {
      return {
        'product_barcode' : barcode,
        'product_label' : result.product?.productName,
        'product_description' : result.product?.genericName,
        'product_thumbnail' : result.product?.imageFrontSmallUrl
      };
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  Future<Map<String, String?>> barcodeScanning() async {
    String barcode = await _barcodeExtract();

    // FOR TESTING PURPOSE : TODO
    if(barcode == "-1") barcode = "3017620422003";

    return await _getProductInfosFromAPI(barcode);
  }
}   