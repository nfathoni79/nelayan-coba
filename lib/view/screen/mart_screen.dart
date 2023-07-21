import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/product.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/view/screen/cart_screen.dart';
import 'package:nelayan_coba/view/screen/mart_history_screen.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';
import 'package:nelayan_coba/view/widget/product_card.dart';

class MartScreen extends StatefulWidget {
  const MartScreen({super.key});

  @override
  State<MartScreen> createState() => _MartScreenState();
}

class _MartScreenState extends State<MartScreen> {
  late Future<List<Mart>> _futureMarts;
  late Future<List<Product>> _futureProducts;
  Mart? _currentMart;

  @override
  void initState() {
    super.initState();
    _futureMarts = _getMarts();
    _futureProducts = _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Belanja'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MartHistoryScreen(),
            )),
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat',
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CartScreen(),
            )),
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Keranjang',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          children: [
            MyDropdown<Mart>(
              items: const [],
              asyncItems: (_) => _futureMarts,
              itemAsString: (mart) => mart.name,
              compareFn: (a, b) => a.slug == b.slug,
              prefixIcon: const Icon(Icons.store),
              selectedItem: _currentMart,
              onChanged: (mart) {
                if (mart is Mart) {
                  setState(() {
                    _currentMart = mart;
                    _futureProducts = _getProducts();
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            const MyTextFormField(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari barang',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              useLoginStyle: false,
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.25,
                      children: <Widget>[
                        ...snapshot.data!
                            .map((e) => ProductCard(
                          product: e,
                          mart: _currentMart!,
                        ))
                            .toList()
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Failed to get products');
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Mart>> _getMarts() async {
    try {
      List<Mart> marts = await FishonService.getMarts();
      setState(() {
        _currentMart = marts[0];
      });

      return marts;
    } catch (e) {
      return [];
    }
  }

  Future<List<Product>> _getProducts() async {
    if (_currentMart == null) {
      await _futureMarts;
    }

    return FishonService.getProductsByStore(_currentMart!.slug, '');
  }
}
