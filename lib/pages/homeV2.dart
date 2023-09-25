import 'package:flutter/material.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/app-drawer.dart';
import 'package:fridge_app/widgets/product-form.dart';
import 'package:fridge_app/widgets/product-sorted-gridview.dart';

class HomePageV2 extends StatelessWidget {
  final ProductListModel _productListModel = ProductListModel();

  @override
  Widget build(BuildContext context) {

    var _filters = [];

    _productListModel.initialize();    

    return Scaffold(
      appBar: AppBar(
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
          PopupMenuButton(
            icon: Icon(Icons.filter_alt),
            iconSize: 26,
            itemBuilder: (context){
              return [
                PopupMenuItem<int>(
                    value: 0,
                    child: Text("clear all filters"),
                    onTap: () => clearAllFilters(),
                    enabled: _filters.isNotEmpty,
                ),
                PopupMenuItem<int>(
                    value: 1,
                    child: Switch.adaptive(
                      value: true,
                      onChanged: (val) {}
                    ),
                ),
                PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                    // onTap: () => handle  
                )
              ];
            },
          ),
        ],
      ),    
      drawer: AppDrawer(),        
      floatingActionButton: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: TextField(
                  onTap: () => _openBottomSheet(context, {}),
                  decoration: InputDecoration(
                    filled: true,
                    // fillColor: Colors.red,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90)
                    ),
                    hintText: "Add Item"
                  )
                )
              ),
              Expanded(
                flex: 2,
                child: FloatingActionButton(
                  child: const Icon(Icons.barcode_reader), 
                  onPressed: () async => _productScan(context)
                )
              ),
            ]
          )
        )
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
  
  clearAllFilters() {}
}