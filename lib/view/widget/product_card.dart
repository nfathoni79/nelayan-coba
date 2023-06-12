import 'package:flutter/material.dart';
import 'package:nelayan_coba/view/screen/product_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
  });

  final String name;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Text(name),
            ),
            Text(
              '$price IDR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                )
              ),
              child: Text('Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
