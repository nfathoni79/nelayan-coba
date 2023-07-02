class Fish {
  const Fish({
    required this.id,
    required this.name,
    this.price = 0,
  });

  final int id;
  final String name;
  final int price;
}