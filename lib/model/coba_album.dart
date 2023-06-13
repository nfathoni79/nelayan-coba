class CobaAlbum {
  final int userId;
  final int id;
  final String title;

  const CobaAlbum({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory CobaAlbum.fromJson(Map<String, dynamic> json) {
    return CobaAlbum(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
