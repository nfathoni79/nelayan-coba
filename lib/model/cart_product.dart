import 'package:nelayan_coba/model/product.dart';

class CartProduct {
  CartProduct({
    required this.id,
    required this.product,
    this.quantity = 0,
  });

  final int id;
  final Product product;
  int quantity;
}
