// lib/features/complex_form/model/service_model_simple.dart
// Versión simplificada sin JSON serialization para evitar errores de generación

/// Modelo mejorado para la capacidad instalada (sin JSON serialization)
class CapacidadInstaladaSimple {
  final String tipo; // "consultorio" o "sala"
  final String finalidad;
  final int cantidad;
  final double? areaMetrosCuadrados;

  const CapacidadInstaladaSimple({
    required this.tipo,
    required this.finalidad,
    this.cantidad = 1,
    this.areaMetrosCuadrados,
  });

  /// Factory para crear desde JSON
  factory CapacidadInstaladaSimple.fromJson(Map<String, dynamic> json) {
    return CapacidadInstaladaSimple(
      tipo: json['tipo'] ?? '',
      finalidad: json['finalidad'] ?? '',
      cantidad: json['cantidad'] ?? 1,
      areaMetrosCuadrados: json['area_metros_cuadrados']?.toDouble(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'finalidad': finalidad,
      'cantidad': cantidad,
      'area_metros_cuadrados': areaMetrosCuadrados,
    };
  }

  /// Copia con modificaciones
  CapacidadInstaladaSimple copyWith({
    String? tipo,
    String? finalidad,
    int? cantidad,
    double? areaMetrosCuadrados,
  }) {
    return CapacidadInstaladaSimple(
      tipo: tipo ?? this.tipo,
      finalidad: finalidad ?? this.finalidad,
      cantidad: cantidad ?? this.cantidad,
      areaMetrosCuadrados: areaMetrosCuadrados ?? this.areaMetrosCuadrados,
    );
  }

  @override
  String toString() {
    final tipoCapitalizado = tipo[0].toUpperCase() + tipo.substring(1);
    return '$tipoCapitalizado: $finalidad ${cantidad > 1 ? '(x$cantidad)' : ''}';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CapacidadInstaladaSimple &&
        other.tipo == tipo &&
        other.finalidad == finalidad &&
        other.cantidad == cantidad &&
        other.areaMetrosCuadrados == areaMetrosCuadrados;
  }
  
  @override
  int get hashCode {
    return tipo.hashCode ^
        finalidad.hashCode ^
        cantidad.hashCode ^
        areaMetrosCuadrados.hashCode;
  }
}

/// Modelo para coordenadas geográficas
class CoordenadasSimple {
  final double latitud;
  final double longitud;

  const CoordenadasSimple({
    required this.latitud,
    required this.longitud,
  });

  factory CoordenadasSimple.fromJson(Map<String, dynamic> json) {
    return CoordenadasSimple(
      latitud: json['latitud']?.toDouble() ?? 0.0,
      longitud: json['longitud']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  @override
  String toString() => 'Lat: $latitud, Lng: $longitud';
}

/// Modelo mejorado para la Infraestructura
class InfraestructuraSimple {
  // Ubicación
  final String departamento;
  final String ciudad;
  final String direccion;
  final String? codigoPostal;
  final CoordenadasSimple? coordenadas;

  // Detalles técnicos
  final String disposicionLocativa;
  final bool tieneRetie;
  final double? areaTotalMetrosCuadrados;
  final DateTime? fechaConstruccion;

  // Capacidad Instalada
  final List<CapacidadInstaladaSimple> capacidadInstalada;

  const InfraestructuraSimple({
    required this.departamento,
    required this.ciudad,
    required this.direccion,
    this.codigoPostal,
    this.coordenadas,
    this.disposicionLocativa = 'primer_piso',
    this.tieneRetie = false,
    this.areaTotalMetrosCuadrados,
    this.fechaConstruccion,
    this.capacidadInstalada = const [],
  });

  /// Factory para crear desde JSON
  factory InfraestructuraSimple.fromJson(Map<String, dynamic> json) {
    return InfraestructuraSimple(
      departamento: json['departamento'] ?? '',
      ciudad: json['ciudad'] ?? '',
      direccion: json['direccion'] ?? '',
      codigoPostal: json['codigo_postal'],
      coordenadas: json['coordenadas'] != null
          ? CoordenadasSimple.fromJson(json['coordenadas'])
          : null,
      disposicionLocativa: json['disposicion_locativa'] ?? 'primer_piso',
      tieneRetie: json['tiene_retie'] ?? false,
      areaTotalMetrosCuadrados: json['area_total_metros_cuadrados']?.toDouble(),
      fechaConstruccion: json['fecha_construccion'] != null
          ? DateTime.parse(json['fecha_construccion'])
          : null,
      capacidadInstalada: json['capacidad_instalada'] != null
          ? (json['capacidad_instalada'] as List)
              .map((c) => CapacidadInstaladaSimple.fromJson(c))
              .toList()
          : [],
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'departamento': departamento,
      'ciudad': ciudad,
      'direccion': direccion,
      'codigo_postal': codigoPostal,
      'coordenadas': coordenadas?.toJson(),
      'disposicion_locativa': disposicionLocativa,
      'tiene_retie': tieneRetie,
      'area_total_metros_cuadrados': areaTotalMetrosCuadrados,
      'fecha_construccion': fechaConstruccion?.toIso8601String(),
      'capacidad_instalada': capacidadInstalada.map((c) => c.toJson()).toList(),
    };
  }

  /// Copia con modificaciones
  InfraestructuraSimple copyWith({
    String? departamento,
    String? ciudad,
    String? direccion,
    String? codigoPostal,
    CoordenadasSimple? coordenadas,
    String? disposicionLocativa,
    bool? tieneRetie,
    double? areaTotalMetrosCuadrados,
    DateTime? fechaConstruccion,
    List<CapacidadInstaladaSimple>? capacidadInstalada,
  }) {
    return InfraestructuraSimple(
      departamento: departamento ?? this.departamento,
      ciudad: ciudad ?? this.ciudad,
      direccion: direccion ?? this.direccion,
      codigoPostal: codigoPostal ?? this.codigoPostal,
      coordenadas: coordenadas ?? this.coordenadas,
      disposicionLocativa: disposicionLocativa ?? this.disposicionLocativa,
      tieneRetie: tieneRetie ?? this.tieneRetie,
      areaTotalMetrosCuadrados: areaTotalMetrosCuadrados ?? this.areaTotalMetrosCuadrados,
      fechaConstruccion: fechaConstruccion ?? this.fechaConstruccion,
      capacidadInstalada: capacidadInstalada ?? this.capacidadInstalada,
    );
  }

  /// Validaciones
  List<String> validate() {
    final errors = <String>[];
    
    if (departamento.trim().isEmpty) {
      errors.add('El departamento es requerido');
    }
    
    if (ciudad.trim().isEmpty) {
      errors.add('La ciudad es requerida');
    }
    
    if (direccion.trim().isEmpty) {
      errors.add('La dirección es requerida');
    }
    
    if (capacidadInstalada.isEmpty) {
      errors.add('Debe agregar al menos una capacidad instalada');
    }
    
    return errors;
  }
  
  /// Verifica si la infraestructura es válida
  bool get isValid => validate().isEmpty;

  @override
  String toString() {
    return '$direccion, $ciudad, $departamento';
  }
}

/// Modelo principal mejorado para un Servicio
class ServiceModelSimple {
  final String? id;
  final String nombre;
  final String? codigoCups;
  final String modalidad;
  final String? descripcion;
  final InfraestructuraSimple infraestructura;
  final String estado;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  const ServiceModelSimple({
    this.id,
    required this.nombre,
    this.codigoCups,
    required this.modalidad,
    this.descripcion,
    required this.infraestructura,
    this.estado = 'activo',
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  /// Factory para crear desde JSON
  factory ServiceModelSimple.fromJson(Map<String, dynamic> json) {
    return ServiceModelSimple(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      codigoCups: json['codigo_cups'],
      modalidad: json['modalidad'] ?? '',
      descripcion: json['descripcion'],
      infraestructura: InfraestructuraSimple.fromJson(json['infraestructura'] ?? {}),
      estado: json['estado'] ?? 'activo',
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'])
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo_cups': codigoCups,
      'modalidad': modalidad,
      'descripcion': descripcion,
      'infraestructura': infraestructura.toJson(),
      'estado': estado,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  /// Copia con modificaciones
  ServiceModelSimple copyWith({
    String? id,
    String? nombre,
    String? codigoCups,
    String? modalidad,
    String? descripcion,
    InfraestructuraSimple? infraestructura,
    String? estado,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ServiceModelSimple(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigoCups: codigoCups ?? this.codigoCups,
      modalidad: modalidad ?? this.modalidad,
      descripcion: descripcion ?? this.descripcion,
      infraestructura: infraestructura ?? this.infraestructura,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  /// Validaciones del servicio
  List<String> validate() {
    final errors = <String>[];
    
    if (nombre.trim().isEmpty) {
      errors.add('El nombre del servicio es requerido');
    }
    
    if (modalidad.trim().isEmpty) {
      errors.add('La modalidad es requerida');
    }
    
    // Validar infraestructura
    errors.addAll(infraestructura.validate());
    
    return errors;
  }
  
  /// Verifica si el servicio es válido
  bool get isValid => validate().isEmpty;

  @override
  String toString() {
    return '$nombre ($modalidad)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceModelSimple &&
        other.id == id &&
        other.nombre == nombre &&
        other.modalidad == modalidad;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^ nombre.hashCode ^ modalidad.hashCode;
  }
}