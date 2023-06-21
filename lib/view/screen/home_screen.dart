import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_strings.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/screen/cart_screen.dart';
import 'package:nelayan_coba/view/screen/deposit_screen.dart';
import 'package:nelayan_coba/view/screen/mart_screen.dart';
import 'package:nelayan_coba/view/screen/profile_screen.dart';
import 'package:nelayan_coba/view/screen/sell_screen.dart';
import 'package:nelayan_coba/view/screen/transactions_screen.dart';
import 'package:nelayan_coba/view/screen/transfer_screen.dart';
import 'package:nelayan_coba/view/screen/withdrawal_screen.dart';
import 'package:nelayan_coba/view/widget/menu_button.dart';
import 'package:nelayan_coba/view/widget/menu_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<SeaseedUser> _futureSeaseedUser;

  @override
  void initState() {
    super.initState();
    _futureSeaseedUser = FishonService.getSeaseedUser();
  }

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
              child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Wallet',
              style: TextStyle(
                  // color: Colors.blue.shade50,
                  ),
            ),
            Row(
              children: [
                FutureBuilder<SeaseedUser>(
                  future: _futureSeaseedUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        MyUtils.formatNumber(snapshot.data!.balance),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color: Colors.blue.shade50,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        '-',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color: Colors.blue.shade50,
                        ),
                      );
                    }

                    return const CircularProgressIndicator();
                  },
                ),
                IconButton(
                  onPressed: () => _updateFutureSeaseedUser(),
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuButton(
                  iconData: Icons.add_circle_outline,
                  title: 'Setor',
                  color: Colors.blue.shade900,
                  // color: Colors.blue.shade50,
                  // splashColor: Colors.blue,
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => const DepositScreen(),
                      ))
                      .then((value) => _updateFutureSeaseedUser()),
                ),
                MenuButton(
                  iconData: Icons.arrow_circle_right_outlined,
                  title: 'Kirim',
                  color: Colors.blue.shade900,
                  // color: Colors.blue.shade50,
                  // splashColor: Colors.blue,
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => const TransferScreen(),
                      ))
                      .then((value) => _updateFutureSeaseedUser()),
                ),
                MenuButton(
                  iconData: Icons.arrow_circle_down_outlined,
                  title: 'Tarik',
                  color: Colors.blue.shade900,
                  // color: Colors.blue.shade50,
                  // splashColor: Colors.blue,
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => const WithdrawalScreen(),
                      ))
                      .then((value) => _updateFutureSeaseedUser()),
                ),
                MenuButton(
                  iconData: Icons.qr_code_scanner,
                  title: 'Bayar',
                  color: Colors.blue.shade900,
                  // color: Colors.blue.shade50,
                  // splashColor: Colors.blue,
                  onTap: () => _showUnavailableSnackbar(context),
                ),
                MenuButton(
                  iconData: Icons.history,
                  title: 'Riwayat',
                  color: Colors.blue.shade900,
                  // color: Colors.blue.shade50,
                  // splashColor: Colors.blue,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TransactionsScreen(),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateFutureSeaseedUser() {
    setState(() {
      _futureSeaseedUser = FishonService.getSeaseedUser();
    });
  }
}
