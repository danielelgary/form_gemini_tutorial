// lib/features/complex_form/view/complex_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/services_section_page.dart'; // Importa la nueva sección
import 'package:provider/provider.dart';

class SimpleQuestionPage extends StatelessWidget {
  final String title;
  final Widget formField;
  const SimpleQuestionPage({super.key, required this.title, required this.formField});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          formField,
        ],
      ),
    );
  }
}

class ComplexFormPage extends StatelessWidget {
  const ComplexFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterizationFormController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Formulario de Caracterización"),
          scrolledUnderElevation: 0,
        ),
        body: Consumer<CharacterizationFormController>(
          builder: (context, controller, child) {
            final pages = [
              SimpleQuestionPage(title: "Paso 1: ¡Hola! ¿Cuál es tu nombre?", formField: FormBuilderTextField(name: 'fullName', decoration: const InputDecoration(labelText: 'Nombre Completo'), validator: FormBuilderValidators.required())),
              SimpleQuestionPage(title: "Paso 2: ¿Y tu identificación?", formField: FormBuilderTextField(name: 'identification', decoration: const InputDecoration(labelText: 'Número de Identificación (C.C. o NIT)'), validator: FormBuilderValidators.required())),
              SimpleQuestionPage(title: "Paso 3: ¿Qué tipo de prestador eres?", formField: FormBuilderDropdown(name: 'providerType', decoration: const InputDecoration(labelText: 'Selecciona una opción', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'ips', child: Text('IPS')), DropdownMenuItem(value: 'independiente', child: Text('Profesional Independiente')), DropdownMenuItem(value: 'transporte', child: Text('Transporte especial de pacientes')), DropdownMenuItem(value: 'otro', child: Text('Entidad con objeto social diferente'))], validator: FormBuilderValidators.required())),
              SimpleQuestionPage(
                title: "Paso 4: ¿Ya estás inscrito en el REPS?",
                formField: FormBuilderRadioGroup(
                  name: 'isInReps',
                  decoration: const InputDecoration(border: InputBorder.none),
                  options: const [
                    FormBuilderFieldOption(value: true, child: Text('Sí, ya estoy inscrito')),
                    FormBuilderFieldOption(value: false, child: Text('No, quiero inscribirme')),
                  ],
                   onChanged: (value) {
                    if (value != null) {
                      context.read<CharacterizationFormController>().setIsInReps(value);
                    }
                  },
                  validator: FormBuilderValidators.required(),
                ),
              ),
              // Esta página de Servicios es la última y más importante
              const ServicesSectionPage(),
            ];

            return FormBuilder(
              key: controller.formKey,
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<CharacterizationFormController>(
          builder: (context, controller, child) {
            const totalPages = 5; // Ahora tenemos 5 secciones fijas
            final isLastPage = controller.currentPage == totalPages - 1;

            return BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.currentPage > 0)
                    TextButton.icon(icon: const Icon(Icons.arrow_back), label: const Text("Anterior"), onPressed: controller.previousPage),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: isLastPage ? controller.submitForm : controller.nextPage,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                    child: Text(isLastPage ? "Finalizar y Enviar" : "Siguiente"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}