// features/complex_form/controller/form_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormController with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  // ¡NUEVO! PageController para controlar el carrusel
  final PageController pageController = PageController();
  // ¡NUEVO! Variable para saber en qué página estamos
  int _currentPage = 0;
  int get currentPage => _currentPage;

  final List<List<String>> fieldsByPage = [
    ['full_name', 'email'], // Página 0
    ['employment_status', 'company_name', 'ssn'], // Página 1
    ['accept_terms'], // Página 2
  ];

  FormController() {
    // ¡NUEVO! Escuchamos los cambios de página para actualizar la UI
    pageController.addListener(() {
      if (pageController.page?.round() != _currentPage) {
        _currentPage = pageController.page!.round();
        notifyListeners(); // Notificamos para que la UI (ej. el indicador de paso) se actualice
      }
    });
  }

  // ¡NUEVO! Método para ir a la siguiente página
  void nextPage() {
    final currentPageFields = fieldsByPage[_currentPage];
    bool isPageValid = true;

    // Itera y valida solo los campos de esta página
    for (final fieldName in currentPageFields) {
      final field = formKey.currentState?.fields[fieldName];
      if (field != null && !field.validate()) {
        isPageValid = false;
      }
    }

    if (isPageValid) {
      formKey.currentState?.save(); // Guarda el estado si es válido
        pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  // ¡NUEVO! Método para ir a la página anterior
  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> submitForm() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading = true;
      notifyListeners(); // Notifica a la UI que muestre un loader

      final formData = formKey.currentState!.value;
      print("Formulario válido con datos: $formData");

      // Ejecutar middleware
      // --- NUESTRO PIPELINE DE "MIDDLEWARE" ---
      // Regla 1
      String? validateColombianStudentRule(Map<String, dynamic> data) {
        if (data['country'] == 'Colombia' &&
            data['employment_status'] == 'student') {
          return "Regla de negocio: Estudiantes en Colombia no pueden aplicar ahora.";
        }
        return null; // Pasa la validación
      }

      // Regla 2
      String? validateAgeAndEmployment(Map<String, dynamic> data) {
        final int age = data['age'] ?? 0; // Suponiendo que hay un campo de edad
        if (age < 18 && data['employment_status'] == 'employed') {
          return "Los menores de 18 años no pueden registrarse como empleados.";
        }
        return null;
      }

      // Cada función es una regla de negocio.
      final List<String? Function(Map<String, dynamic>)> validationMiddlewares =
          [
            validateColombianStudentRule,
            validateAgeAndEmployment,
            // Puedes añadir tantas reglas como quieras...
          ];

      // --- EJECUTANDO EL MIDDLEWARE ---
      for (final rule in validationMiddlewares) {
        final errorMessage = rule(formData);
        if (errorMessage != null) {
          // Si una regla falla, detenemos el proceso
          print("Middleware falló: $errorMessage");
          // Aquí mostrarías el error al usuario (ej. con un SnackBar)
          isLoading = false;
          notifyListeners();
          return; // Detiene la ejecución del submit
        }
      }
    }
  }

  // ¡IMPORTANTE! No olvides limpiar los controladores
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
