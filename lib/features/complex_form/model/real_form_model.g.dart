// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealFormModel _$RealFormModelFromJson(Map<String, dynamic> json) =>
    RealFormModel(
      fullName: json['full_name'] as String?,
      identification: json['identification'] as String?,
      providerType: json['provider_type'] as String?,
      isInReps: json['is_in_reps'] as bool?,
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      isDraft: json['is_draft'] as bool? ?? false,
    );

Map<String, dynamic> _$RealFormModelToJson(RealFormModel instance) =>
    <String, dynamic>{
      'full_name': instance.fullName,
      'identification': instance.identification,
      'provider_type': instance.providerType,
      'is_in_reps': instance.isInReps,
      'services': instance.services.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt.toIso8601String(),
      'is_draft': instance.isDraft,
    };
