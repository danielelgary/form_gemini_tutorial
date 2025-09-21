// lib/features/complex_form/model/form_field_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

enum FieldType { text, email, radio, checkbox }

class FormFieldModel {
  final String name;
  final String label;
  final FieldType type;
  final IconData? icon;
  @deprecated // Marcamos 'options' como obsoleto para no usarlo más
  final List<String>? options; 
  final FormFieldValidator? validator;
  
  // --- ¡NUEVO! Un mapa para las opciones (valor interno: texto visible) ---
  final Map<String, String>? optionsMap;

  FormFieldModel({
    required this.name,
    required this.label,
    required this.type,
    this.icon,
    this.options,
    this.validator,
    this.optionsMap, // Añadir al constructor
  });
}