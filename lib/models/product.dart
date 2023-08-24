class Product {
  String barCode;
  String name; 
  DateTime expiresOn;
  int quantity;

  Product(this.name, this.barCode, this.expiresOn, this.quantity);

  Map<String, dynamic> toMap () {
    return {
      'name': name,
      'barcode': barCode,
      'expiresOn': expiresOn.toIso8601String(),
      'quantity': quantity,
    };
  }

  String toString() {
    return this.toMap().toString();
  }
}