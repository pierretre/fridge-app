import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key, required this.product, required this.deleteCallback});

  final Product product;
  final deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: () {
          print("tap $product");
          // TODO display card infos with editor
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300,
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(product.expiresOn.toString()),
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
}