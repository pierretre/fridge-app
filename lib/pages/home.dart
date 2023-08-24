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
    _productListModel.initialize(); // Appel initial pour rafraîchir les produits
    SharedPreferences.setMockInitialValues({});
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color.fromARGB(255, 234, 233, 229),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.search,
                size: 26.0,
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                  Icons.more_vert
              ),
            )
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: const Icon(
                Icons.barcode_reader
              ),
              onPressed: () async => barcodeScanning(context)
            ),
            FloatingActionButton(
              child: const Icon(
                Icons.add
              ),
              onPressed: () => _openBottomSheet(context)
            ),
          ].map((widget) => Padding(
            padding: const EdgeInsets.all(16),
            child: widget,
          )).toList(),
        )
      ),
    
      // FloatingActionButton(
      //   child: const Icon(
      //     Icons.barcode_reader
      //   ),
      //   onPressed: () async => barcodeScanning(context)
      //   // onPressed: () => _openBottomSheet(context),
      //   // child: Icon(Icons.arrow_upward),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: const ProductList(),
    );
  }

  void _openBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductFormWidget();
      },
    );
  }
  
  void productScan (BuildContext context) async {
    String? name = await barcodeScanning(context);
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