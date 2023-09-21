import 'package:flutter/material.dart';
import 'package:fridge_app/models/product.dart';
import 'package:intl/intl.dart';

class Utils {
  
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  static final List<String> _PRIORITY_LABELS = ["Expired", "Tomorrow", "Next days", "Next weeks", "Next months"];
  static final List<Color> _PRIORITY_COLORS = [Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];
  
  static (String, Color) getProductLastingDays (DateTime dt) {
    DateTime now = DateTime.now();
    final difference = dt.difference(DateTime(now.year, now.month, now.day)).inDays;

    if(difference < 0) return ("Expired", Colors.white);
    if(difference == 0) return ("Today", Colors.white);
    final weeks = (difference - difference % 7) ~/ 7;
    if(difference >= 7) return ("$weeks week${weeks == 1 ? '' : 's'}", Colors.white);
    return ("$difference day${(difference % 7) == 1 ? '' : 's'}", Colors.white);
  }

  static int _getPriority (DateTime dt) {
    DateTime now = DateTime.now();
    final difference = dt.difference(DateTime(now.year, now.month, now.day)).inDays;

    if(difference < 0) return 0;
    if(difference == 0) return 1;
    if(difference < 7) return 2;
    if(difference <= 31) return 3;
    return 4;
  }

  static Map<int, List<Product>>  sortProductItemsPriorityList(List<Product> items) {
    Map<int, List<Product>> sortedItems = {};
    items.forEach((element) { 
      final priority = _getPriority(element.expiresOn);
      if(sortedItems[priority] == null) {
        sortedItems[priority] = [element];
      } else {
        sortedItems[priority]!.add(element);
      }
    });
    return sortedItems;
  }

  static String getPriorityLabel (int priority) {
    return _PRIORITY_LABELS[priority];
  }

  static getPriorityColor(int priority) {
    return _PRIORITY_COLORS[priority].withOpacity(.5);
  }
}