import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/widget/my_button.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';
import 'package:nelayan_coba/viewmodels/transfer_view_model.dart';
import 'package:stacked/stacked.dart';

class TransferView extends StackedView<TransferViewModel> {
  const TransferView({super.key});

  @override
  Widget builder(
      BuildContext context, TransferViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kirim'),
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
              text: 'Kirim',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.blue.shade50,
              onPressed: () => _onPressedTransfer(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  TransferViewModel viewModelBuilder(BuildContext context) =>
      TransferViewModel();

  Widget _buildForm(BuildContext context, TransferViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyDropdown<SeaseedUser>(
            items: const [],
            asyncItems: (_) => viewModel.getOtherSeaseedUsers(),
            itemAsString: (user) => user.userFullName,
            compareFn: (a, b) => a.id == b.id,
            labelText: 'Tujuan Kirim',
            selectedItem: viewModel.receiverUser,
            onChanged: (user) {
              if (user is SeaseedUser) {
                viewModel.receiverUser = user;
              }
            },
            validator: (value) => MyUtils.mustSelectValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.amountController,
            labelText: 'Nominal Kirim',
            suffixText: 'IDR',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            useLoginStyle: false,
            validator: (value) => MyUtils.noEmptyValidator(value),
          ),
        ],
      ),
    );
  }

  void _onPressedTransfer(
      BuildContext context, TransferViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);

    try {
      await viewModel.createTransfer();
      if (context.mounted) {
        Navigator.pop(context);
        MyUtils.showSuccessDialog(
          context,
          message: 'Berhasil melakukan pengiriman.',
          doublePop: true,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }
}