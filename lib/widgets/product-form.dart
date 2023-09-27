import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:intl/intl.dart';

class ProductFormWidget extends StatefulWidget {

  const ProductFormWidget({super.key, required this.product_args});

  final Map<String, String?> product_args;
  
  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  
  var _selectedDate;
  var _barcode;
  var _thumbnail;
  var _description;
  
  final TextEditingController _label_controller = TextEditingController();
  final model = ProductListModel();

  num _keyboardMaxHeight = 0;
  bool _dateSelect = false;

  @override
  void initState() {
    _initProductInfoFromData(widget.product_args);
    _selectedDate = DateTime.now().add(const Duration(days: 7));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if(keyboardHeight > _keyboardMaxHeight) _keyboardMaxHeight = keyboardHeight;
    
    return Container(
      height: _keyboardMaxHeight  + 200,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(  
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: TextField(
                  controller: _label_controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Product name',
                  ),
                  onTap: () => setState(() => _dateSelect = false),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              Flexible(
                child: IconButton.outlined(
                  icon: const Icon(Icons.barcode_reader), 
                  onPressed: () => _handleBarcodeButtonPressed(),
                )
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Flexible(              
              child: OutlinedButton.icon(
                onPressed: () => _focusDatePickingPanel(),
                icon: const Icon(Icons.calendar_month_outlined), 
                label: Text(DateFormat('MM/dd').format(_selectedDate)) 
              )
            )
          ),
          if(_dateSelect) Expanded(
            child: CalendarDatePicker(
              initialDate: _selectedDate, 
              firstDate: DateTime.now(), 
              lastDate: DateTime(2050), 
              onDateChanged: (value) => setState(() => _selectedDate = value)
            ),
          ),
          const Divider(),      
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _label_controller.value.text.isNotEmpty ? () => _handleAddButtonPressed() : null,
              icon: const Icon(Icons.send),
              label: const Text("Add product")
            ),
          )
        ],
      )
    );
  }
  
  void _initProductInfoFromData(Map<String, String?> product_args) {
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
      print("[LOG] form error product")
    });
    Navigator.of(context).pop();
  }
  
  _handleBarcodeButtonPressed() async {
    final productFromBarcode = await BarcodeService().barcodeScanning();
    final entryPresent = model.containsProduct(
      productFromBarcode['product_barcode']??"", 
      productFromBarcode['product_label']??""
    );
    print("[LOG] in the items:$entryPresent");
    _initProductInfoFromData(productFromBarcode);
  }
  
  _focusDatePickingPanel() {
    // print("[LOG] unfocus");
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => _dateSelect = true);
  }

  @override
  void dispose() {
    _label_controller.dispose();
    super.dispose();
  }
}