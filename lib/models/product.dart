class Product {
  String barCode;
  String name; 
  DateTime expiresOn;
  int quantity;

  Product(this.barCode, this.name, this.expiresOn, this.quantity);

  Map<String, dynamic> toMap () {
    return {
      'barCode': barCode,
      'name': name,
      'expiresOn': expiresOn,
      'quantity': quantity,
    };
  }

  String toString() {
    return this.toMap().toString();
  }
}