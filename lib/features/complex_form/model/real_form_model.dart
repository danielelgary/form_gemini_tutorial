// lib/features/complex_form/model/real_form_model.dart
import 'service_model.dart'; // Usar el modelo original por ahora

/// Modelo principal del formulario que contiene todos los datos
class RealFormModel {
  // Información básica
  final bool? isInReps;
  final String? nombres;
  final String? apellidos;
  final String? documento;
  final String? email;
  final String? telefono;
  
  // Servicios agregados
  final List<ServiceModel> services;
  
  // Metadatos
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isDraft;

  const RealFormModel({
    this.isInReps,
    this.nombres,
    this.apellidos,
    this.documento,
    this.email,
    this.telefono,
    this.services = const [],
    this.createdAt,
    this.updatedAt,
    this.isDraft = false,
  });

  /// Crea desde JSON
  factory RealFormModel.fromJson(Map<String, dynamic> json) {
    return RealFormModel(
      isInReps: json['is_in_reps'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      documento: json['documento'],
      email: json['email'],
      telefono: json['telefono'],
      services: json['services'] != null
          ? (json['services'] as List)
              .map((s) => ServiceModel(
                    nombre: s['nombre'] ?? '',
                    modalidad: s['modalidad'] ?? '',
                    infraestructura: Infraestructura(
                      departamento: s['infraestructura']['departamento'] ?? '',
                      ciudad: s['infraestructura']['ciudad'] ?? '',
                      direccion: s['infraestructura']['direccion'] ?? '',
                    ),
                  ))
              .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      isDraft: json['is_draft'] ?? false,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'is_in_reps': isInReps,
      'nombres': nombres,
      'apellidos': apellidos,
      'documento': documento,
      'email': email,
      'telefono': telefono,
      'services': services.map((s) => {
        'nombre': s.nombre,
        'modalidad': s.modalidad,
        'infraestructura': {
          'departamento': s.infraestructura.departamento,
          'ciudad': s.infraestructura.ciudad,
          'direccion': s.infraestructura.direccion,
          'disposicion_locativa': s.infraestructura.disposicionLocativa,
          'tiene_retie': s.infraestructura.tieneRetie,
          'capacidad_instalada': s.infraestructura.capacidadInstalada.map((c) => {
            'tipo': c.tipo,
            'finalidad': c.finalidad,
          }).toList(),
        },
      }).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_draft': isDraft,
    };
  }

  /// Copia con modificaciones
  RealFormModel copyWith({
    bool? isInReps,
    String? nombres,
    String? apellidos,
    String? documento,
    String? email,
    String? telefono,
    List<ServiceModel>? services,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDraft,
  }) {
    return RealFormModel(
      isInReps: isInReps ?? this.isInReps,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      documento: documento ?? this.documento,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  /// Validaciones del modelo completo
  List<String> validate() {
    final errors = <String>[];
    
    if (isInReps == null) {
      errors.add('Debe seleccionar si está en REPS');
    }
    
    if (nombres?.trim().isEmpty ?? true) {
      errors.add('Los nombres son requeridos');
    }
    
    if (apellidos?.trim().isEmpty ?? true) {
      errors.add('Los apellidos son requeridos');
    }
    
    if (documento?.trim().isEmpty ?? true) {
      errors.add('El documento es requerido');
    }
    
    if (email?.trim().isEmpty ?? true) {
      errors.add('El email es requerido');
    }
    
    if (telefono?.trim().isEmpty ?? true) {
      errors.add('El teléfono es requerido');
    }
    
    if (services.isEmpty) {
      errors.add('Debe agregar al menos un servicio');
    }
    
    return errors;
  }
  
  /// Verifica si el modelo es válido
  bool get isValid => validate().isEmpty;
  
  @override
  String toString() {
    return 'RealFormModel(isInReps: $isInReps, services: ${services.length})';
  }
}

// Clase simple para compatibilidad (mantener por ahora)
class Service {
  final int medicalSpecialty;
  final String type;
  final int modality;

  Service({
    required this.medicalSpecialty,
    required this.type,
    required this.modality,
  });

  @override
  String toString() {
    return 'Especialidad: $medicalSpecialty, Tipo: $type';
  }
}