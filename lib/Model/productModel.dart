class Product {
  String name;
  String sku;
  double price;
  int quantity;

  Product({
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sku': sku,
        'price': price,
        'quantity': quantity,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json['name'],
        sku: json['sku'],
        price: json['price'],
        quantity: json['quantity'],
      );
}
