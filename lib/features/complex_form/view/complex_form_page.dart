// lib/features/complex_form/view/complex_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/services_section_page.dart';
import 'package:provider/provider.dart';

// ... (El widget SimpleQuestionPage se mantiene igual)
class SimpleQuestionPage extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  const SimpleQuestionPage({super.key, required this.title, required this.formFields});

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
          ...formFields,
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
          // --- ¡NUEVO! Botón para limpiar el borrador ---
          actions: [
            Consumer<CharacterizationFormController>(
              builder: (context, controller, child) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: "Empezar de Nuevo",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text("¿Empezar de Nuevo?"),
                        content: const Text("Se borrará todo el progreso que has guardado en este formulario."),
                        actions: [
                          TextButton(
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.of(dialogContext).pop(),
                          ),
                          TextButton(
                            child: const Text("Sí, empezar de nuevo"),
                            onPressed: () {
                              controller.clearDraft();
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        // ... (El resto del widget se mantiene exactamente igual)
        body: Consumer<CharacterizationFormController>(
          builder: (context, controller, child) {
            final pages = [
              // ... (la definición de tus páginas)
              SimpleQuestionPage(
                title: "Paso 1: ¡Hola! ¿Cuál es tu nombre?",
                formFields: [
                  FormBuilderTextField(name: 'first_name', decoration: const InputDecoration(labelText: 'Primer Nombre'), validator: FormBuilderValidators.required(), onChanged: (_) => controller.onFieldChanged()),
                  const SizedBox(height: 16),
                  FormBuilderTextField(name: 'middle_name', decoration: const InputDecoration(labelText: 'Segundo Nombre (Opcional)'), onChanged: (_) => controller.onFieldChanged()),
                  const SizedBox(height: 16),
                  FormBuilderTextField(name: 'last_name', decoration: const InputDecoration(labelText: 'Apellidos'), validator: FormBuilderValidators.required(), onChanged: (_) => controller.onFieldChanged()),
                ],
              ),
              SimpleQuestionPage(title: "Paso 2: ¿Y tu identificación?", formFields: [FormBuilderTextField(name: 'identification', decoration: const InputDecoration(labelText: 'Número de Identificación (C.C. o NIT)'), validator: FormBuilderValidators.required(), onChanged: (_) => controller.onFieldChanged())]),
              SimpleQuestionPage(title: "Paso 3: ¿Qué tipo de prestador eres?", formFields: [FormBuilderDropdown(name: 'providerType', decoration: const InputDecoration(labelText: 'Selecciona una opción', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'ips', child: Text('IPS')), DropdownMenuItem(value: 'independiente', child: Text('Profesional Independiente')), DropdownMenuItem(value: 'transporte', child: Text('Transporte especial de pacientes')), DropdownMenuItem(value: 'otro', child: Text('Entidad con objeto social diferente'))], validator: FormBuilderValidators.required(), onChanged: (_) => controller.onFieldChanged())]),
              SimpleQuestionPage(
                title: "Paso 4: ¿Ya estás inscrito en el REPS?",
                formFields: [FormBuilderRadioGroup(
                  name: 'isInReps',
                  decoration: const InputDecoration(border: InputBorder.none),
                  options: const [
                    FormBuilderFieldOption(value: true, child: Text('Sí, ya estoy inscrito')),
                    FormBuilderFieldOption(value: false, child: Text('No, quiero inscribirme')),
                  ],
                   onChanged: (value) => context.read<CharacterizationFormController>().setIsInReps(value),
                  validator: FormBuilderValidators.required(),
                )],
              ),
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
            const totalPages = 5;
            final isLastPage = controller.currentPage == totalPages - 1;

            return BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.currentPage > 0)
                    TextButton.icon(icon: const Icon(Icons.arrow_back), label: const Text("Anterior"), onPressed: controller.isLoading ? null : controller.previousPage),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: controller.isLoading ? null : (isLastPage ? () => controller.submitForm(context) : controller.nextPage),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                    child: controller.isLoading && isLastPage 
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text(isLastPage ? "Finalizar y Enviar" : "Siguiente"),
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