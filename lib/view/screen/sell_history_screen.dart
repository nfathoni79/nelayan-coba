import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/sell_history.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/sell_history_card.dart';

class SellHistoryScreen extends StatefulWidget {
  const SellHistoryScreen({super.key});

  @override
  State<SellHistoryScreen> createState() => _SellHistoryScreenState();
}

class _SellHistoryScreenState extends State<SellHistoryScreen> {
  late Future<List<Mart>> _futureMarts;
  late Future<List<SellHistory>> _futureHistoryList;

  Mart? _currentMart;

  @override
  void initState() {
    super.initState();
    _futureMarts = _getMarts();
    _futureHistoryList = _getSellHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Riwayat Penjualan'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    _futureHistoryList = _getSellHistoryList();
                  });
                }
              },
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<SellHistory>>(
                  future: _futureHistoryList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.isEmpty
                          ? const Center(child: Text('Belum ada penjualan'))
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...snapshot.data!.map((item) => SellHistoryCard(
                            history: item,
                          )),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Failed to get history: ${snapshot.error}');
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
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
      setState(() => _currentMart = marts[0]);

      return marts;
    } catch (e) {
      return [];
    }
  }

  Future<List<SellHistory>> _getSellHistoryList() async {
    if (_currentMart == null) {
      await _futureMarts;
    }

    return FishonService.getSellHistoryList(_currentMart!.slug);
  }
}
