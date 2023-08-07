import 'package:flutter/material.dart';
import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/service/seaseed_service.dart';
import 'package:stacked/stacked.dart';

class TransferViewModel extends BaseViewModel {
  static const String createTransferKey = 'createTransfer';

  final _seaseed = locator<SeaseedService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  SeaseedUser? receiverUser;

  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    return _seaseed.getOtherSeaseedUsers();
  }

  Future<bool> createTransfer() async {
    setBusyForObject(createTransferKey, true);
    int amount = int.parse(amountController.text);
    String toUserUuid = receiverUser!.userUuid;

    await _seaseed.createTransfer(toUserUuid, amount, '');
    setBusyForObject(createTransferKey, false);
    return true;
  }
}