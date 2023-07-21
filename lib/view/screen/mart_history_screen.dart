import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_history.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/view/widget/mart_history_card.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';

class MartHistoryScreen extends StatefulWidget {
  const MartHistoryScreen({super.key});

  @override
  State<MartHistoryScreen> createState() => _MartHistoryScreenState();
}

class _MartHistoryScreenState extends State<MartHistoryScreen> {
  late Future<List<Mart>> _futureMarts;
  late Future<List<MartHistory>> _futureHistoryList;

  Mart? _currentMart;

  @override
  void initState() {
    super.initState();
    _futureMarts = _getMarts();
    _futureHistoryList = _getMartHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Riwayat Belanja'),
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
                    _futureHistoryList = _getMartHistoryList();
                  });
                }
              },
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<MartHistory>>(
                  future: _futureHistoryList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.isEmpty
                          ? const Center(child: Text('Belum ada pembelian'))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...snapshot.data!.map((item) => MartHistoryCard(
                                      history: item,
                                    )),
                              ],
                            );
                    } else if (snapshot.hasError) {
                      return const Text('Failed to get history');
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
      setState(() {
        _currentMart = marts[0];
      });

      return marts;
    } catch (e) {
      return [];
    }
  }

  Future<List<MartHistory>> _getMartHistoryList() async {
    if (_currentMart == null) {
      await _futureMarts;
    }

    return FishonService.getMartHistoryList(_currentMart!.slug);
  }
}
