import 'package:flutter/material.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/product-form.dart';
import 'package:fridge_app/widgets/product-list.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final ProductListModel _productListModel = ProductListModel();

  @override
  Widget build(BuildContext context) {
    _productListModel.initialize();
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.more_vert
              ),
            )
          ),
        ],
      ),
      floatingActionButton: IntrinsicHeight(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(45)),
            color: Color.fromARGB(113, 0, 0, 0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: IntrinsicWidth(
            child: Row( 
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.barcode_reader), 
                  onPressed: () async => _productScan(context)
                ),
                const VerticalDivider(
                  thickness: 3,
                  color: Color.fromARGB(63, 0, 0, 0),
                  indent: 5,
                  endIndent: 5,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => _openBottomSheet(context, null, null)
                ),
              ].map((widget) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: widget,
              )).toList(),
            )
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: const ProductList(),
    );
  }

  void _openBottomSheet(BuildContext context, String? name, String? thumbnail) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductFormWidget(name: name, thumbnail: thumbnail);
      },
    );
  }
  
  void _productScan (BuildContext context) async {
    // final (name, thumbnail) = await BarcodeService().barcodeScanning();
    // print("[LOG] name: $name thumb: $thumbnail");
    // _openBottomSheet(context, name, thumbnail);

    // final res = await getProduct();
    // final res = await BarcodeService().getProductName("978020137962");
    final res = await BarcodeService().barcodeScanningBis();
    print("[LOG] result=$res");
  }

  Future<String?> getProduct() async {
    var barcode = '0048151623426';

    final ProductQueryConfiguration configuration = ProductQueryConfiguration(
      barcode,
      language: OpenFoodFactsLanguage.GERMAN,
      fields: [ProductField.ALL],
      version: ProductQueryVersion.v3,
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == ProductResultV3.statusSuccess) {
      return result.product.toString();
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }
}