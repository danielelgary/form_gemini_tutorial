// lib/features/complex_form/widgets/_dynamic_form_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../model/form_field_model.dart';
import '../controller/form_controller.dart';
import 'package:provider/provider.dart';

class DynamicFormField extends StatelessWidget {
  final FormFieldModel fieldModel;

  const DynamicFormField({super.key, required this.fieldModel});

  @override
  Widget build(BuildContext context) {
    // Con este truco, podemos llamar al controlador desde aquí
    final formController = context.read<FormController>();
    
    // Usamos un switch para decidir qué widget de FormBuilder renderizar
    switch (fieldModel.type) {
      case FieldType.text:
      case FieldType.email:
        return FormBuilderTextField(
          name: fieldModel.name,
          decoration: InputDecoration(
            labelText: fieldModel.label,
            prefixIcon: fieldModel.icon != null ? Icon(fieldModel.icon) : null,
          ),
          validator: fieldModel.validator,
          keyboardType: fieldModel.type == FieldType.email ? TextInputType.emailAddress : TextInputType.text,
          // Al completar la escritura, avanzamos
          onEditingComplete: formController.validateAndNext,
        );
      case FieldType.radio:
        return FormBuilderRadioGroup(
          name: fieldModel.name,
          decoration: InputDecoration(labelText: fieldModel.label, border: InputBorder.none),
          validator: fieldModel.validator,
          options: (fieldModel.options ?? [])
              .map((opt) => FormBuilderFieldOption(value: opt, child: Text(opt)))
              .toList(),
          // Al cambiar la opción, avanzamos automáticamente
          onChanged: (_) => Future.delayed(const Duration(milliseconds: 300), formController.validateAndNext),
        );
      case FieldType.checkbox:
         return FormBuilderCheckbox(
          name: fieldModel.name,
          title: Text(fieldModel.label),
          validator: fieldModel.validator,
          // También avanzamos al cambiar
          onChanged: (_) => Future.delayed(const Duration(milliseconds: 300), formController.validateAndNext),
        );
      default:
        return Text('Error: Tipo de campo no soportado');
    }
  }
}