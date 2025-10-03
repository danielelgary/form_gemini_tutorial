// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model_improved.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CapacidadInstalada _$CapacidadInstaladaFromJson(Map<String, dynamic> json) =>
    CapacidadInstalada(
      tipo: json['tipo'] as String,
      finalidad: json['finalidad'] as String,
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 1,
      areaMetrosCuadrados: (json['area_metros_cuadrados'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CapacidadInstaladaToJson(CapacidadInstalada instance) =>
    <String, dynamic>{
      'tipo': instance.tipo,
      'finalidad': instance.finalidad,
      'cantidad': instance.cantidad,
      'area_metros_cuadrados': instance.areaMetrosCuadrados,
    };

Infraestructura _$InfraestructuraFromJson(
  Map<String, dynamic> json,
) => Infraestructura(
  departamento: json['departamento'] as String,
  ciudad: json['ciudad'] as String,
  direccion: json['direccion'] as String,
  codigoPostal: json['codigo_postal'] as String?,
  coordenadas: json['coordenadas'] == null
      ? null
      : Coordenadas.fromJson(json['coordenadas'] as Map<String, dynamic>),
  disposicionLocativa: json['disposicion_locativa'] as String? ?? 'primer_piso',
  tieneRetie: json['tiene_retie'] as bool? ?? false,
  areaTotalMetrosCuadrados: (json['area_total_metros_cuadrados'] as num?)
      ?.toDouble(),
  fechaConstruccion: json['fecha_construccion'] == null
      ? null
      : DateTime.parse(json['fecha_construccion'] as String),
  capacidadInstalada:
      (json['capacidad_instalada'] as List<dynamic>?)
          ?.map((e) => CapacidadInstalada.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$InfraestructuraToJson(Infraestructura instance) =>
    <String, dynamic>{
      'departamento': instance.departamento,
      'ciudad': instance.ciudad,
      'direccion': instance.direccion,
      'codigo_postal': instance.codigoPostal,
      'coordenadas': instance.coordenadas,
      'disposicion_locativa': instance.disposicionLocativa,
      'tiene_retie': instance.tieneRetie,
      'area_total_metros_cuadrados': instance.areaTotalMetrosCuadrados,
      'fecha_construccion': instance.fechaConstruccion?.toIso8601String(),
      'capacidad_instalada': instance.capacidadInstalada,
    };

Coordenadas _$CoordenadasFromJson(Map<String, dynamic> json) => Coordenadas(
  latitud: (json['latitud'] as num).toDouble(),
  longitud: (json['longitud'] as num).toDouble(),
);

Map<String, dynamic> _$CoordenadasToJson(Coordenadas instance) =>
    <String, dynamic>{
      'latitud': instance.latitud,
      'longitud': instance.longitud,
    };

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
  id: json['id'] as String?,
  nombre: json['nombre'] as String,
  codigoCups: json['codigo_cups'] as String?,
  modalidad: json['modalidad'] as String,
  descripcion: json['descripcion'] as String?,
  infraestructura: Infraestructura.fromJson(
    json['infraestructura'] as Map<String, dynamic>,
  ),
  estado: json['estado'] as String? ?? 'activo',
  fechaCreacion: json['fecha_creacion'] == null
      ? null
      : DateTime.parse(json['fecha_creacion'] as String),
  fechaActualizacion: json['fecha_actualizacion'] == null
      ? null
      : DateTime.parse(json['fecha_actualizacion'] as String),
);

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'codigo_cups': instance.codigoCups,
      'modalidad': instance.modalidad,
      'descripcion': instance.descripcion,
      'infraestructura': instance.infraestructura,
      'estado': instance.estado,
      'fecha_creacion': instance.fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': instance.fechaActualizacion?.toIso8601String(),
    };
