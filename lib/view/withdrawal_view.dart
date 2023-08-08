import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/bank.dart';
import 'package:nelayan_coba/model/withdrawal.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/widget/my_button.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';
import 'package:nelayan_coba/viewmodels/withdrawal_view_model.dart';
import 'package:stacked/stacked.dart';

class WithdrawalView extends StackedView<WithdrawalViewModel> {
  const WithdrawalView({super.key});

  @override
  Widget builder(
      BuildContext context, WithdrawalViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Tarik'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildForm(context, viewModel),
                      const SizedBox(height: 8),
                      const Divider(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Biaya layanan'),
                          Text('0 IDR'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              MyButton(
                text: 'Cek Status Terakhir',
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.grey.shade800,
                onPressed: () => _onPressedStatus(context, viewModel),
              ),
              MyButton(
                text: 'Tarik',
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                onPressed: () => _onPressedWithdraw(context, viewModel),
              ),
            ],
          ),
        ));
  }

  @override
  WithdrawalViewModel viewModelBuilder(BuildContext context) =>
      WithdrawalViewModel();

  Widget _buildForm(BuildContext context, WithdrawalViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyTextFormField(
            controller: viewModel.amountController,
            labelText: 'Nominal Tarik',
            suffixText: 'IDR',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.accountNoController,
            labelText: 'Nomor Rekening',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyDropdown<Bank>(
            items: const [],
            asyncItems: (_) => viewModel.getBanks(),
            itemAsString: (bank) => bank.name,
            compareFn: (a, b) => a.id == b.id,
            labelText: 'Nama Bank',
            selectedItem: viewModel.bank,
            onChanged: (bank) {
              if (bank is Bank) {
                viewModel.bank = bank;
              }
            },
            validator: (value) => MyUtils.mustSelectValidator(value),
          ),
        ],
      ),
    );
  }

  void _onPressedWithdraw(
      BuildContext context, WithdrawalViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);

    try {
      Withdrawal? withdrawal = await viewModel.createWithdrawal();
      await viewModel.setLastWithdrawalUuid(withdrawal!.uuid);

      if (context.mounted) {
        Navigator.pop(context);
        MyUtils.showSuccessDialog(
          context,
          message: 'Penarikan sedang diproses.',
          doublePop: true,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }

  void _onPressedStatus(
      BuildContext context, WithdrawalViewModel viewModel) async {
    MyUtils.showLoading(context);

    try {
      Withdrawal? withdrawal = await viewModel.getLastWithdrawal();
      if (context.mounted) {
        Navigator.pop(context);

        if (withdrawal == null) {
          MyUtils.showErrorDialog(
            context,
            message: 'Tidak dapat memperoleh status penarikan terakhir Anda.',
          );
          return;
        }

        _showWithdrawalStatusDialog(context, withdrawal);
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }

  Future _showWithdrawalStatusDialog(
      BuildContext context, Withdrawal withdrawal) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Info'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Status penarikan terakhir Anda: ${withdrawal.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
