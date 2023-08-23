import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/services/db-service.dart';
import 'package:fridge_app/widgets/product-card.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DbService().queryAll(), 
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data!.isNotEmpty) {
            List<Product> products = extractProductListFromSnapshot(snapshot.data);
            return ListView.builder(      
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCardWidget(
                  product: products[index],
                  deleteCallback: () => handleProductDelete(products[index]),
                );
              },
              shrinkWrap: true,
            );
          }
          else {
            return const Center(child: Text("no product scanned yet"));
          }
        }else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
    
  }

  handleProductDelete(Product product) {
    setState(() {
      DbService().deleteProduct(product).catchError(() {
        print("error on deletion");
      });
    });
  }
  
  List<Product> extractProductListFromSnapshot(List<Map>? data) {
    return data!.map((e) => Product(e['barcode'].toString(), e['name'].toString(), DateTime.parse(e['expiresOn']), e['quantity'])).toList();
  }
}

