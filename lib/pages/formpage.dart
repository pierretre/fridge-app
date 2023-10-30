import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:intl/intl.dart';

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

  var _dateEditMode = false;
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
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      hintText: "Add Item"
                    ),
                    onTap: () => setState(() => _dateEditMode = false),
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
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => _focusDatePickingPanel(),
                icon: const Icon(Icons.calendar_month_outlined), 
                label: Text(DateFormat('MM/dd').format(_selectedDate)) 
              )
            ),
            if(_dateEditMode) Expanded(
              child: CalendarDatePicker(
                initialDate: _selectedDate, 
                firstDate: DateTime.now(), 
                lastDate: DateTime(2050), 
                onDateChanged: (value) => setState(() => _selectedDate = value)
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _label_controller.value.text.isNotEmpty ? () => _handleAddButtonPressed() : null,
                icon: const Icon(Icons.send),
                label: const Text("Add product")
              ),
            ), 
          ]
        )
      ),
    );
  }
  
  /*
   *  
   */
  void _initProductInfoFromData(Map<String, String?> product_args) {
    log(product_args.toString());
    _barcode = product_args['product_barcode'];
    _label_controller.text = product_args['product_label'] ?? "";
    _description = product_args['product_description'];
    _thumbnail = product_args['product_thumbnail'];
  }

  void _handleAddButtonPressed() async {
    await model.add(Product(
      barcode: _barcode,
      label: _label_controller.value.text, 
      expiresOn: _selectedDate, 
      quantity: 1, 
      description: _description, 
      thumbnail: _thumbnail
    )).catchError((error, stackTrace) => {
      log("[LOG] form error product")
    });
    Navigator.of(context).pop();

  }

  _handleBarcodeButtonPressed() async {
    final productFromBarcode = await BarcodeService().barcodeScanning();

    _initProductInfoFromData(productFromBarcode);
  }

  _focusDatePickingPanel() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => _dateEditMode = true);  
  }
}