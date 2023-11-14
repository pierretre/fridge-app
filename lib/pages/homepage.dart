import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/pages/formpage.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/widgets/app-drawer.dart';
import 'package:fridge_app/widgets/product-sorted-gridview.dart';

class HomePage extends StatelessWidget {
  final ProductListModel _productListModel = ProductListModel();
  final _filters = [];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    _productListModel.initialize();    

    return Scaffold(
      appBar: _buildAppBar() ,    
      drawer: const AppDrawer(),        
      floatingActionButton: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: TextField(
                  onTap: () => _openProductForm(context, {}),
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
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

  Route _createRoute(Map<String, String?>? args) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => FormPage(product_args: args),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }



  void _openProductForm(BuildContext context, Map<String, String?> args) async {
    Navigator.of(context).push(_createRoute(args));
  }
  
  void _productScan (BuildContext context) async {
    BarcodeService().barcodeScanning()
    .then((value) => _handleProductScanSuccess(context, value))
    .onError((error, stackTrace) => _handleProductScanError(context, error));    
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
  
  /*
   * In case the app can't recover product informations from the api :  
   */
  _handleProductScanError(BuildContext context, Object? error) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Couldn't retrieve product informations, please unsure you have access to the internet"),        
    ));
  }
  
  /*
   * Called when the scanning returns a value
   * Launches the form page for the user to add the product
   */
  _handleProductScanSuccess(BuildContext context, Map<String, String?> productFromBarcode) {
    // final entry = _productListModel.containsProduct(
    //   productFromBarcode['product_barcode']??"", 
    //   productFromBarcode['product_label']??""
    // );
    // if(!context.mounted) return;

    
    _openProductForm(context, productFromBarcode);
    
    // if(entry == null) {
    //   _openProductForm(context, productFromBarcode);
    // } else {
    //   showDialog(
    //     context: context, 
    //     builder: (BuildContext context) => _showDuplicateEntryDialog(context, entry)
    //   );
    // }
  }
  
  /*
   * Builds the appbar of the homepage 
   */
  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }
}