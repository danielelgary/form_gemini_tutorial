// lib/features/complex_form/widgets/_dynamic_form_field.dart
// Widget reutilizable que construye el campo de formulario correcto según el modelo.
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
    final formController = context.read<CharacterizationFormController>();

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
          onEditingComplete: () {
            // Simplificado para evitar errores
            formController.nextPage();
          },
        );
      case FieldType.radio:
        return FormBuilderRadioGroup(
          name: fieldModel.name,
          decoration: InputDecoration(labelText: fieldModel.label, border: InputBorder.none),
          validator: fieldModel.validator,
          options: (fieldModel.optionsMap?.entries ?? [])
              .map((entry) => FormBuilderFieldOption(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
              .toList(),
          onChanged: (value) {
            // Método simplificado
            if (formController.formKey.currentState != null) {
              formController.formKey.currentState!.fields[fieldModel.name]?.validate();
            }
          },
        );
      case FieldType.dropdown:
        return FormBuilderDropdown(
          name: fieldModel.name,
          decoration: InputDecoration(
            labelText: fieldModel.label,
          ),
          validator: fieldModel.validator,
          items: (fieldModel.optionsMap?.entries ?? [])
              .map((entry) => DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
              .toList(),
          onChanged: (value) {
            // Método simplificado
            if (formController.formKey.currentState != null) {
              formController.formKey.currentState!.fields[fieldModel.name]?.validate();
            }
          },
        );
      case FieldType.checkbox:
        return FormBuilderCheckbox(
          name: fieldModel.name,
          title: Text(fieldModel.label),
          validator: fieldModel.validator,
          onChanged: (value) {
            // Método simplificado
            if (formController.formKey.currentState != null) {
              formController.formKey.currentState!.fields[fieldModel.name]?.validate();
            }
          },
        );
      default:
        return const Text('Error: Tipo de campo no soportado');
    }
  }
}