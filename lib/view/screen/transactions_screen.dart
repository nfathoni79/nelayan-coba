import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/view/widget/transaction_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<List<Transaction>> _futureTransactions;

  @override
  void initState() {
    super.initState();
    _futureTransactions = FishonService.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Riwayat Transaksi'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SingleChildScrollView(
          child: FutureBuilder<List<Transaction>>(
            future: _futureTransactions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: snapshot.data!
                      .map((trx) => TransactionCard(
                            date: trx.createdAt,
                            type: trx.type,
                            amount: trx.amount,
                            toUser: trx.toUser,
                          ))
                      .toList()
                      .reversed
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
