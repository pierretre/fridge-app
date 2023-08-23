import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/services/db-service.dart';
import 'package:fridge_app/widgets/product-card.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  @override
  Widget build(BuildContext context) {
        print("[LOG] listview rebuild !!");
    return Consumer<ProductListModel>(
      builder: (context, model, child){
        return ListView.builder(      
          itemCount: model.products.length,
          itemBuilder: (context, index) {
            return ProductCardWidget(
              product: model.products[index],
              deleteCallback: () => handleProductDelete(model.products[index], model),
            );
          },
          shrinkWrap: true,
        );
      }
    );
  }

  handleProductDelete(Product product, ProductListModel model) {
    // setState(() {
    //   DbService().deleteProduct(product).catchError(() {
    //     print("error on deletion");
    //   });
    // });
    model.remove(product);
  }
}

