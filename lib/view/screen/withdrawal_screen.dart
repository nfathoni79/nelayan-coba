import 'package:flutter/material.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Tarik'),
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
                      child: Column(
                        children: [
                          MyTextFormField(
                            controller: _amountController,
                            labelText: 'Nominal Tarik',
                            suffixText: 'IDR',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            useLoginStyle: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi nominal penarikan';
                              }

                              if (int.parse(value) < 10000) {
                                return 'Nominal minimal 10.000';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextFormField(
                            controller: _emailController,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            useLoginStyle: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi email untuk pengiriman kode rahasia';
                              }

                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Minimal penarikan'),
                        Text('10.000 IDR'),
                      ],
                    ),
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

                _withdraw(context, int.parse(_amountController.text), _emailController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                elevation: 2,
              ),
              child: const Text('Tarik'),
            ),
          ],
        ),
      ),
    );
  }

  void _withdraw(BuildContext context, int amount, String email) {
    MyUtils.showLoading(context);

    FishonService.createWithdrawal(amount, email).then((value) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Menunggu Penarikan'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Lakukan penarikan pada tautan berikut:'),
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
              child: const Text('Saya sudah melakukan penarikan'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    }).catchError((error) {
      Navigator.pop(context);
      debugPrint('withdraw error');
      debugPrint(error.toString());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal'),
          content: const Text('Gagal melakukan penarikan. Pastikan saldo Anda cukup'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    });
  }
}