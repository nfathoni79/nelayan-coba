import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/sell_history.dart';
import 'package:nelayan_coba/util/my_utils.dart';

class SellHistoryCard extends StatelessWidget {
  const SellHistoryCard({
    super.key,
    required this.history,
  });

  final SellHistory history;

  @override
  Widget build(BuildContext context) {
    String statusText = 'Belum disetujui';

    if (history.status <= -1) {
      statusText = 'Ditolak';
    } else if (history.status == 1) {
      statusText = 'Proses lelang';
    } else if (history.status >= 2) {
      statusText = 'Selesai';
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(MyUtils.formatDate(history.createdAt)),
                Expanded(
                  child: Text(
                    statusText,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...history.fishList.map((item) => Row(
              children: [
                Expanded(
                  child: Text(item.fish.name),
                ),
                Text('${MyUtils.formatNumber(item.quantity)} Kg'),
              ],
            )).toList(),
            Text(
              '${MyUtils.formatNumber(history.lastBid)} IDR',
              style: const TextStyle(
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
