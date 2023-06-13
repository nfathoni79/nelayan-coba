import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/view/widget/mart_dropdown.dart';
import 'package:nelayan_coba/view/widget/mart_history_card.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';

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
              items: _martList,
              itemAsString: (mart) => mart.name,
              compareFn: (a, b) => a.id == b.id,
              prefixIcon: const Icon(Icons.store),
              selectedItem: _martList[_martId - 1],
              onChanged: (mart) => {
                if (mart is Mart) {setState(() => _martId = mart.id)}
              },
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...List<Widget>.generate(
                        6, (index) => const MartHistoryCard()),
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
