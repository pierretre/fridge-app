import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';

class ProductItem extends StatefulWidget {

  final Product product;
  final onDelete;
  const ProductItem({super.key, required this.product, required this.onDelete});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.product.name),
        subtitle: Text(widget.product.expiresOn.toString()),
        isThreeLine: true,
        onTap: () {
          print("TODO : display edit widget");
        },
      ),
    );
  }
}