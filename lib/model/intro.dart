class Intro {
  Intro({
    required this.imageUrl,
    required this.title,
    this.description = '',
  });

  final String imageUrl;
  final String title;
  final String description;
}