import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:intl/intl.dart';

class Utils {
  
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static final List<String> _PRIORITY_LABELS = ["Expired", "Tomorrow", "Next days", "Next weeks", "Next months"];
  static final List<Color> _PRIORITY_COLORS = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
  
  /*
   * returns prority associated to DateTime as int 
   */
  static int _getPriority (DateTime dt) {
    DateTime now = DateTime.now();
    final difference = dt.difference(DateTime(now.year, now.month, now.day)).inDays;
    if(difference < 0) return 0;
    if(difference <= 1) return 1;
    if(difference < 7) return 2;
    if(difference < 31) return 3;
    return 4;
  }

  static Map<int, List<Product>>  sortProductItemsPriorityList(List<Product> items) {
    Map<int, List<Product>> sortedItems = {};
    for (var element in items) { 
      final priority = _getPriority(element.expiresOn);
      if(sortedItems[priority] == null) {
        sortedItems[priority] = [element];
      } else {
        sortedItems[priority]!.add(element);
      }
    }
    return sortedItems;
  }

  static String getPriorityLabel (int priority) {
    return _PRIORITY_LABELS[priority];
  }

  static Color getPriorityColor(int priority) {
    return _PRIORITY_COLORS[priority].withOpacity(.8);
  }
}