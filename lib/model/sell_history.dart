import 'package:nelayan_coba/model/fish.dart';
import 'package:nelayan_coba/model/sell_fish.dart';

class SellHistory {
  const SellHistory({
    required this.id,
    required this.lastBid,
    required this.fishList,
    required this.status,
    required this.createdAt,
  });

  factory SellHistory.fromJson(Map<String, dynamic> json) {
    String lastBidString = json['lastBidding'];
    double lastBid = lastBidString.isEmpty ? 0 : double.parse(lastBidString);

    List jsonFishList = json['ikan'];
    List<SellFish> fishList = jsonFishList
        .map((item) => SellFish(
              id: item['kindoffish'],
              fish: Fish.fromSellJson(item),
              quantity: item['fishamount'],
            ))
        .toList();

    DateTime createdAt = DateTime.parse(jsonFishList[0]['created_at']);

    return SellHistory(
      id: json['id'],
      lastBid: lastBid.floor(),
      fishList: fishList,
      status: json['is_approve'],
      createdAt: createdAt,
    );
  }

  final int id;
  final int lastBid;
  final List<SellFish> fishList;
  final int status;
  final DateTime createdAt;
}
