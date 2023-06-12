import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/util/my_utils.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({
    super.key,
    required this.cartProduct,
    this.onPlus,
    this.onMinus,
    this.onRemove,
  });

  final CartProduct cartProduct;
  final Function()? onPlus;
  final Function()? onMinus;
  final Function()? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(cartProduct.product.name),
                ),
                IconButton(
                  onPressed: onRemove ?? () {},
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onMinus ?? () {},
                  icon: const Icon(Icons.remove_circle),
                ),
                Text('${cartProduct.quantity}'),
                IconButton(
                  onPressed: onPlus ?? () {},
                  icon: const Icon(Icons.add_circle),
                ),
                Expanded(
                  child: Text(
                    '${MyUtils.formatNumber(cartProduct.product.price * cartProduct.quantity)} IDR',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
