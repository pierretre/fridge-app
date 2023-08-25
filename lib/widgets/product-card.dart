import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:intl/intl.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key, required this.product, required this.deleteCallback});

  final Product product;
  final deleteCallback;
  
  static final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {

    final (date, color) = getProductLastingDays();

    return Card(
      color: color.withOpacity(.8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: () {
          print("[LOG] tap $product");
          // TODO display card infos with editor
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300,
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(date),
                isThreeLine: true,
              )
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(right: 15),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: deleteCallback,
                  icon: const Icon(
                    Icons.delete,
                    size: 40,
                  ), 
                ), 
              ),
            )
          ],
        ),   
      )     
    );
  }

  (String, Color) getProductLastingDays () {
    final difference = product.expiresOn.difference(DateTime.now()).inDays;

    if(difference < 0) return ("Expired", Colors.red);
    if(difference == 0) return ("Today", Colors.orange);
    final weeks = difference % 7;
    if(difference >= 7) return ("$weeks week${weeks == 1 ? '' : 's'}", Colors.lightGreen);
    return ("$difference days", Colors.yellow);
  }
}