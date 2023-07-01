import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/product.dart';
import 'package:nelayan_coba/util/my_utils.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Detail Produk'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.product.name),
                    Text(
                      '${MyUtils.formatNumber(widget.product.price)} IDR',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue.shade50,
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: const Row(
                        children: [
                          Icon(Icons.store),
                          SizedBox(width: 8),
                          Text('Perindo Coba'),
                        ],
                      ),
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Deskripsi Produk',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(widget.product.description),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onPressedAddButton(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                elevation: 2,
              ),
              child: const Text('+ Keranjang'),
            ),
          ],
        ),
      ),
    );
  }

  Future _showCartSuccessDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sukses'),
        content: const Text('Berhasil ditambahkan ke keranjang.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void Function()? _onPressedAddButton() {
    return () async {
      List<CartProduct> cartProductList =
          await MyUtils.getFutureCartFromPrefs();

      int index = cartProductList.indexWhere((item) {
        return item.product.id == widget.product.id;
      });

      if (index < 0) {
        cartProductList.add(CartProduct(
          id: widget.product.id,
          product: widget.product,
          quantity: 1,
        ));
      } else {
        cartProductList[index].quantity++;
      }

      await MyUtils.saveCartToPrefs(cartProductList);

      _showCartSuccessDialog();
    };
  }
}
