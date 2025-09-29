// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_form_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealFormModel _$RealFormModelFromJson(Map<String, dynamic> json) =>
    RealFormModel(
      isInReps: json['is_in_reps'] as bool?,
      nombres: json['nombres'] as String?,
      apellidos: json['apellidos'] as String?,
      documento: json['documento'] as String?,
      email: json['email'] as String?,
      telefono: json['telefono'] as String?,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      isDraft: json['is_draft'] as bool? ?? false,
    );

Map<String, dynamic> _$RealFormModelToJson(RealFormModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('is_in_reps', instance.isInReps);
  writeNotNull('nombres', instance.nombres);
  writeNotNull('apellidos', instance.apellidos);
  writeNotNull('documento', instance.documento);
  writeNotNull('email', instance.email);
  writeNotNull('telefono', instance.telefono);
  val['services'] = instance.services.map((e) => e.toJson()).toList();
  val['created_at'] = instance.createdAt.toIso8601String();
  val['is_draft'] = instance.isDraft;
  return val;
}