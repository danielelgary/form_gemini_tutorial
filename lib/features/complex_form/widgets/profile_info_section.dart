// lib/features/complex_form/widgets/profile_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Información del Perfil", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          // Usamos nombres anidados para que coincidan con el JSON final
          FormBuilderTextField(
            name: 'profile_info.first',
            decoration: const InputDecoration(labelText: 'Primer Nombre'),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'profile_info.middle',
            decoration: const InputDecoration(labelText: 'Segundo Nombre'),
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'profile_info.last',
            decoration: const InputDecoration(labelText: 'Apellidos'),
            validator: FormBuilderValidators.required(),
          ),
        ],
      ),
    );
  }
}