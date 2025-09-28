// lib/features/complex_form/repository/form_repository.dart
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/service_model_improved.dart';
import '../model/real_form_model.dart';

/// Repositorio para manejar todas las operaciones relacionadas con formularios
class FormRepository {
  final ApiClient _apiClient;
  
  FormRepository({ApiClient? apiClient}) 
      : _apiClient = apiClient ?? ApiClient();

  /// Obtiene la lista de servicios disponibles desde el backend
  Future<List<String>> getAvailableServices() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/services/available',
      );
      
      final data = response.data;
      if (data != null && data['services'] is List) {
        return List<String>.from(data['services']);
      }
      
      // Fallback a datos mock si no hay respuesta del servidor
      return _getMockServices();
    } catch (e) {
      // En caso de error, devolver datos mock
      print('Error obteniendo servicios: $e');
      return _getMockServices();
    }
  }
  
  /// Obtiene departamentos y ciudades desde el backend
  Future<Map<String, List<String>>> getLocationsData() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/locations/colombia',
      );
      
      final data = response.data;
      if (data != null && data['locations'] is Map) {
        final locations = Map<String, dynamic>.from(data['locations']);
        final result = <String, List<String>>{};
        
        locations.forEach((department, cities) {
          if (cities is List) {
            result[department] = List<String>.from(cities);
          }
        });
        
        return result;
      }
      
      return _getMockLocations();
    } catch (e) {
      print('Error obteniendo ubicaciones: $e');
      return _getMockLocations();
    }
  }
  
  /// Envía el formulario completo al backend
  Future<FormSubmissionResult> submitForm(RealFormModel formData) async {
    try {
      // Preparar los datos para enviar
      final jsonData = _prepareFormDataForSubmission(formData);
      
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/forms/characterization/submit',
        data: jsonData,
      );
      
      final responseData = response.data;
      if (responseData != null) {
        return FormSubmissionResult.fromJson(responseData);
      }
      
      throw Exception('Respuesta inválida del servidor');
    } catch (e) {
      if (e is DioException) {
        // Manejo especial para errores de validación
        if (e.response?.statusCode == 422) {
          final errorData = e.response?.data;
          if (errorData is Map<String, dynamic>) {
            return FormSubmissionResult(
              success: false,
              message: 'Error de validación',
              errors: _parseValidationErrors(errorData),
            );
          }
        }
      }
      
      return FormSubmissionResult(
        success: false,
        message: 'Error al enviar el formulario: ${e.toString()}',
      );
    }
  }
  
  /// Guarda un borrador del formulario
  Future<bool> saveDraft(RealFormModel formData) async {
    try {
      final jsonData = _prepareFormDataForSubmission(formData);
      jsonData['is_draft'] = true;
      
      await _apiClient.post<Map<String, dynamic>>(
        '/api/forms/characterization/draft',
        data: jsonData,
      );
      
      return true;
    } catch (e) {
      print('Error guardando borrador: $e');
      return false;
    }
  }
  
  /// Obtiene borradores guardados
  Future<List<RealFormModel>> getDrafts() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/api/forms/characterization/drafts',
      );
      
      final data = response.data;
      if (data != null && data['drafts'] is List) {
        final drafts = List<Map<String, dynamic>>.from(data['drafts']);
        return drafts.map((draft) => RealFormModel.fromJson(draft)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error obteniendo borradores: $e');
      return [];
    }
  }
  
  /// Valida un servicio en el backend antes de agregarlo
  Future<ServiceValidationResult> validateService(ServiceModel service) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/api/services/validate',
        data: service.toJson(),
      );
      
      final data = response.data;
      if (data != null) {
        return ServiceValidationResult.fromJson(data);
      }
      
      return ServiceValidationResult(
        isValid: true,
        message: 'Servicio válido',
      );
    } catch (e) {
      return ServiceValidationResult(
        isValid: false,
        message: 'Error validando servicio: ${e.toString()}',
      );
    }
  }
  
  /// Prepara los datos del formulario para el envío
  Map<String, dynamic> _prepareFormDataForSubmission(RealFormModel formData) {
    return {
      'form_data': formData.toJson(),
      'services': formData.services.map((service) => service.toJson()).toList(),
      'submission_timestamp': DateTime.now().toIso8601String(),
      'app_version': '1.0.0',
      'platform': 'flutter',
    };
  }
  
  /// Parsea errores de validación del backend
  Map<String, List<String>> _parseValidationErrors(Map<String, dynamic> errorData) {
    final errors = <String, List<String>>{};
    
    if (errorData.containsKey('errors')) {
      final errorsMap = Map<String, dynamic>.from(errorData['errors']);
      
      errorsMap.forEach((field, messages) {
        if (messages is List) {
          errors[field] = List<String>.from(messages);
        } else {
          errors[field] = [messages.toString()];
        }
      });
    }
    
    return errors;
  }
  
  /// Datos mock para desarrollo/fallback
  List<String> _getMockServices() {
    return [
      'Consulta Externa',
      'Urgencias',
      'Hospitalización',
      'Cirugía Ambulatoria',
      'Laboratorio Clínico',
      'Imágenes Diagnósticas',
      'Odontología',
      'Optometría',
      'Fisioterapia',
      'Psicología',
      'Nutrición y Dietética',
      'Transporte Asistencial Básico',
      'Transporte Asistencial Medicalizado',
    ];
  }
  
  /// Datos mock de ubicaciones
  Map<String, List<String>> _getMockLocations() {
    return {
      'Antioquia': ['Medellín', 'Bello', 'Itagui', 'Envigado', 'Sabaneta'],
      'Cundinamarca': ['Bogotá', 'Soacha', 'Zipaquirá', 'Facatativá'],
      'Valle del Cauca': ['Cali', 'Palmira', 'Buenaventura', 'Tuluá'],
      'Atlántico': ['Barranquilla', 'Soledad', 'Malambo', 'Puerto Colombia'],
    };
  }
}

/// Resultado del envío del formulario
class FormSubmissionResult {
  final bool success;
  final String message;
  final String? submissionId;
  final Map<String, List<String>>? errors;
  final DateTime? submittedAt;
  
  FormSubmissionResult({
    required this.success,
    required this.message,
    this.submissionId,
    this.errors,
    this.submittedAt,
  });
  
  factory FormSubmissionResult.fromJson(Map<String, dynamic> json) {
    return FormSubmissionResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      submissionId: json['submission_id'],
      errors: json['errors'] != null 
          ? Map<String, List<String>>.from(json['errors'])
          : null,
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at'])
          : null,
    );
  }
}

/// Resultado de la validación de servicio
class ServiceValidationResult {
  final bool isValid;
  final String message;
  final List<String>? warnings;
  final Map<String, dynamic>? suggestions;
  
  ServiceValidationResult({
    required this.isValid,
    required this.message,
    this.warnings,
    this.suggestions,
  });
  
  factory ServiceValidationResult.fromJson(Map<String, dynamic> json) {
    return ServiceValidationResult(
      isValid: json['is_valid'] ?? false,
      message: json['message'] ?? '',
      warnings: json['warnings'] != null 
          ? List<String>.from(json['warnings'])
          : null,
      suggestions: json['suggestions'],
    );
  }
}