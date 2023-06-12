import 'package:flutter/material.dart';
import 'package:nelayan_coba/util/my_strings.dart';
import 'package:nelayan_coba/view/screen/cart_screen.dart';
import 'package:nelayan_coba/view/screen/mart_screen.dart';
import 'package:nelayan_coba/view/screen/profile_screen.dart';
import 'package:nelayan_coba/view/screen/sell_screen.dart';
import 'package:nelayan_coba/view/screen/transfer_screen.dart';
import 'package:nelayan_coba/view/widget/menu_button.dart';
import 'package:nelayan_coba/view/widget/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text(MyStrings.appName),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CartScreen(),
            )),
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Keranjang',
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            )),
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.75,
                  children: <Widget>[
                    MenuCard(
                      iconData: Icons.directions_boat,
                      title: 'Cari Ikan',
                      description: 'Cari ikan dengan bantuan radar kami',
                      onTap: () => _showUnavailableSnackbar(context),
                    ),
                    MenuCard(
                      iconData: Icons.book,
                      title: 'Lapor',
                      description: 'Lapor lokasi tempat memancing Anda',
                      onTap: () => _showUnavailableSnackbar(context),
                    ),
                    MenuCard(
                      iconData: Icons.shopping_bag,
                      title: 'Belanja',
                      description: 'Belanja kebutuhan berlayar Anda di sini',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MartScreen(),
                      )),
                    ),
                    MenuCard(
                      iconData: Icons.sell,
                      title: 'Jual Ikan',
                      description: 'Jual hasil tangkapan Anda di sini',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SellScreen(),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _showUnavailableSnackbar(context),
        tooltip: 'SOS',
        child: const Icon(Icons.sos),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showUnavailableSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Not available in this version'),
    ));
  }

  /// Build balance card containing balance info, deposit, transfer, scan to pay.
  Widget _buildBalanceCard() {
    return Card(
      // color: Colors.blue.shade800,
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saldo Wallet',
                    style: TextStyle(
                        // color: Colors.blue.shade50,
                        ),
                  ),
                  Text(
                    '1.635.500',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      // color: Colors.blue.shade50,
                    ),
                  ),
                ],
              ),
            ),
            MenuButton(
              iconData: Icons.add_circle_outline,
              title: 'Deposit',
              // color: Colors.blue.shade50,
              // splashColor: Colors.blue,
              onTap: () => _showUnavailableSnackbar(context),
            ),
            MenuButton(
              iconData: Icons.arrow_circle_right_outlined,
              title: 'Transfer',
              // color: Colors.blue.shade50,
              // splashColor: Colors.blue,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TransferScreen(),
              )),
            ),
            MenuButton(
              iconData: Icons.qr_code_scanner,
              title: 'Bayar',
              // color: Colors.blue.shade50,
              // splashColor: Colors.blue,
              onTap: () => _showUnavailableSnackbar(context),
            ),
          ],
        ),
      ),
    );
  }
}
