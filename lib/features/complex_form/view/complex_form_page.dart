// lib/features/complex_form/view/complex_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/widgets/_dynamic_form_field.dart';
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart'; // Necesitarás añadir este paquete!

class ComplexFormPage extends StatelessWidget {
  const ComplexFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Formulario Conversacional"),
          // Botón para retroceder
          leading: Consumer<FormController>(
            builder: (context, controller, child) {
              return controller.currentPage > 0
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: controller.previousPage,
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        body: Consumer<FormController>(
          builder: (context, controller, child) {
            return FormBuilder(
              key: controller.formKey,
              child: Column(
                children: [
                  // --- Indicador de Progreso Visual ---
                  DotsIndicator(
                    dotsCount: controller.formFields.length,
                    position: controller.currentPage,
                    decorator: DotsDecorator(
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),

                  // --- El PageView Dinámico ---
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.formFields.length,
                      itemBuilder: (context, index) {
                        final fieldModel = controller.formFields[index];
                        return Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DynamicFormField(fieldModel: fieldModel),
                            ],
                          ),
                        );
                      },
                    ),
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