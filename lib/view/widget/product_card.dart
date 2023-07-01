import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/product.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/screen/product_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(product.name),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                '${MyUtils.formatNumber(product.price)} IDR',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductScreen(product: product),
              )),
              child: const Text('Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
