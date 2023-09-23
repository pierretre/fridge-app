import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/widgets/product-gridcard.dart';
import 'package:provider/provider.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({super.key});

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListModel>(
      builder: (context, model, child){
        return GridView.count(
          crossAxisCount: 2, 
          childAspectRatio: 2,
          shrinkWrap: true,
          children: List.generate(model.products.length, (index) {
            return ProductGridCardWidget(
              product: model.products[index],
              deleteCallback: () => handleProductDelete(model.products[index], model),
            );
          }),
        );
      }
    );
  }

  handleProductDelete(Product product, ProductListModel model) {
    model.remove(product);
  }
}

