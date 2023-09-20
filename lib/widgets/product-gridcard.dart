import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/utils/utils.dart';

class ProductGridCardWidget extends StatelessWidget {
  const ProductGridCardWidget({super.key, required this.product, required this.deleteCallback});

  final Product product;
  final deleteCallback;
  
  @override
  Widget build(BuildContext context) {

    final (remainingTime, color) = Utils.getProductLastingDays(product.expiresOn);

    return Card(
      color: color.withOpacity(.8),
      child: InkWell(
        onTap: () => _handleTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 7,
              child: ListTile(
                // tileColor: Colors.red,
                title: Text(product.name),
                subtitle: Text(remainingTime),
                isThreeLine: true,
              )
            ),
            Expanded(
              flex: 3,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: deleteCallback,
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                ), 
              ), 
            )
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    print("[LOG] tap $product");
    // TODO display card infos with editor
  }
}