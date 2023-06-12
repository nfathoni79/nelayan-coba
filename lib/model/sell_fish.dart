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
}