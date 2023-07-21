import 'package:nelayan_coba/model/mart.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.mart,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['item_id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['unit_price']).floor(),
    );
  }

  factory Product.fromPrefJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  factory Product.fromHistoryJson(Map<String, dynamic> json) {
    return Product(
      id: json['item_id'],
      name: json['name'],
      price: json['price'].floor(),
    );
  }

  final int id;
  final String name;
  final String description;
  final int price;
  final Mart? mart;
}
