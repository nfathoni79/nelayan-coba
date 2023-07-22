class Fish {
  const Fish({
    required this.id,
    required this.name,
    this.price = 0,
    this.maxPrice,
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']).floor(),
      maxPrice: double.parse(json['max_price']).floor(),
    );
  }

  factory Fish.fromSellJson(Map<String, dynamic> json) {
    return Fish(
      id: json['kindoffish'],
      name: json['ikan'],
    );
  }

  final int id;
  final String name;
  final int price;
  final int? maxPrice;
}
