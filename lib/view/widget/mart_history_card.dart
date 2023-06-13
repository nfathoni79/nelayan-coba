import 'package:flutter/material.dart';

class MartHistoryCard extends StatelessWidget {
  const MartHistoryCard({
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
                    'Diproses',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Text('Indomie Rendang'),
                ),
                Text('x1'),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('ABC Coffee Milk'),
                ),
                Text('x2'),
              ],
            ),
            Text(
              '12.800 IDR',
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
