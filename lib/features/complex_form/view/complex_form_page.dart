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

            // ¡NUEVO! Las secciones ahora son las páginas de nuestro PageView
            final formSections = [
              PersonalInfoSection(),
              EmploymentInfoSection(),
              LegalSection(),
            ];

            return FormBuilder(
              key: controller.formKey,
              child: Stack(
                children: [
                  PageView(
                    controller: controller.pageController,
                    // Deshabilitamos el deslizamiento manual para forzar el uso de botones
                    physics: const NeverScrollableScrollPhysics(), 
                    children: formSections.map((section) {
                      // Envolvemos cada sección en un padding para mantener el diseño
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: section,
                      );
                    }).toList(),
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
        // --- NUEVO: Barra de navegación inferior ---
        bottomNavigationBar: Consumer<FormController>(
          builder: (context, controller, child) {
            final isFirstPage = controller.currentPage == 0;
            final isLastPage = controller.currentPage == 2; // 2 es la última página (0, 1, 2)

            return BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón "Anterior"
                    if (!isFirstPage)
                      TextButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Anterior"),
                        onPressed: controller.previousPage,
                      ),
                    
                    // Indicador de progreso (opcional pero recomendado)
                    Text("Paso ${controller.currentPage + 1} de 3"),

                    // Botón "Siguiente" o "Enviar"
                    FilledButton.icon(
                      icon: Icon(isLastPage ? Icons.check : Icons.arrow_forward),
                      label: Text(isLastPage ? "Enviar" : "Siguiente"),
                      onPressed: isLastPage ? controller.submitForm : controller.nextPage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
