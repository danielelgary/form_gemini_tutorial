// lib/features/complex_form/controller/form_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../model/form_field_model.dart'; // ¡Importamos nuestro nuevo modelo!

class FormController with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  final PageController pageController = PageController();

  bool isLoading = false;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // --- ¡NUEVO! La lista de preguntas que define nuestro formulario ---
  late final List<FormFieldModel> formFields;

  FormController() {
    _initializeFormFields(); // Inicializamos la lista
    pageController.addListener(() {
      final newPage = pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        _currentPage = newPage;
        notifyListeners();
      }
    });
  }

  // Aquí definimos la estructura completa de nuestro formulario
  void _initializeFormFields() {
    formFields = [
      FormFieldModel(
        name: 'full_name',
        label: 'Primero, ¿cuál es tu nombre completo?',
        type: FieldType.text,
        icon: Icons.person,
        validator: FormBuilderValidators.required(),
      ),
      FormFieldModel(
        name: 'email',
        label: 'Genial, ahora tu correo electrónico.',
        type: FieldType.email,
        icon: Icons.email,
        // --- ESTA PARTE AHORA ES VÁLIDA ---
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(
            errorText: 'El correo es obligatorio.',
          ),
          FormBuilderValidators.email(
                errorText: 'El formato del correo no es válido.',
              )
              as FormFieldValidator<Object>,
        ]),
      ),
      // --- NUEVA PREGUNTA AÑADIDA AQUÍ ---
      FormFieldModel(
        name: 'country',
        label: '¿En qué país resides?',
        type: FieldType.radio,
        optionsMap: const {
          // <-- Usando la nueva propiedad
          'colombia': 'Colombia',
          'mexico': 'México',
          'argentina': 'Argentina',
          'other': 'Otro',
        },
        validator: FormBuilderValidators.required(
          errorText: 'Por favor, selecciona tu país.',
        ),
      ),

      FormFieldModel(
        name: 'employment_status',
        label: '¿Cuál es tu situación laboral actual?',
        type: FieldType.radio,
        // --- LÓGICA MODIFICADA ---
        // Usamos el nuevo mapa con las traducciones
        optionsMap: const {
          'employed': 'Empleado',
          'unemployed': 'Desempleado',
          'student': 'Estudiante',
        },
        validator: FormBuilderValidators.required(),
      ),
      // Podríamos añadir campos condicionales aquí. Por ejemplo, si el anterior
      // fue 'employed', el siguiente campo sería 'company_name'.
      FormFieldModel(
        name: 'accept_terms',
        label: 'Para terminar, ¿aceptas los Términos y Condiciones?',
        type: FieldType.checkbox,
        validator: FormBuilderValidators.equal(
          true,
          errorText: 'Debes aceptar los términos.',
        ),
      ),
    ];
  }

  void onFieldChanged() {
    // Esta es la línea clave. Notifica a todos los widgets `Consumer`
    // para que se reconstruyan y puedan mostrar los datos más recientes.
    notifyListeners();
  }

  void validateAndNext() {
    // Este método ahora solo se enfoca en validar y avanzar de página.
    final currentFieldName = formFields[_currentPage].name;
    final field = formKey.currentState?.fields[currentFieldName];

    if (field != null && field.validate()) {
      field.save();

      if (_currentPage < formFields.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> submitForm() async {
    // Primero, validamos todo el formulario por si acaso.
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading = true;
      notifyListeners();

      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simula una llamada de red

      print("✅ Formulario enviado con éxito: ${formKey.currentState?.value}");

      isLoading = false;
      notifyListeners();
    } else {
      print("❌ Error: El formulario no es válido.");
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
