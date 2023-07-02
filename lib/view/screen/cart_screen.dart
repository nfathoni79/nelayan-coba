import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/cart_product.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
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
  late Future<List<CartProduct>> _futureCartProductList;

  int _martId = 1;
  final List<Mart> _martList = MartRepo.martList;
  List<CartProduct> _cartProductList = [];
  int? _shipping = 0;
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _futureCartProductList = MyUtils.getFutureCartFromPrefs();

    _futureCartProductList.then((value) {
      _cartProductList = value;
    });
  }

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
                      disabledItemFn: (mart) => mart.name != 'Perindo Coba',
                      onChanged: (mart) => {
                        if (mart is Mart) {setState(() => _martId = mart.id)}
                      },
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<CartProduct>>(
                      future: _futureCartProductList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return _buildCartProductList();
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        return const CircularProgressIndicator();
                      },
                    ),
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
                          child: FutureBuilder<List<CartProduct>>(
                            future: _futureCartProductList,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${MyUtils.formatNumber(_totalPrice)} IDR',
                                  textAlign: TextAlign.right,
                                );
                              }

                              return const Text(
                                '0 IDR',
                                textAlign: TextAlign.right,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text('Biaya Layanan'),
                        Expanded(
                          child: Text(
                            '0 IDR',
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
                          child: FutureBuilder<List<CartProduct>>(
                            future: _futureCartProductList,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  '${MyUtils.formatNumber(_totalPrice)} IDR',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                );
                              }

                              return const Text(
                                '0 IDR',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              );
                            },
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
            FutureBuilder<List<CartProduct>>(
              future: _futureCartProductList,
              builder: (context, snapshot) {
                ButtonStyle? buttonStyle;

                if (snapshot.hasData) {
                  buttonStyle = ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.blue.shade50,
                    elevation: 2,
                  );
                }

                return ElevatedButton(
                  onPressed: _onPressedPayButton(),
                  style: buttonStyle,
                  child: const Text('Bayar'),
                );
              },
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
        onPlus: () async {
          setState(() => _cartProductList[i].quantity++);
          await MyUtils.saveCartToPrefs(_cartProductList);
        },
        onMinus: () async {
          if (_cartProductList[i].quantity > 1) {
            setState(() => _cartProductList[i].quantity--);
          } else if (_cartProductList[i].quantity <= 1) {
            setState(() => _cartProductList.removeAt(i));
          }

          await MyUtils.saveCartToPrefs(_cartProductList);
        },
        onRemove: () async {
          setState(() => _cartProductList.removeAt(i));
          await MyUtils.saveCartToPrefs(_cartProductList);
        },
      ));

      _totalPrice +=
          _cartProductList[i].quantity * _cartProductList[i].product.price;
    }

    return Column(
      children: cartProductWidgetList,
    );
  }

  Future _showPaymentSuccessDialog() {
    return showDialog(
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
    );
  }

  Future _showPaymentFailedDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gagal'),
        content: const Text('Pembayaran gagal. Pastikan saldo Anda cukup.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void Function()? _onPressedPayButton() {
    return _cartProductList.isEmpty
        ? null
        : () async {
            MyUtils.showLoading(context);

            try {
              await FishonService.createTransfer(
                  MartRepo.geraiCobaUserUuid, _totalPrice, 'Belanja', null);
            } catch (e) {
              Navigator.pop(context);
              _showPaymentFailedDialog();
              return;
            }

            if (mounted) Navigator.pop(context);

            await MyUtils.clearCartFromPrefs();
            _showPaymentSuccessDialog();
          };
  }
}
