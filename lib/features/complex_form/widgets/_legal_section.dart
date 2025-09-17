// features/complex_form/widgets/_legal_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sección Legal",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),

        // --- CHECKBOX DE TÉRMINOS Y CONDICIONES ---
        FormBuilderCheckbox(
          name: 'accept_terms',
          // El texto que se muestra al lado del checkbox
          title: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black87),
              children: [
                TextSpan(text: 'He leído y acepto los '),
                TextSpan(
                  text: 'Términos y Condiciones',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  // Aquí podrías añadir un recognizer para abrir un enlace
                ),
              ],
            ),
          ),
          // Validación: el valor de este campo DEBE ser `true`
          validator: FormBuilderValidators.equal(
            true,
            errorText: 'Debes aceptar los términos y condiciones para continuar.',
          ),
        ),
      ],
    );
  }
}