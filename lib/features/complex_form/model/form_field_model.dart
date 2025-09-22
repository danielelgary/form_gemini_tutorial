// lib/features/complex_form/model/form_field_model.dart
// Modelo que define la estructura de cada pregunta del formulario.
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum FieldType { text, email, radio, checkbox, dropdown }

class FormFieldModel {
  final String name;
  final String label;
  final FieldType type;
  final IconData? icon;
  final FormFieldValidator? validator;
  final Map<String, String>? optionsMap;

  FormFieldModel({
    required this.name,
    required this.label,
    required this.type,
    this.icon,
    this.validator,
    this.optionsMap,
  });
}