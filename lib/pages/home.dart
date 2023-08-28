import 'package:flutter/material.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/product-form.dart';
import 'package:fridge_app/widgets/product-list.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
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
                  onPressed: () async => barcodeScanning(context)
                ),
                const VerticalDivider(
                  thickness: 3,
                  color: Color.fromARGB(63, 0, 0, 0),
                  indent: 5,
                  endIndent: 5,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () => _openBottomSheet(context)
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

  void _openBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const ProductFormWidget();
      },
    );
  }
  
  void productScan (BuildContext context) async {
    // String? name = await barcodeScanning(context);
  }

  Future<String?> barcodeScanning(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", 
                                              "Cancel",
                                              false, 
                                              ScanMode.BARCODE);
    
    print("[LOG] result : $barcodeScanRes");

    if(barcodeScanRes == "-1") return null;
    
    return await BarcodeService().getProductName(barcodeScanRes);
  }
}