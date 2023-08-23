import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/services/barcode-service.dart';
import 'package:fridge_app/services/db-service.dart';


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
      decoration: BoxDecoration(
        color: Colors.amber
      ),
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.outlined(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.keyboard_double_arrow_down),
              iconSize: 45,
            ),            
            const TextField(
              // initialValue: initializeProductName(),
              decoration: InputDecoration(    
                icon: Icon(Icons.abc),          
                border: OutlineInputBorder(),
                hintText: 'Enter the product name',
                labelText: 'Product',              
              ),
              
              // onSaved: (value) => setState(() => name = value ?? ""),
              // validator: (value) {
              //   print("[LOG] $value");
              //   if (value != null && value.isEmpty) {
              //     return 'S\'il vous plaît entrez votre nom';
              //   }
              //   return null;
              // },
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
                  onPressed: () => addNewProduct(),
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
      )
    ,);
  }

  void addNewProduct() {
    // DbService().insertProduct(Product(widget.barCode ?? "", name, date, 1));
  }
  
  initializeForm() async {
    // name = await BarcodeService().getProductName(widget.barCode);
  }
}