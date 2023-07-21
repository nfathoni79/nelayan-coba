import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart_history.dart';
import 'package:nelayan_coba/util/my_utils.dart';

class MartHistoryCard extends StatelessWidget {
  const MartHistoryCard({
    super.key,
    required this.history,
  });

  final MartHistory history;

  @override
  Widget build(BuildContext context) {
    String statusText = 'Diproses';

    if (history.status == 0) {
      statusText = 'Selesai';
    } else if (history.status <= -1) {
      statusText = 'Dibatalkan';
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
            ...history.productList.map((item) => Row(
              children: [
                Expanded(
                  child: Text(item.product.name),
                ),
                Text('x${item.quantity}'),
              ],
            )).toList(),
            Text(
              '${MyUtils.formatNumber(history.totalPrice)} IDR',
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
