class Product {
  String barCode;
  String name; 
  DateTime expiresOn;
  int quantity;

  Product(this.barCode, this.name, this.expiresOn, this.quantity);

  Map<String, dynamic> toMap () {
    print(expiresOn.toIso8601String());
    return {
      'barCode': barCode,
      'name': name,
      'expiresOn': expiresOn.toIso8601String(),
      'quantity': quantity,
    };
  }

  String toString() {
    return this.toMap().toString();
  }
}