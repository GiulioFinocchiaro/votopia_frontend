import 'package:flutter/material.dart';
import 'package:votopia/core/services/api_service.dart';
import 'package:votopia/core/models/organization_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votopia/core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  Organization? _organizationLogged;
  late User _userLogged;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Organization? get organizationLogged => _organizationLogged;


  User get userLogged => _userLogged;

  Future<Map<String, dynamic>> getOrganizationToAuthenticate(String code) async {
    try {
      _isLoading = true;
      _organizationLogged = null;
      notifyListeners();

      final response = await _apiService.get(
        "/organization/findByCode",
        token: null,
        queryParameters: {"code": code},
      );

      // Assumendo che _apiService.get ritorni anche statusCode
      final int statusCode = response['statusCode'];

      if (response['success'] == true) {
        _organizationLogged = Organization.fromJson(response['data']);
        return {
          "status": true,
          "message": response['message'] ?? "Organizzazione trovata",
          "statusCode": statusCode,
        };
      } else {
        return {
          "status": false,
          "message": response['message'] ?? "Organizzazione non trovata",
          "statusCode": statusCode,
        };
      }
    } catch (e) {
      print("Errore in getOrganizationToAuthenticate: $e");
      return {
        "status": false,
        "message": "Errore di connessione",
        "statusCode": 500,
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async{
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.post(
        "/login",
        {"email": email, "password": password}
      );

      final int responseCode = response['statusCode'] ?? 0;

      if (responseCode == 200 && response['token'] != null){
        _saveToken(response['token']);
        _userLogged = User.fromJson(response['data']);

        _isAuthenticated = true;

        return {
          "status": true,
          "message": response['message'] ?? "Login effettuato con successo",
          "statusCode": responseCode
        };
      } else return {
        "status": false,
        "message": response['message'] ?? "Password errata",
        "statusCode": responseCode
      };
    } catch (e){
      print("Si è verifcato un'errore nel login $e");
      return {
        "status": false,
        "message": e,
        "statusCode": 500
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    await sh.setString('token', token);
  }
}