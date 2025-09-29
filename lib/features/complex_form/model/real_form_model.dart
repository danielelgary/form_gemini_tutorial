// lib/features/complex_form/model/real_form_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'service_model_improved.dart';

part 'real_form_model.g.dart';

/// Modelo principal que representa el estado completo de un formulario de caracterización.
@JsonSerializable(explicitToJson: true)
class RealFormModel {
  @JsonKey(name: 'is_in_reps')
  final bool? isInReps;

  @JsonKey(name: 'nombres')
  final String? nombres;

  @JsonKey(name: 'apellidos')
  final String? apellidos;

  @JsonKey(name: 'documento')
  final String? documento;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'telefono')
  final String? telefono;

  @JsonKey(name: 'services')
  final List<ServiceModel> services;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  const RealFormModel({
    this.isInReps,
    this.nombres,
    this.apellidos,
    this.documento,
    this.email,
    this.telefono,
    this.services = const [],
    required this.createdAt,
    this.isDraft = false,
  });

  /// Factory para crear desde JSON
  factory RealFormModel.fromJson(Map<String, dynamic> json) =>
      _$RealFormModelFromJson(json);

  /// Convierte a JSON
  Map<String, dynamic> toJson() => _$RealFormModelToJson(this);

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
      isDraft: isDraft ?? this.isDraft,
    );
  }

  @override
  String toString() {
    return 'RealFormModel(nombres: $nombres, servicios: ${services.length}, isDraft: $isDraft)';
  }
}