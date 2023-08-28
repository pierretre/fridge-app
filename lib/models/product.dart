import 'package:intl/intl.dart';

class Product {
  String barCode;
  String name; 
  DateTime expiresOn;
  int quantity;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  
  Product(this.name, this.barCode, this.expiresOn, this.quantity);

  Map<String, dynamic> toMap () {
    return {
      'name': name,
      'barcode': barCode,
      'expiresOn': formatter.format(expiresOn),
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}