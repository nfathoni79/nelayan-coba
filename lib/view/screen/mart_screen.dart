import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/product.dart';
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
  int _martId = 1;
  final List<Mart> _martList = MartRepo.martList;
  final List<Product> _productList = MartRepo.productList;

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
            const MyTextFormField(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari barang',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              useLoginStyle: false,
            ),
            const Divider(),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: <Widget>[
                  ..._productList
                      .map((e) => ProductCard(
                    name: e.name,
                    price: e.price,
                  ))
                      .toList()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
