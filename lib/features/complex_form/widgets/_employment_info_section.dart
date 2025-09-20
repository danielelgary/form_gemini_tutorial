// features/complex_form/widgets/_employment_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/info_box.dart';
import 'package:provider/provider.dart';

class EmploymentInfoSection extends StatelessWidget  {
  const EmploymentInfoSection({super.key});

@override
  Widget build(BuildContext context) {
    // Obtenemos la key del controlador
    final formKey = context.read<FormController>().formKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (Título y FormBuilderRadioGroup)
        FormBuilderRadioGroup(
          name: 'employment_status',
          decoration: const InputDecoration(
            labelText: 'Estado de Empleo',
          ),
          // ¡IMPORTANTE! flutter_form_builder v7+ maneja esto automáticamente.
          // En versiones anteriores, se puede necesitar un listener.
          // Para que el formulario se actualice, debemos registrar un listener.
          onChanged: (value) {
            // Esta línea es clave. Reconstruye los widgets que dependen del estado del formulario.
            // (context as Element).markNeedsBuild(); // Una forma de forzar la reconstrucción
          },
          options: /* ... */,
        ),
        
        // --- CAMPO CONDICIONAL ---
        // Usamos un FormBuilderFieldListener para reconstruir solo esta parte
        // cuando 'employment_status' cambie.
        FormBuilderFieldListener(
            name: 'employment_status',
            builder: (context, field) {
              if (field?.value == 'employed') {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FormBuilderTextField(
                    name: 'company_name',
                    decoration: const InputDecoration(labelText: 'Nombre de la Compañía'),
                  ),
                );
              }
              return const SizedBox.shrink(); // Retorna un widget vacío si no se cumple la condición
            }
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
