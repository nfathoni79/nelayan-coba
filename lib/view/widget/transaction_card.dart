import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/util/my_utils.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.date,
    required this.type,
    required this.amount,
    this.toUser,
  });

  final DateTime date;
  final int type;
  final int amount;
  final SeaseedUser? toUser;

  @override
  Widget build(BuildContext context) {
    String typeText = '';
    String signedAmount = '';

    switch (type) {
      case 0:
        typeText = 'Setor';
        signedAmount = '+${MyUtils.formatNumber(amount)}';
        break;
      case 1:
        typeText = 'Tarik';
        signedAmount = MyUtils.formatNumber(amount * -1);
        break;
      case 2:
        typeText = 'Kirim';
        signedAmount = MyUtils.formatNumber(amount * -1);
        break;
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(DateFormat.yMMMd('id_ID').format(date)),
                Expanded(
                  child: Text(
                    typeText,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Divider(),
            toUser != null ? Text(toUser!.userFullName) : const SizedBox.shrink(),
            Text(
              '$signedAmount IDR',
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
