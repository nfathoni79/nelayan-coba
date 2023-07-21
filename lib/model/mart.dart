class Mart {
  const Mart({
    required this.id,
    required this.slug,
    required this.name,
    this.oneFish = false,
  });

  factory Mart.fromJson(Map<String, dynamic> json) {
    return Mart(
      id: json ['id'],
      slug: json['slug'],
      name: json['name'],
      oneFish: json['one_fish'],
    );
  }

  final int id;
  final String slug;
  final String name;
  final bool oneFish;
}