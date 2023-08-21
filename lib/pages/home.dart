import 'package:flutter/material.dart';
import 'package:fridge_app/widgets/product-list.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.barcode_reader
        ),
        onPressed: () async {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", 
                                                    "Cancel",
                                                    false, 
                                                    ScanMode.BARCODE);
          print("result : $barcodeScanRes");
        }
      ),
      body: const ProductList()
    );
  }
}