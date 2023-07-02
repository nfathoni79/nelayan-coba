import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/seaseed_user.dart';
import 'package:nelayan_coba/model/sell_fish.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/screen/sell_history_screen.dart';
import 'package:nelayan_coba/view/widget/my_dropdown.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  int _martId = 1;
  int _fishId = 1;
  final List<Mart> _martList = MartRepo.martList;
  final List<Fish> _fishList = MartRepo.fishList;
  final List<SellFish> _sellFishList = [];

  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Jual Ikan'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const SellHistoryScreen(),
            )),
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat',
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyDropdown<Mart>(
              items: _martList,
              itemAsString: (mart) => mart.name,
              compareFn: (a, b) => a.id == b.id,
              prefixIcon: const Icon(Icons.store),
              selectedItem: _martList[_martId - 1],
              disabledItemFn: (mart) => mart.name != 'Perindo Coba',
              onChanged: (mart) => {
                if (mart is Mart) {setState(() => _martId = mart.id)}
              },
            ),
            const SizedBox(height: 8),
            MyDropdown<Fish>(
              items: _fishList,
              itemAsString: (mart) => mart.name,
              compareFn: (a, b) => a.id == b.id,
              prefixIcon: const Icon(Icons.set_meal),
              selectedItem: _fishList[_fishId - 1],
              onChanged: (fish) => {
                if (fish is Fish) {setState(() => _fishId = fish.id)}
              },
            ),
            const SizedBox(height: 8),
            MyTextFormField(
              controller: _quantityController,
              prefixIcon: const Icon(Icons.scale),
              suffixText: 'Kg',
              hintText: 'Jumlah',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              useLoginStyle: false,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (double.tryParse(_quantityController.text) == null) return;

                  SellFish? sellFish = _getSellFishByFishId(_fishId);

                  if (sellFish != null) {
                    sellFish.quantity += double.parse(_quantityController.text);
                  } else {
                    _sellFishList.add(SellFish(
                      id: _sellFishList.length + 1,
                      fish: _fishList[_fishId - 1],
                      quantity: double.parse(_quantityController.text),
                    ));
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.green.shade50,
                elevation: 2,
              ),
              child: const Text('Tambah'),
            ),
            // const SizedBox(height: 8),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [..._buildSellFishCardList()],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _sellFishList.clear()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.red.shade50,
                      elevation: 2,
                    ),
                    child: const Text('Kosongkan'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _onPressedSellButton(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.blue.shade50,
                      elevation: 2,
                    ),
                    child: const Text('Jual'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSellFishCardList() {
    return _sellFishList
        .map((e) => Card(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(e.fish.name),
                    ),
                    Text('${e.quantity.toStringAsFixed(2)} Kg'),
                  ],
                ),
              ),
            ))
        .toList();
  }

  SellFish? _getSellFishByFishId(int fishId) {
    return _sellFishList.cast<SellFish?>().firstWhere(
        (sellFish) => sellFish?.fish.id == fishId,
        orElse: () => null);
  }

  Future _showSuccessSellDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sukses'),
        content: const Text(
            'Penjualan berhasil. Cek status penjualan Anda di Riwayat Penjualan.'),
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
  }

  Future _showFailedSellDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gagal'),
        content: const Text('Penjualan gagal.'),
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
  }

  int _calculateSellFishTotalPrice() {
    int totalPrice = 0;

    for (var sellFish in _sellFishList) {
      totalPrice += (sellFish.fish.price * sellFish.quantity).ceil();
    }

    return totalPrice;
  }

  void Function()? _onPressedSellButton() {
    return _sellFishList.isEmpty
        ? null
        : () async {
            MyUtils.showLoading(context);
            int totalPrice = _calculateSellFishTotalPrice();

            try {
              SeaseedUser user = await FishonService.getSeaseedUser();
              await FishonService.createTransfer(user.userUuid, totalPrice,
                  'Jual ikan', MartRepo.pabrikCobaUserUuid);
            } catch (e) {
              Navigator.pop(context);
              _showFailedSellDialog();
              return;
            }

            if (mounted) Navigator.pop(context);

            setState(() => _sellFishList.clear());
            _showSuccessSellDialog();
          };
  }
}
