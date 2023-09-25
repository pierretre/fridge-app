import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:fridge_app/utils/utils.dart';
import 'package:intl/intl.dart';

class ProductGridCardWidget extends StatelessWidget {
 
  const ProductGridCardWidget({super.key, required this.product, this.priority, required this.deleteCallback});

  final Product product; 
  final priority;
  final deleteCallback;
  
  @override
  Widget build(BuildContext context) {

    // final (remainingTime, _) = Utils.getProductLastingDays(product.expiresOn);

    return Card(      
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Utils.getPriorityColor(priority), width: 5),
          ),
        ),
        child: InkWell(        
          onTap: () => _handleTap(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: ListTile(
                  title: Text(product.label),
                  subtitle: Text(DateFormat('yyyy/MM/dd').format(product.expiresOn)),
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
      )
    );
  }

  void _handleTap() {
    print("[LOG] tap $product");
    // TODO display card infos with editor
  }
}