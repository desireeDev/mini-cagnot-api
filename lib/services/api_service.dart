import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // ======== SIGNUP ========
  static Future<void> signup(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (res.statusCode != 201) {
      throw Exception(_extractErrorMessage(res));
    }
  }

  // ======== LOGIN ========
  static Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final token = data['access_token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', token);
      return token;
    } else {
      throw Exception(_extractErrorMessage(res));
    }
  }

  // ======== FETCH CUSTOMER INFO ========
  static Future<Map<String, dynamic>> getCustomer(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    if (token == null) throw Exception('Utilisateur non connecté');

    final res = await http.get(
      Uri.parse('$baseUrl/customers/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception(_extractErrorMessage(res));
    }
  }

  // ======== CREATE PAYMENT ========
  static Future<Map<String, dynamic>> createPayment(
      int customerId, double amount, String merchant) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt');
    if (token == null) throw Exception('Utilisateur non connecté');

    final res = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'customerId': customerId,
        'amount': amount,
        'merchant': merchant,
      }),
    );

    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception(_extractErrorMessage(res));
    }
  }

  // ======== PRIVATE: EXTRAIT DU MESSAGE D'ERREUR NESTJS ========
  static String _extractErrorMessage(http.Response res) {
    try {
      final data = jsonDecode(res.body);

      // NestJS peut renvoyer "message" comme string ou liste
      if (data.containsKey('message')) {
        if (data['message'] is List) {
          return (data['message'] as List).join(', ');
        } else {
          return data['message'].toString();
        }
      } else if (data.containsKey('error')) {
        return data['error'].toString();
      } else {
        return 'Erreur serveur: ${res.statusCode}';
      }
    } catch (_) {
      return 'Erreur serveur: ${res.statusCode}';
    }
  }
}
