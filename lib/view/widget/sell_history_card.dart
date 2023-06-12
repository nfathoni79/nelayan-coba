import 'package:flutter/material.dart';

class SellHistoryCard extends StatelessWidget {
  const SellHistoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('1 Juni 2023'),
                Expanded(
                  child: Text(
                    'Belum disetujui',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text('Cakalang'),
                ),
                Text('1.00 Kg'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Tuna'),
                ),
                Text('2.50 Kg'),
              ],
            ),
            Text(
              '0 IDR',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
