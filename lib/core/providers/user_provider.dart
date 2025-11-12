import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:votopia/core/models/user_model.dart';
import 'package:votopia/core/services/api_service.dart';

class UserProvider extends ChangeNotifier{
  final ApiService _apiService = new ApiService();
  bool _isLoading = false;

  String? _token;
  List<User> _usersMyOrganization = [];

  Future<Map<String, dynamic>> getUsersMyOrganization() async{
    _isLoading = true;
    notifyListeners();

    SharedPreferences sh = await SharedPreferences.getInstance();
    _token = sh.getString("token");

    try {
      final response = await _apiService.get(
        "/users/myOrganization",
        token: _token
      );

      final int responseCode = response['responseCode'];

      if (responseCode >= 200 && responseCode <300){
        _usersMyOrganization = (response['data'] as List)
            .map((user) => User.fromJson(user))
            .toList();

        return {
          "status": true,
          "message": response['message'],
          "statusCode": responseCode
        };
      }

      return {
        "status": false,
        "message": response['message'],
        "statusCode": responseCode
      };
    } catch (e){
      print("Si è verificato un errore nell'ottenere gli utenti $e");
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

  List<User> get usersMyOrganization => _usersMyOrganization;
}