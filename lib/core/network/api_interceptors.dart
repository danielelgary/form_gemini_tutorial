// lib/core/network/api_interceptors.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor para logging de peticiones (solo en debug)
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('🚀 [REQUEST] ${options.method} ${options.uri}');
      print('📤 Headers: ${options.headers}');
      if (options.data != null) {
        print('📦 Data: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
      print('📥 Data: ${response.data}');
    }
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('❌ [ERROR] ${err.message}');
      print('🔍 Response: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

/// Interceptor para autenticación automática
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Obtener token de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Si recibimos 401 (no autorizado), limpiar token
    if (err.response?.statusCode == 401) {
      _clearAuthToken();
    }
    super.onError(err, handler);
  }
  
  Future<void> _clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

/// Interceptor para manejo de errores globales
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Error desconocido';
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Tiempo de conexión agotado';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Tiempo de envío agotado';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Tiempo de recepción agotado';
        break;
      case DioExceptionType.badResponse:
        message = _handleResponseError(err.response);
        break;
      case DioExceptionType.cancel:
        message = 'Petición cancelada';
        break;
      case DioExceptionType.connectionError:
        message = 'Error de conexión. Verifica tu internet.';
        break;
      case DioExceptionType.unknown:
        message = 'Error desconocido: ${err.message}';
        break;
      case DioExceptionType.badCertificate:
        message = 'Error de certificado SSL. La conexión no es segura.';
        break;
    }
    
    // Crear nueva excepción con mensaje amigable
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: message,
    );
    
    super.onError(newError, handler);
  }
  
  String _handleResponseError(Response? response) {
    if (response == null) return 'Error del servidor';
    
    switch (response.statusCode) {
      case 400:
        return 'Datos inválidos: ${_extractErrorMessage(response.data)}';
      case 401:
        return 'No autorizado. Inicia sesión nuevamente.';
      case 403:
        return 'No tienes permisos para realizar esta acción.';
      case 404:
        return 'Recurso no encontrado.';
      case 422:
        return 'Error de validación: ${_extractValidationErrors(response.data)}';
      case 500:
        return 'Error interno del servidor.';
      case 503:
        return 'Servicio no disponible temporalmente.';
      default:
        return 'Error del servidor (${response.statusCode})';
    }
  }
  
  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'] ?? 'Error desconocido';
    }
    return data?.toString() ?? 'Error desconocido';
  }
  
  String _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      final List<String> errorMessages = [];
      
      errors.forEach((field, messages) {
        if (messages is List) {
          errorMessages.addAll(messages.cast<String>());
        } else {
          errorMessages.add(messages.toString());
        }
      });
      
      return errorMessages.join(', ');
    }
    
    return _extractErrorMessage(data);
  }
}