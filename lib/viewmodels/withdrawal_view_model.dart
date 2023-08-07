import 'package:flutter/material.dart';
import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/bank.dart';
import 'package:nelayan_coba/service/seaseed_service.dart';
import 'package:stacked/stacked.dart';

class WithdrawalViewModel extends BaseViewModel {
  static const String createWithdrawalKey = 'createWithdrawal';

  final _seaseed = locator<SeaseedService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final emailController = TextEditingController();
  final accountNoController = TextEditingController();
  Bank? bank;

  Future<List<Bank>> getBanks() async {
    return _seaseed.getBanks();
  }

  Future<bool> createWithdrawal() async {
    setBusyForObject(createWithdrawalKey, true);
    int amount = int.parse(amountController.text);
    String email = emailController.text;
    String accountNo = accountNoController.text;
    String bankCode = bank!.code;

    await _seaseed.createWithdrawal(amount, email, accountNo, bankCode);
    setBusyForObject(createWithdrawalKey, false);
    return true;
  }
}