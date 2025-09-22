import 'payment.dart';

/// Modèle représentant un client dans l'application.
/// Un client possède des informations personnelles (nom, email, mot de passe),
/// un solde de points de fidélité, et une liste de paiements effectués.
class Customer {
  /// Identifiant unique du client (généré par le backend).
  final int id;

  /// Nom complet du client.
  final String name;

  /// Adresse email du client (sert aussi d’identifiant de connexion).
  final String email;

  /// Mot de passe du client (⚠️ en vrai, ne devrait pas être exposé côté frontend).
  final String password;

  /// Nombre total de points de fidélité accumulés.
  final int points;

  /// Historique des paiements effectués par ce client.
  final List<Payment> payments;

  /// Constructeur de la classe Customer.
  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.points,
    required this.payments,
  });

  /// Factory permettant de créer un objet [Customer] à partir d’un JSON.
  /// Utilisé lors des appels API pour convertir la réponse du backend en objet Dart.
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'] ?? '', // Mot de passe facultatif (souvent absent dans la réponse API).
      points: json['points'] ?? 0,
      payments: json['payments'] != null
          ? List<Payment>.from(
              json['payments'].map((x) => Payment.fromJson(x)),
            )
          : [],
    );
  }

  /// Méthode qui convertit l’objet [Customer] en un JSON.
  /// Utile pour envoyer des données au backend (par exemple lors d’une inscription).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'points': points,
      'payments': payments.map((p) => p.toJson()).toList(),
    };
  }
}
