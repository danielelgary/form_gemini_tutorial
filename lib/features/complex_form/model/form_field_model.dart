// lib/features/complex_form/model/form_field_model.dart
import 'package:flutter/material.dart';

// Usamos un enum para definir los tipos de campo que soportamos.
// ¡Esto evita errores de escritura y hace el código más seguro!
enum FieldType { text, email, radio, checkbox }

class FormFieldModel {
  final String name;          // El ID único del campo (ej: 'full_name')
  final String label;         // El texto a mostrar (ej: 'Nombre Completo')
  final FieldType type;
  final IconData? icon;
  final List<String>? options; // Para radios o dropdowns
  final FormFieldValidator? validator; // Opcionalmente puedes escribir FormFieldValidator<dynamic>?
  
  FormFieldModel({
    required this.name,
    required this.label,
    required this.type,
    this.icon,
    this.options,
    this.validator,
  });
}