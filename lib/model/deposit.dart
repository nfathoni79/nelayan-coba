import 'dart:core';

class Deposit {
  const Deposit({
    required this.id,
    required this.createdAt,
    required this.expiredAt,
    required this.status,
    required this.ref,
    required this.paymentLink,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      expiredAt: DateTime.parse(json['expired_at']),
      status: json['status'],
      ref: json['ref'],
      paymentLink: json['payment_link'],
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime expiredAt;
  final String status;
  final String ref;
  final String paymentLink;
}
