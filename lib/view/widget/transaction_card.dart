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
    required this.fromUser,
    this.toUser,
    required this.currentUser,
  });

  final DateTime date;
  final int type;
  final int amount;
  final SeaseedUser fromUser;
  final SeaseedUser? toUser;
  final SeaseedUser currentUser;

  @override
  Widget build(BuildContext context) {
    String typeText = '';
    String signedAmount = '';
    String? transferDescription;

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

        if (fromUser.id == currentUser.id) {
          signedAmount = MyUtils.formatNumber(amount * -1);
          transferDescription = 'Ke ${toUser!.userFullName}';
          break;
        }

        signedAmount = '+${MyUtils.formatNumber(amount)}';
        transferDescription = 'Dari ${fromUser.userFullName}';
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
            transferDescription != null ? Text(transferDescription) : const SizedBox.shrink(),
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
