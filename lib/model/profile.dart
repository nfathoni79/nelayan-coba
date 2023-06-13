class Profile {
  const Profile({
    required this.phone,
    required this.name,
  });

  final String phone;
  final String name;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      phone: json['phone'],
      name: json['full_name'],
    );
  }
}