import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';

class ProductFormWidget extends StatefulWidget {
  const ProductFormWidget({super.key, this.barCode, this.product});

  final String? barCode;
  final Product? product;
  
  @override
  State<ProductFormWidget> createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  
  DateTime date = DateTime.now();
  String name = "";

  @override
  Widget build(BuildContext context) {

    initializeForm();
    return Container(
      height: 400, // Hauteur du panneau
      padding: const EdgeInsets.all(5),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.only(
      //     topRight: Radius.circular(15),
      //     topLeft: Radius.circular(15)
      //   ),
      // ),
      child: Column(
        
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.outlined(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.keyboard_double_arrow_down),
              iconSize: 45,
            ),            
            TextField(
              decoration: const InputDecoration(
                icon: Icon(Icons.abc),
                border: OutlineInputBorder(),
                hintText: 'Enter the product name',
                labelText: 'Product',
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ), 
            Row(
              children: [
                Text("Expires On ${date.year}/${date.month}/${date.day}"),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context, 
                      initialDate: date, 
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2100)
                    );
                    if(newDate != null) setState(() => date = newDate);
                  },
                  icon: const Icon(
                    Icons.calendar_view_day_outlined,
                    size: 40,
                  ), 
                )
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => handleButtonPressed(),
                  child: const Row(
                    children: [
                      Text("Add product"),
                      Icon(Icons.add)
                    ]
                  ),
                ),
              )
            )
          ],
        )
      );
  }
  
  initializeForm() async {
    // name = await BarcodeService().getProductName(widget.barCode);
  }
  
  handleButtonPressed() async {
    await ProductListModel().add(Product(name, "dummy_barcode", date, 1));
    Navigator.of(context).pop();
  }
}