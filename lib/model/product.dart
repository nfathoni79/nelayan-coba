class Product {
  const Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
  });

  final int id;
  final String name;
  final String description;
  final int price;
}
