import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/product.dart';
import 'package:nelayan_coba/view/screen/cart_screen.dart';
import 'package:nelayan_coba/view/screen/mart_history_screen.dart';
import 'package:nelayan_coba/view/widget/mart_dropdown.dart';
import 'package:nelayan_coba/view/widget/product_card.dart';

class MartScreen extends StatefulWidget {
  const MartScreen({super.key});

  @override
  State<MartScreen> createState() => _MartScreenState();
}

class _MartScreenState extends State<MartScreen> {
  int _martId = 1;
  final List<Mart> _martList = MartRepo.martList;
  final List<Product> _productList = MartRepo.productList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Belanja'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MartHistoryScreen(),
                )
            ),
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat',
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              )
            ),
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Keranjang',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: MartDropdown(
              martList: _martList,
              currentMartId: _martId,
              onChanged: (value) {
                if (value is int) {
                  setState(() => _martId = value);
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Cari barang',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: <Widget>[
                  ..._productList.map((e) => ProductCard(
                    name: e.name,
                    price: e.price,
                  )).toList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}