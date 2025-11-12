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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
    if (response.data is Map<String, dynamic>) {
      responseData = Map<String, dynamic>.from(response.data);
      responseData['statusCode'] = response.statusCode;
      return responseData;
    } else if (response.data is List) {
      return {
        'statusCode': response.statusCode,
        'data': response.data,
        'message': 'Success',
      };
    } else if (response.data is String) {
      try {
        final decoded = json.decode(response.data);
        if (decoded is Map<String, dynamic>) {
          responseData = Map<String, dynamic>.from(decoded);
          responseData['statusCode'] = response.statusCode;
          return responseData;
        } else {
          return {
            'statusCode': response.statusCode,
            'data': decoded,
            'message': 'Success',
          };
        }
      } catch (_) {
        return {
          'statusCode': response.statusCode,
          'data': response.data,
          'message': 'Success',
        };
      }
    }

    return {
      'statusCode': response.statusCode,
      'data': response.data,
      'message': 'Success',
    };
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;

    return {
      'statusCode': statusCode,
      'data': data,
      'message': data is Map ? data['message'] ?? e.message : e.message,
    };
  }
}