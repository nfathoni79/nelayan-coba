import 'package:flutter/material.dart';
import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/deposit.dart';
import 'package:nelayan_coba/service/seaseed_service.dart';
import 'package:stacked/stacked.dart';

class DepositViewModel extends BaseViewModel {
  static const String createDepositKey = 'createDeposit';

  final _seaseed = locator<SeaseedService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  Deposit? deposit;

  Future<Deposit?> createDeposit() async {
    setBusyForObject(createDepositKey, true);
    int amount = int.parse(amountController.text);

    deposit = await _seaseed.createDeposit(amount);
    setBusyForObject(createDepositKey, false);
    return deposit;
  }
}