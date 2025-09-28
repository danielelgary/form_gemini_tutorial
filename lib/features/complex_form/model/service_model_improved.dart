// lib/features/complex_form/model/service_model_improved.dart
import 'package:json_annotation/json_annotation.dart';

part 'service_model_improved.g.dart';

/// Modelo mejorado para la capacidad instalada con serialización JSON
@JsonSerializable()
class CapacidadInstalada {
  @JsonKey(name: 'tipo')
  final String tipo; // "consultorio" o "sala"
  
  @JsonKey(name: 'finalidad')
  final String finalidad;
  
  @JsonKey(name: 'cantidad', defaultValue: 1)
  final int cantidad;
  
  @JsonKey(name: 'area_metros_cuadrados')
  final double? areaMetrosCuadrados;

  const CapacidadInstalada({
    required this.tipo,
    required this.finalidad,
    this.cantidad = 1,
    this.areaMetrosCuadrados,
  });

  /// Factory para crear desde JSON
  factory CapacidadInstalada.fromJson(Map<String, dynamic> json) =>
      _$CapacidadInstaladaFromJson(json);

  /// Convierte a JSON
  Map<String, dynamic> toJson() => _$CapacidadInstaladaToJson(this);

  /// Copia con modificaciones
  CapacidadInstalada copyWith({
    String? tipo,
    String? finalidad,
    int? cantidad,
    double? areaMetrosCuadrados,
  }) {
    return CapacidadInstalada(
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
    return other is CapacidadInstalada &&
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

/// Modelo mejorado para la Infraestructura con validaciones
@JsonSerializable()
class Infraestructura {
  // Ubicación
  @JsonKey(name: 'departamento')
  final String departamento;
  
  @JsonKey(name: 'ciudad')
  final String ciudad;
  
  @JsonKey(name: 'direccion')
  final String direccion;
  
  @JsonKey(name: 'codigo_postal')
  final String? codigoPostal;
  
  @JsonKey(name: 'coordenadas')
  final Coordenadas? coordenadas;

  // Detalles técnicos
  @JsonKey(name: 'disposicion_locativa')
  final String disposicionLocativa;
  
  @JsonKey(name: 'tiene_retie')
  final bool tieneRetie;
  
  @JsonKey(name: 'area_total_metros_cuadrados')
  final double? areaTotalMetrosCuadrados;
  
  @JsonKey(name: 'fecha_construccion')
  final DateTime? fechaConstruccion;

  // Capacidad Instalada
  @JsonKey(name: 'capacidad_instalada')
  final List<CapacidadInstalada> capacidadInstalada;

  const Infraestructura({
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
  factory Infraestructura.fromJson(Map<String, dynamic> json) =>
      _$InfraestructuraFromJson(json);

  /// Convierte a JSON
  Map<String, dynamic> toJson() => _$InfraestructuraToJson(this);

  /// Copia con modificaciones
  Infraestructura copyWith({
    String? departamento,
    String? ciudad,
    String? direccion,
    String? codigoPostal,
    Coordenadas? coordenadas,
    String? disposicionLocativa,
    bool? tieneRetie,
    double? areaTotalMetrosCuadrados,
    DateTime? fechaConstruccion,
    List<CapacidadInstalada>? capacidadInstalada,
  }) {
    return Infraestructura(
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

/// Modelo para coordenadas geográficas
@JsonSerializable()
class Coordenadas {
  @JsonKey(name: 'latitud')
  final double latitud;
  
  @JsonKey(name: 'longitud')
  final double longitud;

  const Coordenadas({
    required this.latitud,
    required this.longitud,
  });

  factory Coordenadas.fromJson(Map<String, dynamic> json) =>
      _$CoordenadasFromJson(json);

  Map<String, dynamic> toJson() => _$CoordenadasToJson(this);

  @override
  String toString() => 'Lat: $latitud, Lng: $longitud';
}

/// Modelo principal mejorado para un Servicio
@JsonSerializable()
class ServiceModel {
  @JsonKey(name: 'id')
  final String? id;
  
  @JsonKey(name: 'nombre')
  final String nombre;
  
  @JsonKey(name: 'codigo_cups')
  final String? codigoCups;
  
  @JsonKey(name: 'modalidad')
  final String modalidad;
  
  @JsonKey(name: 'descripcion')
  final String? descripcion;
  
  @JsonKey(name: 'infraestructura')
  final Infraestructura infraestructura;
  
  @JsonKey(name: 'estado')
  final String estado;
  
  @JsonKey(name: 'fecha_creacion')
  final DateTime? fechaCreacion;
  
  @JsonKey(name: 'fecha_actualizacion')
  final DateTime? fechaActualizacion;

  const ServiceModel({
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
  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  /// Convierte a JSON
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  /// Copia con modificaciones
  ServiceModel copyWith({
    String? id,
    String? nombre,
    String? codigoCups,
    String? modalidad,
    String? descripcion,
    Infraestructura? infraestructura,
    String? estado,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ServiceModel(
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
    return other is ServiceModel &&
        other.id == id &&
        other.nombre == nombre &&
        other.modalidad == modalidad;
  }
  
  @override
  int get hashCode {
    return id.hashCode ^ nombre.hashCode ^ modalidad.hashCode;
  }
}