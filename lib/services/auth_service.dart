import 'dart:convert';

import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<User> login(String email, String password) async {
    final response = await _apiService.client.post(
      Uri.parse('${_apiService._baseUrl}/auth/login'),
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    await _apiService.client.post(
      Uri.parse('${_apiService._baseUrl}/auth/logout'),
    );
  }
}

extension on ApiService {
  get _baseUrl => null;
}