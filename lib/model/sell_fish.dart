import 'package:nelayan_coba/model/fish.dart';

class SellFish {
  SellFish({
    required this.id,
    required this.fish,
    this.quantity = 1,
  });

  final int id;
  final Fish fish;
  double quantity;

  Map<String, dynamic> toSellJson() {
    return {
      'jenis_ikan_id': id,
      'jenis_ikan_name': fish.name,
      'amountOfFish': quantity,
    };
  }
}