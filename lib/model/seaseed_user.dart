class SeaseedUser {
  const SeaseedUser({
    required this.id,
    required this.userUuid,
    required this.walletUuid,
    required this.balance,
  });

  factory SeaseedUser.fromJson(Map<String, dynamic> json) {
    return SeaseedUser(
      id: json['id'],
      userUuid: json['user_uuid'],
      walletUuid: json['wallet_uuid'],
      balance: json['balance'],
    );
  }

  final int id;
  final String userUuid;
  final String walletUuid;
  final int balance;
}
