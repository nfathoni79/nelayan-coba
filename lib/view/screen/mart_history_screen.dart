import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/view/widget/mart_dropdown.dart';
import 'package:nelayan_coba/view/widget/mart_history_card.dart';

class MartHistoryScreen extends StatefulWidget {
  const MartHistoryScreen({super.key});

  @override
  State<MartHistoryScreen> createState() => _MartHistoryScreenState();
}

class _MartHistoryScreenState extends State<MartHistoryScreen> {
  int _martId = 1;
  final List<Mart> _martList = MartRepo.martList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Riwayat Belanja'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
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
                    ...List<Widget>.generate(6, (index) => const MartHistoryCard()),
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
