import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';

import '../../core/utils/shared_preference.dart'; // Import this for the HttpClientAdapter

/// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Exception? innerException;

  ApiException({
    required this.message,
    this.statusCode,
    this.innerException,
  });

  @override
  String toString() => 'ApiException: $message (${statusCode ?? 'no status code'})';
}

/// Interface for API service configuration
abstract class ApiServiceConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  Duration get sendTimeout;
  Map<String, String> get defaultHeaders;
}

class ApiService {
  final Dio _dio;
  final ApiServiceConfig _config;
  final Logger _logger;

  ApiService({
    required ApiServiceConfig config,
    Dio? dioClient,
    Logger? logger,
  })  : _config = config,
        _dio = dioClient ?? Dio(),
        _logger = logger ?? Logger() {
    _configureDio();
    _addInterceptors();
    _disableSSLCertificateValidation(); // Disable SSL validation
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: _config.connectTimeout,
      receiveTimeout: _config.receiveTimeout,
      sendTimeout: _config.sendTimeout,
      headers: _config.defaultHeaders,
      validateStatus: (status) => status! < 500,
    );
  }

  void _disableSSLCertificateValidation() {
    final adapter = _dio.httpClientAdapter as IOHttpClientAdapter;
    adapter.createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  void _addInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
      var token = await   SharedPreferencesUtil.getString("auth_token");
      if(token != null){
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['authorizationx'] = 'Bearer $token';
      }
        _logRequest(options);
        // Add auth token handling here
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        return handler.next(response);
      },
      onError: (error, handler) {
        _logError(error);
        return handler.next(error);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  void _logRequest(RequestOptions options) {
    _logger.i('''
      Request: ${options.method} ${options.uri}
      Headers: ${options.headers}
      Body: ${options.data}
    ''');
  }

  void _logResponse(Response response) {
    _logger.i('''
      Response: ${response.statusCode} ${response.requestOptions.uri}
      Headers: ${response.headers}
      Body: ${response.data}
    ''');
  }

  void _logError(DioException error) {
    _logger.e('''
      Error: ${error.type} ${error.message}
      Request: ${error.requestOptions.method} ${error.requestOptions.uri}
      Response: ${error.response?.statusCode}
      StackTrace: ${error.stackTrace}
    ''');
  }

  /// Generic GET request
  Future<Response<T>> get<T>(
      BuildContext context, String endpoint,
      {Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken}) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(context, e);
    }
  }

  /// Generic POST request
  Future<Response<T>> post<T>(
      BuildContext context, String endpoint,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken}) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(context, e);
    }
  }

  ApiException _handleDioError(BuildContext context, DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.message ?? 'Unknown error occurred';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Request timed out',
          statusCode: statusCode,
          innerException: error,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Server responded with error: $message',
          statusCode: statusCode,
          innerException: error,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          statusCode: statusCode,
          innerException: error,
        );
      default:
        return ApiException(
          message: 'Network error: $message',
          statusCode: statusCode,
          innerException: error,
        );
    }
  }
}

class AppApiConfig implements ApiServiceConfig {
  @override
  String get baseUrl => 'https://crewminers.com/api/v1/';

  @override
  Duration get connectTimeout => const Duration(seconds: 5);

  @override
  Duration get receiveTimeout => const Duration(seconds: 5);

  @override
  Duration get sendTimeout => const Duration(seconds: 5);

  @override
  Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
