// features/complex_form/controller/form_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormController with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  // Middleware de validación que veremos en el siguiente punto
  final List<String? Function(Map<String, dynamic>)> _validationMiddlewares = [
    // ...
  ];

  Future<void> submitForm() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading = true;
      notifyListeners(); // Notifica a la UI que muestre un loader

      final formData = formKey.currentState!.value;

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

      Future<void> submitForm() async {
        if (formKey.currentState?.saveAndValidate() ?? false) {
          isLoading = true;
          notifyListeners();

          final formData = formKey.currentState!.value;

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
    }
  }
}
