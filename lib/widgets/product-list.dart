import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/services/db-service.dart';
import 'package:fridge_app/widgets/product-card.dart';
import 'package:fridge_app/widgets/product-item.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = <Product>[
    Product("1234567", "produit 1", DateTime(2023, 10, 3), 1),
    Product("1234568", "produit 2", DateTime(2023, 10, 4), 2),
    Product("1234569", "produit 3", DateTime(2023, 11, 3), 1),
    Product("1234561", "produit 4", DateTime(2023, 11, 3), 1),
    Product("1234562", "produit 5", DateTime(2023, 11, 3), 1),
    Product("1234563", "produit 6", DateTime(2023, 11, 3), 1),
    Product("1234563", "produit 7", DateTime(2023, 11, 3), 1),
    Product("1234563", "produit 7", DateTime(2023, 11, 3), 1),
    Product("1234563", "produit 7", DateTime(2023, 11, 3), 1),
    Product("1234563", "produit 7", DateTime(2023, 11, 3), 1),
    Product("1234563", "produit 7", DateTime(2023, 11, 3), 1),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return ProductCardWidget(
	        product: products[index],
          deleteCallback: () => handleProductDelete(products[index]),
	      );
      },
      shrinkWrap: true,
    );
  }

  handleProductDelete(Product product) {
    setState(() {
      products.remove(product);
    });
  }
}

