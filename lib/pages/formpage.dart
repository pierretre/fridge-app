import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key, required this.product_args});

  final product_args;
  
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  var _barcode;
  var _thumbnail;
  var _description;

  final TextEditingController _label_controller = TextEditingController();
  final model = ProductListModel();


  @override
  void initState() {
    _initProductInfoFromData(widget.product_args);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row( 
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90)
                    ),
                  ),
                  child: const Text("Cancel")
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: _label_controller.value.text.isNotEmpty ? () => _handleAddButtonPressed() : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90)
                    ),
                  ),
                  child: const Text("Add item")
                ),
              ),
            ]
          )
        )
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Wrap(
          runSpacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextField(
                    controller: _label_controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90)
                      ),
                      hintText: "product label"
                    ),
                    onChanged: (value) => setState(() {}),
                  )
                ),
                Expanded(
                  flex: 2,
                  child: IconButton.filled(
                    icon: const Icon(Icons.barcode_reader), 
                    onPressed: () async => _handleBarcodeButtonPressed()
                  )
                ),
              ]
            ),
            Container(
              child: CalendarDatePicker(
                initialDate: _selectedDate, 
                firstDate: DateTime.now(), 
                lastDate: DateTime(2050), 
                onDateChanged: (value) => setState(() => _selectedDate = value)
              )
            )
          ]
        )
      ),
    );
  }
  
  /*
   * Fills the form inputs with values passed as parameters
   */
  void _initProductInfoFromData(Map<String, String?> product_args) {
    log(product_args.toString());
    setState(() {
      _barcode = product_args['product_barcode'];
      _label_controller.text = product_args['product_label'] ?? "";
      _description = product_args['product_description'];
      _thumbnail = product_args['product_thumbnail'];
    });
  }

  void _handleAddButtonPressed() async {
    log(_label_controller.value.text);
    await model.add(Product(
      barcode: _barcode,
      label: _label_controller.value.text, 
      addedOn: DateTime.now(), 
      expiresOn: _selectedDate, 
      quantity: 1, 
      description: _description, 
      thumbnail: _thumbnail
    )).catchError((error, stackTrace) => _handleProductAddError(context, error));
    Navigator.of(context).pop();
  }

  /*
   * In case the product canot be added to the database :  
   */
  _handleProductAddError(BuildContext context, String? error) {
    final message = error == null ? "Undefined error." : "Couldn't add the product, an item with the same $error already exist";
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message)      
    ));
  }
  
  _handleBarcodeButtonPressed() async {
    BarcodeService().barcodeScanning()
    .then((value) => _initProductInfoFromData(value))
    .onError((error, stackTrace) => _handleProductScanError(context));  
  }

  /*
   * In case the app can't recover product informations from the api :  
   */
  _handleProductScanError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Couldn't retrieve product informations, please unsure you have access to the internet"),        
    ));
  }
}