// features/complex_form/widgets/_personal_info_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título para organizar visualmente el formulario
        Text(
          "Sección de Información Personal",
          style: Theme.of(context).textTheme.headlineSmall, // Estilo de título
        ),
        const SizedBox(height: 16),

        // --- CAMPO DE NOMBRE COMPLETO ---
        FormBuilderTextField(
          name: 'full_name',
          decoration: const InputDecoration(
            labelText: 'Nombre Completo',
            prefixIcon: Icon(Icons.person),
          ),
          // Validación: este campo es obligatorio
          validator: FormBuilderValidators.required(
            errorText: 'Por favor, introduce tu nombre completo.',
          ),
        ),
        const SizedBox(height: 16),

        // --- CAMPO DE CORREO ELECTRÓNICO ---
        FormBuilderTextField(
          name: 'email',
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            prefixIcon: Icon(Icons.email),
          ),
          // Componemos múltiples validaciones
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: 'El correo es obligatorio.'),
            FormBuilderValidators.email(errorText: 'El formato del correo no es válido.'),
          ]),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}