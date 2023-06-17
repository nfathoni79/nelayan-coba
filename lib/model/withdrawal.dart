class Withdrawal {
  const Withdrawal({
    required this.id,
    required this.createdAt,
    required this.expiredAt,
    required this.status,
    required this.paymentLink,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      expiredAt: DateTime.parse(json['expired_at']),
      status: json['status'],
      paymentLink: json['payment_link'],
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime expiredAt;
  final String status;
  final String paymentLink;
}