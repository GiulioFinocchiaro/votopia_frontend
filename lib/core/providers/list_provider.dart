import 'package:votopia/core/models/list_school_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:votopia/core/services/api_service.dart';

class ListProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _token;
  late final List<ListSchool> _listsMine;
  late final List<ListSchol> _listsMyOrganization;

  Future<Map<String, dynamic>> getListsSchoolMine() async{
    _isLoading = true;
    notifyListeners();

    SharedPreferences sh = SharedPreferences.getInstance();
    _token = sh.getString("token");

    try {
      final response = await _apiService.get(
          "/lists/mine",
          token: _token
      );

      final int responseCode = response['responseCode'];

      if (responseCode >= 200 && responseCode <300){
        _listMine = (response['data'] as List)?
            .map((list) => ListSchool.fromJson(list))
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
      print("Si è verifcato un'errore nell'ottenere le tue liste $e");
      return {
        "status": false,
        "message": response['message'],
        "statusCode": 500
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getListsSchoolMyOrganization() async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences sh = SharedPreferences.getInstance();
    _token = sh.getString("token");

    try {
      final response = await _apiService.get(
        "/lists/myOrganization",
        token: _token
      );

      final int responseCode = response['statusCode'];

      if (responseCode >= 200 && responseCode < 300){
        _listsMyOrganization = (response['data'] as List)?
            .map((list) => ListSchool.fromJson(list))
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
      print("Si è verificato un'errore nell'ottenere tutte le liste "+e);
      return {
        "status": false,
        "message": response['message'],
        "statusCode": 500
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}