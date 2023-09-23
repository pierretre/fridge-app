import 'package:flutter/material.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/product-form.dart';
import 'package:fridge_app/widgets/product-sorted-gridview.dart';

class HomePage extends StatelessWidget {
  final ProductListModel _productListModel = ProductListModel();

  @override
  Widget build(BuildContext context) {
    _productListModel.initialize();    
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
                  onPressed: () => _openBottomSheet(context, {})
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
      body: const ProductSortedGridView(),
    );
  }

  void _openBottomSheet(BuildContext context, Map<String, String?> args) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductFormWidget(product_args: args);
      },
    );
  }
  
  void _productScan (BuildContext context) async {
    final res = await BarcodeService().barcodeScanning();
    print("[LOG] result=$res");
    _openBottomSheet(context, res);
  }
}