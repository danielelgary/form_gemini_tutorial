// features/complex_form/widgets/_employment_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/info_box.dart';
import 'package:provider/provider.dart';

class EmploymentInfoSection extends StatefulWidget {
  const EmploymentInfoSection({super.key});

  @override
  _EmploymentInfoSectionState createState() => _EmploymentInfoSectionState();
}

class _EmploymentInfoSectionState extends State<EmploymentInfoSection> {
  @override
  Widget build(BuildContext context) {
    // Obtenemos la key del controlador para saber el estado de otros campos
    final formKey = context.read<FormController>().formKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sección de Empleo",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        FormBuilderRadioGroup(
          name: 'employment_status',
          // ... opciones ...
          decoration: const InputDecoration(
            labelText: 'Estado de Empleo',
          ),
          onChanged: (value) => setState(() {}),
          options: ['employed', 'unemployed', 'student']
              .map((status) => FormBuilderFieldOption(
                    value: status,
                    child: Text(status[0].toUpperCase() + status.substring(1)),
                  ))
              .toList(),
        ),

        if (formKey.currentState?.fields['employment_status']?.value ==
            'employed')
          FormBuilderTextField(name: 'company_name', decoration: const InputDecoration(labelText: 'Nombre de la Compañía')),

        FormBuilderTextField(
          name: 'ssn', // Social Security Number
          decoration: InputDecoration(
            labelText: 'Número de Seguridad Social',
            // Añadimos un ícono al final del campo
            suffixIcon: Tooltip(
              message:
                  'Este número es confidencial y se usará únicamente para fines de verificación. No lo compartas.',
              child: Icon(Icons.help_outline, color: Colors.grey.shade600),
            ),
          ),
        ),

        // --- GUÍA VISUAL DINÁMICA ---
        if (formKey.currentState?.fields['employment_status']?.value ==
            'student')
          const InfoBox(
            text:
                '¡Genial! Al ser estudiante, tendrás acceso a descuentos especiales en nuestros planes.',
            color: Colors.green,
          ),

        if (formKey.currentState?.fields['employment_status']?.value ==
            'unemployed')
          const InfoBox(
            text:
                'Recuerda que podemos ayudarte a conectar con oportunidades laborales. Asegúrate de completar tu perfil al 100%.',
            color: Colors.orange,
          ),
      ],
    );
  }
}
