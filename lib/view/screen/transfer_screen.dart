import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/wallet.dart';
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Transfer'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Saldo Anda'),
                        Text('1650000 IDR'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Layanan'),
                        Text('1000 IDR'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildWalletDropdown(),
                    const SizedBox(height: 24),
                    MyTextFormField(
                      labelText: 'Nominal Transfer',
                      suffixText: 'IDR',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    MyTextFormField(
                      labelText: 'Keterangan (opsional)',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Transfer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.blue.shade50,
              ),
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
