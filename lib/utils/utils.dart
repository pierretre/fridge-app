import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  static (String, Color) getProductLastingDays (DateTime dt) {
    DateTime now = DateTime.now();
    final difference = dt.difference(DateTime(now.year, now.month, now.day)).inDays;

    if(difference < 0) return ("Expired", Colors.red);
    if(difference == 0) return ("Today", Colors.orange);
    final weeks = (difference - difference % 7) ~/ 7;
    if(difference >= 7) return ("$weeks week${weeks == 1 ? '' : 's'}", Colors.lightGreen);
    return ("$difference day${(difference % 7) == 1 ? '' : 's'}", Colors.yellow);
  }
}