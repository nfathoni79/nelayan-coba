import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/view/widget/mart_dropdown.dart';
import 'package:nelayan_coba/view/widget/sell_history_card.dart';

class SellHistoryScreen extends StatefulWidget {
  const SellHistoryScreen({super.key});

  @override
  State<SellHistoryScreen> createState() => _SellHistoryScreenState();
}

class _SellHistoryScreenState extends State<SellHistoryScreen> {
  int _martId = 1;
  final List<Mart> _martList = MartRepo.martList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Riwayat Penjualan'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List<Widget>.generate(6, (index) => const SellHistoryCard()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}