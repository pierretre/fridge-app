import 'package:flutter/material.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/product-form.dart';
import 'package:fridge_app/widgets/product-list.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:path/path.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'test',
          style: TextStyle(color: Color.fromARGB(225, 33, 34, 34))
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 234, 233, 229),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.large(
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

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductFormWidget(barCode: "123");
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