// TODO Implement this library.
import 'customer.dart';

class Payment {
  final int id;
  final double amount;
  final String merchant;
  final int customerId;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.customerId,
    required this.createdAt,
  });

  // Factory pour créer un Payment depuis JSON
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      merchant: json['merchant'],
      customerId: json['customerId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Convertir un Payment en JSON (utile pour l'envoi à l'API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'merchant': merchant,
      'customerId': customerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
