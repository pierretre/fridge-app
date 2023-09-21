import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/models/productlist-model.dart';
import 'package:fridge_app/utils/utils.dart';
import 'package:fridge_app/widgets/product-gridcard.dart';
import 'package:provider/provider.dart';

class ProductSortedGridView extends StatefulWidget {
  const ProductSortedGridView({super.key});

  @override
  State<ProductSortedGridView> createState() => _ProductSortedGridViewState();
}

class _ProductSortedGridViewState extends State<ProductSortedGridView> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductListModel>(
      builder: (context, model, child){
        var items = Utils.sortProductItemsPriorityList(model.products);
        // TEMPORARY :
        var sorted = Map.fromEntries(items.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
        return buildListView(sorted, context, model);
      }
    );
  }

  handleProductDelete(Product product, ProductListModel model) {
    model.remove(product);
  }
  
  Widget buildListView(Map<int, List<Product>> items, BuildContext context, ProductListModel model) {
    return ListView.builder(      
      itemCount: items.length,
      itemBuilder: (context, index) {
        int key = items.keys.elementAt(index);
      return Card(
          // color: Utils.getPriorityColor(key),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(Utils.getPriorityLabel(key))
              ),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, 
                childAspectRatio: 2,
                shrinkWrap: true,
                children: List.generate(items[key]!.length, (index) {
                  return ProductGridCardWidget(
                    product: items[key]![index],
                    deleteCallback: () => handleProductDelete(items[key]![index], model),
                  );
                }),
              )
            ],
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}

