import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/util/my_utils.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    required this.currentUser,
  });

  final Transaction transaction;
  final SeaseedUser currentUser;

  @override
  Widget build(BuildContext context) {
    String typeText = '';
    String signedAmount = '';
    String? transferDescription;

    switch (transaction.type) {
      case 0:
        typeText = 'Setor';
        signedAmount = '+${MyUtils.formatNumber(transaction.amount)}';
        break;
      case 1:
        typeText = 'Tarik';
        signedAmount = MyUtils.formatNumber(transaction.amount * -1);
        break;
      case 2:
        typeText = 'Kirim';

        if (transaction.fromUser.id == currentUser.id) {
          signedAmount = MyUtils.formatNumber(transaction.amount * -1);
          transferDescription = 'Ke ${transaction.toUser!.userFullName}';
          break;
        }

        signedAmount = '+${MyUtils.formatNumber(transaction.amount)}';
        transferDescription = 'Dari ${transaction.fromUser.userFullName}';
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
                Text(DateFormat.yMMMd('id_ID').format(transaction.createdAt)),
                Expanded(
                  child: Text(
                    typeText,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Divider(),
            transaction.remark.isEmpty
                ? const SizedBox.shrink()
                : Text(transaction.remark),
            transferDescription != null
                ? Text(transferDescription)
                : const SizedBox.shrink(),
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
