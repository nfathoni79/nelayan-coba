import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/mart.dart';
import 'package:nelayan_coba/model/mart_repo.dart';
import 'package:nelayan_coba/model/sell_fish.dart';
import 'package:nelayan_coba/view/screen/sell_history_screen.dart';
import 'package:nelayan_coba/view/widget/fish_dropdown.dart';
import 'package:nelayan_coba/view/widget/mart_dropdown.dart';
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

  List<SellFish> _sellFishList = [];

  TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Jual Ikan'),
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
            MartDropdown(
              martList: _martList,
              currentMartId: _martId,
              onChanged: (value) {
                if (value is int) {
                  setState(() {
                    _martId = value;
                  });
                }
              },
            ),
            FishDropdown(
              fishList: _fishList,
              currentFishId: _fishId,
              onChanged: (value) {
                if (value is int) {
                  setState(() {
                    _fishId = value;
                    _quantityController.clear();
                  });
                }
              },
            ),
            Row(
              children: [
                const Icon(Icons.scale),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Jumlah',
                      suffixText: 'Kg',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
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
              child: Text('Tambah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.green.shade50,
              ),
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
                    child: Text('Kosongkan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.red.shade50,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sukses'),
                        content: Text('Penjualan berhasil. Cek status penjualan Anda di Riwayat Penjualan.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Tutup'),
                          ),
                        ],
                      ),
                      barrierDismissible: true,
                    ),
                    child: Text('Jual'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.blue.shade50,
                    ),
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

  bool _isSellFishAlreadyExisted(int fishId) {
    return _sellFishList
        .where((sellFish) => sellFish.fish.id == fishId)
        .isNotEmpty;
  }
}
