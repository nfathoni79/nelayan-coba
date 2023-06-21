import 'package:flutter/material.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Setor'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      child: MyTextFormField(
                        controller: _amountController,
                        labelText: 'Nominal Setor',
                        suffixText: 'IDR',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        useLoginStyle: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi nominal penyetoran';
                          }

                          if (int.parse(value) <= 1000) {
                            return 'Nominal harus lebih dari biaya layanan';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya layanan'),
                        Text('1.000 IDR'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;

                _deposit(context, int.parse(_amountController.text));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                elevation: 2,
              ),
              child: const Text('Setor'),
            ),
          ],
        ),
      ),
    );
  }

  void _deposit(BuildContext context, int amount) {
    MyUtils.showLoading(context);

    FishonService.createDeposit(amount).then((value) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Menunggu Pembayaran'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Lakukan pembayaran pada tautan berikut:'),
              InkWell(
                onTap: () async =>
                    await launchUrl(Uri.parse(value.paymentLink)),
                child: Text(
                  value.paymentLink,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Saya sudah melakukan pembayaran'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }).catchError((error) {
      Navigator.pop(context);
      debugPrint('deposit error');
      debugPrint(error.toString());
    });
  }
}
