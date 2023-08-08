import 'package:flutter/material.dart';
import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/deposit.dart';
import 'package:nelayan_coba/service/prefs_service.dart';
import 'package:nelayan_coba/service/seaseed_service.dart';
import 'package:stacked/stacked.dart';

class DepositViewModel extends BaseViewModel {
  static const String createDepositKey = 'createDeposit';
  static const String getLastDepositKey = 'getLastDeposit';

  final _seaseed = locator<SeaseedService>();
  final _prefs = locator<PrefsService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  Deposit? deposit;
  Deposit? lastDeposit;

  Future<Deposit?> createDeposit() async {
    setBusyForObject(createDepositKey, true);
    int amount = int.parse(amountController.text);

    deposit = await _seaseed.createDeposit(amount);
    setBusyForObject(createDepositKey, false);
    return deposit;
  }

  Future setLastDepositUuid(String uuid) async {
    return _prefs.setLastDepositUuid(uuid);
  }

  Future<Deposit?> getLastDeposit() async {
    setBusyForObject(getLastDepositKey, true);
    String? depositUuid = await _prefs.getLastDepositUuid();

    if (depositUuid != null) {
      lastDeposit = await _seaseed.getDeposit(depositUuid);
    }

    setBusyForObject(getLastDepositKey, false);
    return lastDeposit;
  }
}