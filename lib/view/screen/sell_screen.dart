import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/mart.dart';
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
  late Future<List<Mart>> _futureMarts;
  late Future<List<Fish>> _futureFishList;

  Mart? _currentMart;
  Fish? _currentFish;
  final List<SellFish> _sellFishList = [];

  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureMarts = _getMarts();
    _futureFishList = _getFishList();
  }

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
              items: const [],
              asyncItems: (_) => _futureMarts,
              itemAsString: (mart) => mart.name,
              compareFn: (a, b) => a.slug == b.slug,
              prefixIcon: const Icon(Icons.store),
              selectedItem: _currentMart,
              onChanged: (mart) {
                if (mart is Mart) {
                  setState(() {
                    _currentMart = mart;
                    _futureFishList = _getFishList();
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            MyDropdown<Fish>(
              items: const [],
              asyncItems: (_) => _futureFishList,
              itemAsString: (fish) => fish.name,
              compareFn: (a, b) => a.id == b.id,
              prefixIcon: const Icon(Icons.set_meal),
              selectedItem: _currentFish,
              onChanged: (fish) {
                if (fish is Fish) {
                  setState(() => _currentFish = fish);
                }
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
              onPressed: _onPressedAddButton(),
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
                      child: Text(
                          '${e.fish.name} (${MyUtils.formatNumber(e.fish.price)} IDR/Kg)'),
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

  void Function()? _onPressedAddButton() {
    if (_currentFish == null ||
        (_currentMart!.oneFish && _sellFishList.isNotEmpty)) {
      return null;
    }

    return () {
      if (double.tryParse(_quantityController.text) == null) return;

      SellFish? sellFish = _getSellFishByFishId(_currentFish!.id);

      if (sellFish != null) {
        setState(
            () => sellFish.quantity += double.parse(_quantityController.text));
      } else {
        setState(() => _sellFishList.add(SellFish(
              id: _currentFish!.id,
              fish: _currentFish!,
              quantity: double.parse(_quantityController.text),
            )));
      }
    };
  }

  void Function()? _onPressedSellButton() => _sellFishList.isEmpty
      ? null
      : () async {
          MyUtils.showLoading(context);

          try {
            await FishonService.sellFish(_currentMart!.slug, _sellFishList);
          } catch (e) {
            debugPrint('onPressedSellButton: $e');
            Navigator.pop(context);
            _showFailedSellDialog();
            return;
          }

          if (mounted) Navigator.pop(context);

          setState(() => _sellFishList.clear());
          _showSuccessSellDialog();
        };

  Future<List<Mart>> _getMarts() async {
    try {
      List<Mart> marts = await FishonService.getMarts();
      setState(() => _currentMart = marts[0]);

      return marts;
    } catch (e) {
      return [];
    }
  }

  Future<List<Fish>> _getFishList() async {
    _quantityController.clear();
    setState(() => _sellFishList.clear());

    if (_currentMart == null) {
      await _futureMarts;
    }

    List<Fish> fishList = await FishonService.getFishList(_currentMart!.slug);

    if (fishList.isNotEmpty) {
      setState(() => _currentFish = fishList[0]);
    } else {
      setState(() => _currentFish = null);
    }

    return fishList;
  }
}
