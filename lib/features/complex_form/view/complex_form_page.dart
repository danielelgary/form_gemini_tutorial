// features/complex_form/view/complex_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/widgets/_employment_info_section.dart';
import 'package:form_gemini_tutorial/features/complex_form/widgets/_legal_section.dart';
import 'package:form_gemini_tutorial/features/complex_form/widgets/_personal_info_section.dart';
import 'package:provider/provider.dart';
// ... otros imports

class ComplexFormPage extends StatelessWidget {
  const ComplexFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para crear y proveer nuestro controlador
    return ChangeNotifierProvider(
      create: (_) => FormController(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Formulario Modular")),
        body: Consumer<FormController>( // Consumer reconstruye cuando notifyListeners es llamado
          builder: (context, controller, child) {
            return FormBuilder(
              key: controller.formKey,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Cada sección es ahora un widget separado y limpio
                        PersonalInfoSection(), 
                        const SizedBox(height: 24),
                        EmploymentInfoSection(),
                        const SizedBox(height: 24),
                        LegalSection(),
                        const SizedBox(height: 24),
                        MaterialButton(
                          onPressed: controller.submitForm,
                          child: const Text("Enviar"),
                        ),
                      ],
                    ),
                  ),
                  // Muestra un loader si el controlador lo indica
                  if (controller.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator()),
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