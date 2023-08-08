import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/bank.dart';
import 'package:nelayan_coba/model/deposit.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/transaction.dart';
import 'package:nelayan_coba/model/withdrawal.dart';
import 'package:nelayan_coba/service/fishon_new_service.dart';

class SeaseedService {
  final _fishon = locator<FishonNewService>();

  SeaseedUser? _currentSeaseedUser;
  List<SeaseedUser> _otherSeaseedUsers = [];
  List<Bank> _banks = [];
  List<Transaction> _transactions = [];

  Future<SeaseedUser?> getCurrentSeaseedUser() async {
    _currentSeaseedUser = await _fishon.getCurrentSeaseedUser();
    return _currentSeaseedUser;
  }

  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    _otherSeaseedUsers = await _fishon.getOtherSeaseedUsers();
    return _otherSeaseedUsers;
  }

  Future<Deposit> createDeposit(int amount) async {
    return _fishon.createDeposit(amount);
  }

  Future<Deposit> getDeposit(String uuid) async {
    return _fishon.getDeposit(uuid);
  }

  Future<Withdrawal> createWithdrawal(
      int amount, String email, String accountNo, String bankCode) async {
    return _fishon.createWithdrawal(amount, email, accountNo, bankCode);
  }

  Future<Withdrawal> getWithdrawal(String uuid) async {
    return _fishon.getWithdrawal(uuid);
  }

  Future<List<Bank>> getBanks() async {
    _banks = await _fishon.getBanks();
    return _banks;
  }

  Future<bool> createTransfer(
      String toUserUuid, int amount, String remark) async {
    return _fishon.createTransfer(toUserUuid, amount, remark);
  }

  Future<List<Transaction>> getTransactions() async {
    _transactions = await _fishon.getTransactions();
    return _transactions;
  }
}