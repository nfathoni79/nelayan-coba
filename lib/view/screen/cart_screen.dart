import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/widget/cart_product_card.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _martId = 1;
  final List<Mart> _martList = MartRepo.martList;
  final List<CartProduct> _cartProductList = MartRepo.cartProductList;
  int? _shipping = 0;
  int _totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Keranjang'),
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
                    MyDropdown<Mart>(
                      items: _martList,
                      itemAsString: (mart) => mart.name,
                      compareFn: (a, b) => a.id == b.id,
                      prefixIcon: const Icon(Icons.store),
                      selectedItem: _martList[_martId - 1],
                      onChanged: (mart) => {
                        if (mart is Mart) {
                          setState(() => _martId = mart.id)
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildCartProductList(),
                    const Divider(),
                    const Text(
                      'Pengiriman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: _shipping,
                          onChanged: (value) =>
                              setState(() => _shipping = value),
                        ),
                        const Expanded(
                          child: Text('Ambil sendiri'),
                        ),
                        Radio<int>(
                          value: 1,
                          groupValue: _shipping,
                          onChanged: (value) =>
                              setState(() => _shipping = value),
                        ),
                        const Expanded(
                          child: Text('Dikirim'),
                        ),
                      ],
                    ),
                    _shipping == 1
                        ? const SizedBox(height: 8)
                        : const SizedBox(height: 0),
                    Visibility(
                      visible: _shipping == 1,
                      maintainState: true,
                      child: const MyTextFormField(
                        labelText: 'Alamat pengiriman',
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        textInputAction: TextInputAction.done,
                        useLoginStyle: false,
                      ),
                    ),
                    const Divider(),
                    const Text(
                      'Ringkasan Belanja',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Text('Total Harga'),
                        Expanded(
                          child: Text(
                            '${MyUtils.formatNumber(_totalPrice)} IDR',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text('Biaya Layanan'),
                        Expanded(
                          child: Text(
                            '1.000 IDR',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Total Tagihan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${MyUtils.formatNumber(_totalPrice + 1000)} IDR',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    const MyTextFormField(
                      labelText: 'PIN Pembayaran',
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textInputAction: TextInputAction.done,
                      useLoginStyle: false,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sukses'),
                  content: const Text(
                      'Pembayaran berhasil. Barang akan dikirimkan ke alamat Anda.'),
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
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                elevation: 2,
              ),
              child: const Text('Bayar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartProductList() {
    List<Widget> cartProductWidgetList = [];
    _totalPrice = 0;

    for (int i = 0; i < _cartProductList.length; i++) {
      cartProductWidgetList.add(CartProductCard(
        cartProduct: _cartProductList[i],
        onPlus: () => setState(() => _cartProductList[i].quantity++),
        onMinus: () {
          if (_cartProductList[i].quantity > 1) {
            setState(() {
              _cartProductList[i].quantity--;
            });
          } else if (_cartProductList[i].quantity <= 1) {
            setState(() => _cartProductList.removeAt(i));
          }
        },
        onRemove: () => setState(() => _cartProductList.removeAt(i)),
      ));

      _totalPrice +=
          _cartProductList[i].quantity * _cartProductList[i].product.price;
    }

    return Column(
      children: cartProductWidgetList,
    );
  }
}
