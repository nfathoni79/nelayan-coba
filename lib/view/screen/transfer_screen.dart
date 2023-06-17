import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/wallet.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _walletId = 1;
  final List<Wallet> _walletList = MartRepo.walletList;

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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Saldo Anda'),
                        Text('1.635.500 IDR'),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Layanan'),
                        Text('1.000 IDR'),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    MyDropdown<Wallet>(
                      items: _walletList,
                      itemAsString: (wallet) => wallet.user,
                      compareFn: (a, b) => a.id == b.id,
                      labelText: 'Wallet Tujuan',
                      prefixIcon: const Icon(Icons.wallet),
                      selectedItem: _walletList[_walletId - 1],
                      onChanged: (wallet) => {
                        if (wallet is Wallet)
                          {setState(() => _walletId = wallet.id)}
                      },
                    ),
                    const SizedBox(height: 16),
                    const MyTextFormField(
                      labelText: 'Nominal Kirim',
                      suffixText: 'IDR',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      useLoginStyle: false,
                    ),
                    const SizedBox(height: 16),
                    const MyTextFormField(
                      labelText: 'Keterangan (opsional)',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      useLoginStyle: false,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
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

  Widget _buildWalletDropdown() {
    return DropdownSearch<Wallet>(
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
          ),
        ),
        itemBuilder: (context, wallet, isSelected) => Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(wallet.user),
              Text(wallet.id.toString()),
            ],
          ),
        ),
      ),
      // items: ['Brazil', 'Italia (Disabled)', 'Tunisia', 'Canada'],
      items: _walletList,
      itemAsString: (w) => w.user,
      compareFn: (a, b) => a.id == b.id,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.wallet),
          labelText: 'Wallet Tujuan',
        ),
      ),
      onChanged: (w) => debugPrint('debug: $w'),
      selectedItem: _walletList[0],
    );
  }
}
