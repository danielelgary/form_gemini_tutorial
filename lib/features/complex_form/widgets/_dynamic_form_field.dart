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
          keyboardType: fieldModel.type == FieldType.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          // Al completar la escritura, avanzamos
          onEditingComplete: formController.validateAndNext,
        );

      case FieldType.radio:
        return FormBuilderRadioGroup(
          name: fieldModel.name,
          decoration: InputDecoration(
            labelText: fieldModel.label,
            border: InputBorder.none,
          ),
          validator: fieldModel.validator,

          options: (fieldModel.optionsMap?.entries ?? [])
              .map((entry) => FormBuilderFieldOption(
                    value: entry.key, // El valor guardado será 'employed', 'unemployed', etc.
                    child: Text(entry.value), // El texto visible será 'Empleado', 'Desempleado', etc.
                  ))
              .toList(),
          onChanged: (value) {
            formController.onFieldChanged();
          },
        );

      case FieldType.checkbox:
        return FormBuilderCheckbox(
          name: fieldModel.name,
          title: Text(fieldModel.label),
          validator: fieldModel.validator,
          // --- LÓGICA MODIFICADA ---
          onChanged: (value) {
            // 1. Notificamos el cambio para que la UI se actualice.
            formController.onFieldChanged();
            // 2. Validamos sin avanzar, ya que es el último paso.
            formController.formKey.currentState?.fields[fieldModel.name]
                ?.validate();
          },
        );
      default:
        return Text('Error: Tipo de campo no soportado');
    }
  }
}
