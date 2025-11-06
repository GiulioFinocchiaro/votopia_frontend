import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:votopia/core/constants/app_constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseUrl;
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  // GET
  Future<Map<String, dynamic>> get(
      String endpoint, {
        String? token,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options?.copyWith(
          headers: token != null
              ? {...?options.headers, 'Authorization': 'Bearer $token'}
              : options?.headers,
          validateStatus: (status) => status != null && status < 500,
        ) ??
            Options(
              headers: token != null ? {'Authorization': 'Bearer $token'} : null,
              validateStatus: (status) => status != null && status < 500,
            ),
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'statusCode': 0,
        'data': null,
        'message': 'Errore imprevisto: ${e.toString()}',
      };
    }
  }

  // POST / PUT / DELETE seguono la stessa logica
  Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> data, {
        String? token,
        bool isFormData = false,
      }) async {
    try {
      final requestData = isFormData ? FormData.fromMap(data) : data;
      final response = await _dio.post(
        endpoint,
        data: requestData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'statusCode': 0,
        'data': null,
        'message': 'Errore imprevisto: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint,
      Map<String, dynamic> data, {
        String? token,
        bool isFormData = false,
      }) async {
    try {
      final requestData = isFormData ? FormData.fromMap(data) : data;
      final response = await _dio.put(
        endpoint,
        data: requestData,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'statusCode': 0,
        'data': null,
        'message': 'Errore imprevisto: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, dynamic>? data,
        String? token,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'statusCode': 0,
        'data': null,
        'message': 'Errore imprevisto: ${e.toString()}',
      };
    }
  }

  // --- Helper functions ---
  Map<String, dynamic> _handleResponse(Response response) {
    dynamic responseData;
    if (response.data is Map<String, dynamic> || response.data is List) {
      responseData = response.data;
    } else if (response.data is String) {
      try {
        responseData = json.decode(response.data);
      } catch (_) {
        responseData = response.data;
      }
    }

    responseData['statusCode'] = response.statusCode;
    return responseData;
  }

  Map<String, dynamic> _handleDioError(DioError e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;

    return {
      'statusCode': statusCode,
      'data': data,
      'message': data is Map ? data['message'] ?? e.message : e.message,
    };
  }
}