import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/product.dart';

class CartProduct {
  CartProduct({
    required this.id,
    required this.product,
    this.quantity = 0,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'],
      product: MartRepo.productList[json['id'] - 1],
      quantity: json['quantity'],
    );
  }

  final int id;
  final Product product;
  int quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': product.id,
      'quantity': quantity,
    };
  }
}
