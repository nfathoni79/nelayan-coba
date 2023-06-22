import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/view/widget/transaction_card.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<SeaseedUser> _futureUser;
  late Future<List<Transaction>> _futureTransactions;

  @override
  void initState() {
    super.initState();
    _futureUser = FishonService.getSeaseedUser();
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
          child: FutureBuilder<List<dynamic>>(
            future: Future.wait([
              _futureUser,
              _futureTransactions,
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                SeaseedUser currentUser = snapshot.data![0] as SeaseedUser;
                List<Transaction> transactions =
                    snapshot.data![1] as List<Transaction>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: transactions
                      .map((trx) => TransactionCard(
                            date: trx.createdAt,
                            type: trx.type,
                            amount: trx.amount,
                            fromUser: trx.fromUser,
                            toUser: trx.toUser,
                            currentUser: currentUser,
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
