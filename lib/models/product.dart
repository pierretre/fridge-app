import 'package:intl/intl.dart';

class Product {

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final int? id;
  String name;
  String? barcode;
  DateTime expiresOn;
  int quantity;
  String? thumbnail;

  Product({
    this.id,
    required this.name,
    this.barcode,
    required this.expiresOn,
    required this.quantity,
    this.thumbnail
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'expiresOn': formatter.format(expiresOn),
      'quantity': quantity,
      'thumbnail': thumbnail,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}