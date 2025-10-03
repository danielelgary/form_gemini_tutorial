// lib/features/complex_form/model/real_form_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'service_model_improved.dart';

part 'real_form_model.g.dart';

/// Modelo principal que representa el estado completo de un formulario de caracterización.
@JsonSerializable(explicitToJson: true)
class RealFormModel {
  @JsonKey(name: 'full_name')
  final String? fullName;

  @JsonKey(name: 'identification')
  final String? identification;

  @JsonKey(name: 'provider_type')
  final String? providerType;

  @JsonKey(name: 'is_in_reps')
  final bool? isInReps;

  @JsonKey(name: 'services')
  final List<ServiceModel> services;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  const RealFormModel({
    this.fullName,
    this.identification,
    this.providerType,
    this.isInReps,
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
    String? fullName,
    String? identification,
    String? providerType,
    bool? isInReps,
    List<ServiceModel>? services,
    DateTime? createdAt,
    bool? isDraft,
  }) {
    return RealFormModel(
      fullName: fullName ?? this.fullName,
      identification: identification ?? this.identification,
      providerType: providerType ?? this.providerType,
      isInReps: isInReps ?? this.isInReps,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
      isDraft: isDraft ?? this.isDraft,
    );
  }

  @override
  String toString() {
    return 'RealFormModel(fullName: $fullName, services: ${services.length}, isDraft: $isDraft)';
  }
}