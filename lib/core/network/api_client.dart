// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'api_interceptors.dart';

/// Cliente HTTP principal para todas las peticiones de la aplicación
class ApiClient {
  static const String _baseUrl = 'https://api.habigo.com'; // Cambia por tu URL
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  
  late final Dio _dio;
  
  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Agregar interceptores
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(),
      ErrorInterceptor(),
    ]);
  }
  
  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Manejo centralizado de errores
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkException('Tiempo de conexión agotado');
        case DioExceptionType.connectionError:
          return NetworkException('Error de conexión');
        case DioExceptionType.badResponse:
          return ServerException(
            'Error del servidor: ${error.response?.statusCode}',
            statusCode: error.response?.statusCode,
          );
        default:
          return NetworkException('Error de red desconocido');
      }
    }
    return Exception('Error desconocido: $error');
  }
}

/// Excepciones personalizadas
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  ServerException(this.message, {this.statusCode});
  
  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;
  
  ValidationException(this.message, {this.errors});
  
  @override
  String toString() => 'ValidationException: $message';
}