import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _toUserUuid;
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Kirim'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyDropdown<SeaseedUser>(
                            items: const [],
                            asyncItems: (filter) => _getOtherSeaseedUsers(),
                            itemAsString: (user) => user.userFullName,
                            labelText: 'Wallet Tujuan',
                            prefixIcon: const Icon(Icons.wallet),
                            onChanged: (user) => {
                              if (user is SeaseedUser)
                                {setState(() => _toUserUuid = user.userUuid)}
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Pilih wallet tujuan';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextFormField(
                            controller: _amountController,
                            labelText: 'Nominal Kirim',
                            suffixText: 'IDR',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            useLoginStyle: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Isi nominal kirim';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Layanan'),
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

                _transfer(context, _toUserUuid!, int.parse(_amountController.text));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
                elevation: 2,
              ),
              child: const Text('Kirim'),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<SeaseedUser>> _getOtherSeaseedUsers() async {
    return FishonService.getOtherSeaseedUsers();
  }

  void _transfer(BuildContext context, String toUserUuid, int amount) {
    MyUtils.showLoading(context);

    FishonService.createTransfer(toUserUuid, amount).then((value) {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Berhasil melakukan pengiriman.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    }).catchError((error) {
      Navigator.pop(context);
      debugPrint('transfer error');
      debugPrint(error.toString());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal'),
          content: const Text('Gagal melakukan pengiriman. Pastikan saldo Anda cukup'),
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
