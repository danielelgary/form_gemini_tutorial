// lib/features/complex_form/widgets/characterization_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CharacterizationSection extends StatelessWidget {
  const CharacterizationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Caracterización", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          FormBuilderSwitch(
            name: 'characterization.reps',
            title: const Text('¿Está inscrito en el REPS?'),
            initialValue: false,
          ),
          // Aquí irá la lista de servicios, que manejaremos en la siguiente sección
        ],
      ),
    );
  }
}