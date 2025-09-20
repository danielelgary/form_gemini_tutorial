// lib/features/complex_form/widgets/_employment_info_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/info_box.dart';
import 'package:provider/provider.dart';

// 1. Volvemos a convertirlo en un StatefulWidget.
//    Esto es necesario porque necesitamos "recordar" la selección del usuario
//    y reconstruir la UI cuando cambie.
class EmploymentInfoSection extends StatefulWidget {
  const EmploymentInfoSection({super.key});

  @override
  _EmploymentInfoSectionState createState() => _EmploymentInfoSectionState();
}

class _EmploymentInfoSectionState extends State<EmploymentInfoSection> {
  @override
  Widget build(BuildContext context) {
    // Obtenemos la key del FormController para acceder al estado de los campos.
    // Usamos context.watch<T>() o Provider.of<T>(context) si queremos que el widget
    // se reconstruya cuando el controller notifique cambios. En este caso,
    // es suficiente con leerla una vez.
    final formKey = context.read<FormController>().formKey;

    // Guardamos el valor actual del campo de estado de empleo para simplificar el código.
    final employmentStatus = formKey.currentState?.fields['employment_status']?.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sección de Empleo",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),

        // --- CAMPO DE ESTADO DE EMPLEO ---
        FormBuilderRadioGroup(
          name: 'employment_status',
          decoration: const InputDecoration(
            labelText: 'Estado de Empleo',
            border: InputBorder.none, // Quitamos el borde para un look más limpio
          ),
          // 2. Aquí está la magia: onChanged llama a setState.
          //    Cuando el usuario cambia la opción, `setState` le dice a Flutter:
          //    "¡Oye, el estado de este widget ha cambiado, por favor, reconstrúyelo!".
          //    Al reconstruir, las condiciones de abajo se vuelven a evaluar.
          onChanged: (value) {
            setState(() {
              // El cuerpo puede estar vacío. La sola llamada a setState() es lo que
              // desencadena la reconstrucción del widget.
            });
          },
          options: ['employed', 'unemployed', 'student']
              .map((status) => FormBuilderFieldOption(
                    value: status,
                    // Un pequeño truco para poner la primera letra en mayúscula.
                    child: Text(status[0].toUpperCase() + status.substring(1)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),

        // --- CAMPO CONDICIONAL: NOMBRE DE LA COMPAÑÍA ---
        // 3. Esta condición ahora se evalúa correctamente en cada reconstrucción.
        //    Si el valor es 'employed', el campo aparece. Si no, no se dibuja.
        if (employmentStatus == 'employed')
          FormBuilderTextField(
            name: 'company_name',
            decoration: const InputDecoration(labelText: 'Nombre de la Compañía'),
          ),

        // --- CAMPO DE SEGURIDAD SOCIAL ---
        FormBuilderTextField(
          name: 'ssn',
          decoration: InputDecoration(
            labelText: 'Número de Seguridad Social',
            suffixIcon: Tooltip(
              message: 'Este número es confidencial y se usará únicamente para fines de verificación.',
              child: Icon(Icons.help_outline, color: Colors.grey.shade600),
            ),
          ),
        ),
        const SizedBox(height: 16),


        // --- GUÍA VISUAL DINÁMICA ---
        // Usamos AnimatedSwitcher para una transición suave al mostrar/ocultar los InfoBox.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(sizeFactor: animation, child: child),
            );
          },
          child: _buildInfoBox(employmentStatus), // Extraemos la lógica a un método
        ),
      ],
    );
  }

  // Método auxiliar para mantener el `build` limpio
  Widget _buildInfoBox(String? status) {
    switch (status) {
      case 'student':
        return const InfoBox(
          key: ValueKey('student_box'), // Key para que AnimatedSwitcher funcione bien
          text: '¡Genial! Al ser estudiante, tendrás acceso a descuentos especiales en nuestros planes.',
          color: Colors.green,
        );
      case 'unemployed':
        return const InfoBox(
          key: ValueKey('unemployed_box'),
          text: 'Recuerda que podemos ayudarte a conectar con oportunidades laborales. Asegúrate de completar tu perfil al 100%.',
          color: Colors.orange,
        );
      default:
        // Retornamos un widget vacío si no hay estado o no coincide.
        return const SizedBox.shrink(key: ValueKey('empty_box'));
    }
  }
}