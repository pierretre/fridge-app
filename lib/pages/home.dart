import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/app-drawer.dart';
import 'package:fridge_app/widgets/product-form.dart';
import 'package:fridge_app/widgets/product-sorted-gridview.dart';

class HomePage extends StatelessWidget {
  final ProductListModel _productListModel = ProductListModel();
  final _filters = [];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {

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
            icon: const Icon(Icons.filter_alt),
            iconSize: 26,
            itemBuilder: (context){
              return [
                PopupMenuItem<int>(
                    value: 0,
                    onTap: () => clearAllFilters(),
                    enabled: _filters.isNotEmpty,
                    child: const Text("clear all filters"),
                ),
                const PopupMenuItem<int>(
                    value: 1,
                    child: Spacer(),
                ),
                const PopupMenuItem<int>(
                    value: 2,
                    child: Spacer(),
                )
              ];
            },
          ),
        ],
      ),    
      drawer: const AppDrawer(),        
      floatingActionButton: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    final productFromBarcode = await BarcodeService().barcodeScanning();
    final entry = _productListModel.containsProduct(
      productFromBarcode['product_barcode']??"", 
      productFromBarcode['product_label']??""
    );
    if(!context.mounted) return;

    if(entry == null) {
      _openBottomSheet(context, productFromBarcode);
    } else {
      showDialog(
        context: context, 
        builder: (BuildContext context) => _showDuplicateEntryDialog(context, entry)
      );
    }
  }
  
  /*
   * All cases :
   * 
   * # Same label / Same barcode :
   *    => show the item in modal with ability :
   *      -> to edit (label, description)
   *      -> to delete 
   *      -> to cancel
   *      -> to save modifications
   * 
   * # (Same label / Different barcode) OR (Different label / Same barcode):
   *    => show a dialog to choose from options :
   *      -> to open the edit modal on the product of same name with ability :
   *          -> to edit (label, quantity, description)
   *          -> to delete the entry
   *          -> to cancel
   *          -> to save modifications
   *      -> to create new entry but must change the label
   *      -> to cancel
   */
  _showDuplicateEntryDialog(BuildContext context, Product entry) {
    final quantity = entry.quantity;
    
    return AlertDialog.adaptive(
      title: Text("The product ${entry.label} is already referenced"),
      content: Text("You have currently $quantity entr${quantity>1? "ies" : "y"} for this item. Choose what to do :"),
      actions: <Widget>[
        TextButton(
          child: Text('Remove ${quantity > 1? "all items" : "the item" } from your list'),
          onPressed: () => Navigator.of(context).pop()
        ),
        // if(quantity > 1(
        //   child: const Text('Remove the item from your list'),
        //   onPressed: () { }
        // ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop()
        ),
      ],
    );
  }
  
  clearAllFilters() {}
}