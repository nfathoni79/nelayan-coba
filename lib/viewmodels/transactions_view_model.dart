import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/service/seaseed_service.dart';
import 'package:stacked/stacked.dart';

class TransactionsViewModel extends MultipleFutureViewModel {
  static const String userKey = 'user';
  static const String trxKey = 'transactions';

  final _seaseed = locator<SeaseedService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    userKey: getSeaseedUser,
    trxKey: getTransactions,
  };

  bool get userBusy => busy(userKey);
  bool get trxBusy => busy(trxKey);

  SeaseedUser get seaseedUser => dataMap?[userKey];
  List<Transaction> get transactions => dataMap?[trxKey];

  Future<SeaseedUser?> getSeaseedUser() {
    return _seaseed.getCurrentSeaseedUser();
  }

  Future<List<Transaction>> getTransactions() {
    return _seaseed.getTransactions();
  }
}