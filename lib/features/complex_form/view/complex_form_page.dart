// lib/features/complex_form/view/complex_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/info_box.dart';
import 'package:form_gemini_tutorial/features/complex_form/widgets/_dynamic_form_field.dart';
import 'package:provider/provider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class ComplexFormPage extends StatelessWidget {
  const ComplexFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Formulario Conversacional"),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: DotsIndicator(
                      dotsCount: controller.formFields.length,
                      position: controller.currentPage,
                      decorator: DotsDecorator(
                        activeColor: Theme.of(context).primaryColor,
                        color: Colors.grey.shade300,
                        size: const Size.square(9.0),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: controller.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.formFields.length,
                      itemBuilder: (context, index) {
                        final fieldModel = controller.formFields[index];
                        final isLastPage = index == controller.formFields.length - 1;

                        // --- SOLUCIÓN A LA LÓGICA DEL INFOBOX ---
                        // Leemos el valor directamente del estado del formulario.
                        // Como el `Consumer` reconstruye el widget en cada cambio
                        // (gracias a `notifyListeners`), este valor siempre estará actualizado.
                        final employmentStatusValue = controller
                            .formKey.currentState?.fields['employment_status']?.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DynamicFormField(fieldModel: fieldModel),

                              // Mostramos el InfoBox si el campo actual es el de empleo
                              // y si ya tiene un valor seleccionado.
                              if (fieldModel.name == 'employment_status' && employmentStatusValue != null)
                                _buildInfoBox(employmentStatusValue),

                              const SizedBox(height: 32),

                              if (isLastPage)
                                ElevatedButton.icon(
                                  icon: controller.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2, color: Colors.white))
                                      : const Icon(Icons.send),
                                  label: Text(controller.isLoading
                                      ? 'Enviando...'
                                      : 'Confirmar y Enviar'),
                                  onPressed: controller.isLoading
                                      ? null
                                      : controller.submitForm,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
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

  /// Método auxiliar para construir el InfoBox con una animación de entrada/salida.
  Widget _buildInfoBox(String? status) {
    final Widget box = switch (status) {
      'student' => const InfoBox(
          key: ValueKey('student_box'),
          text: '¡Genial! Al ser estudiante, tendrás acceso a descuentos especiales.',
          color: Colors.green,
        ),
      'unemployed' => const InfoBox(
          key: ValueKey('unemployed_box'),
          text: 'Podemos ayudarte a conectar con oportunidades laborales.',
          color: Colors.orange,
        ),
      _ => const SizedBox.shrink(key: ValueKey('empty_box')),
    };

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: box,
      ),
    );
  }
}