import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/utils/utils.dart';

class ProductFormWidget extends StatefulWidget {
  const ProductFormWidget({super.key, this.barCode, this.product});

  final String? barCode;
  final Product? product;
  
  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  
  var _selectedDate;
  var _name;

  num _keyboardMaxHeight = 0;

  bool _dateSelect = false;
  @override
  void initState() {
    print("[LOG] form initialization");
    _selectedDate = DateTime.now().add(const Duration(days: 7));
    _name = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if(keyboardHeight > _keyboardMaxHeight) _keyboardMaxHeight = keyboardHeight;

    print("[LOG] rebuild $_keyboardMaxHeight");
    
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
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Product name',
                  ),
                  onChanged: (value) => setState(() => _name = value),
                  onTap: () => setState(() => _dateSelect = false),
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: const Icon(Icons.barcode_reader), 
                  onPressed: () { print("[LOG] tap barcode scan"); },
                )
              )
            ],
          ),
          Flexible(
            child: OutlinedButton.icon(
              onPressed: () => focusDatePickingPanel(),
              icon: const Icon(Icons.calendar_month_outlined), 
              label: Text(Utils.getProductLastingDays(_selectedDate).$1)) 
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
              onPressed: validProductInfos() ? () => handleButtonPressed() : null,
              icon: const Icon(Icons.send),
              label: const Text("Add product")
            ),
          )
        ],
      )
    );
  }
    
  handleButtonPressed() async {
    await ProductListModel().add(Product(_name, "dummy_barcode", _selectedDate, 1));
    Navigator.of(context).pop();
  }
  
  bool validProductInfos() {
    return _name != "";
    // && date.isAfter(DateTime.now() - )
  }
  
  focusDatePickingPanel() {
    print("[LOG] unfocus");
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => _dateSelect = true);
  }
}