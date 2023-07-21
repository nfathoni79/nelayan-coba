import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/product.dart';

class MartHistory {
  const MartHistory({
    required this.id,
    required this.invoice,
    required this.totalPrice,
    required this.productList,
    required this.status,
    required this.createdAt,
  });

  factory MartHistory.fromJson(Map<String, dynamic> json) {
    List jsonProduct = json['items'];
    List<CartProduct> productList = jsonProduct
        .map((item) => CartProduct(
              id: item['item_id'],
              product: Product.fromHistoryJson(item),
              quantity: item['quantity'],
            ))
        .toList();

    debugPrint('productList: $productList');

    return MartHistory(
      id: json['sale_id'],
      invoice: json['invoice_number'],
      totalPrice: json['total_price'].floor(),
      productList: productList,
      status: json['is_dilivery'],
      createdAt: DateTime.parse(json['sale_time']),
    );
  }

  final int id;
  final String invoice;
  final int totalPrice;
  final List<CartProduct> productList;
  final int status;
  final DateTime createdAt;
}
