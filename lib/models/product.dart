import 'package:intl/intl.dart';

class Product {

  final int? id;
  String label;
  String? barcode;
  DateTime addedOn;
  DateTime expiresOn;
  int quantity;
  String? description;
  String? thumbnail;

  Product({
    this.id,
    required this.label,
    this.barcode,
    required this.expiresOn,
    required this.addedOn,
    required this.quantity,
    this.description,
    this.thumbnail
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'barcode': barcode,
      'addedOn': DateFormat('yyyy-MM-dd').format(addedOn),
      'expiresOn': DateFormat('yyyy-MM-dd').format(expiresOn),
      'quantity': quantity,
      'description': description,
      'thumbnail': thumbnail,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}