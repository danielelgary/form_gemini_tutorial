// lib/features/complex_form/controller/form_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/real_form_model.dart';
import 'package:form_gemini_tutorial/features/complex_form/repository/form_repository.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/submission_result_page.dart';
import '../model/service_model_improved.dart';

class CharacterizationFormController with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  final PageController pageController = PageController();
  final FormRepository _formRepository = FormRepository();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Map<String, String> _serverErrors = {};
  Map<String, String> get serverErrors => _serverErrors;

  List<ServiceModel> services = [];
  bool? isInReps;

  CharacterizationFormController() {
    pageController.addListener(() {
      final newPage = pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        _currentPage = newPage;
        notifyListeners();
      }
    });
  }

  void clearError(String fieldName) {
    if (_serverErrors.containsKey(fieldName)) {
      _serverErrors.remove(fieldName);
      notifyListeners();
    }
  }

  void setIsInReps(bool? value) {
    if (isInReps != value) {
      isInReps = value;
      notifyListeners();
    }
  }

  void addService(ServiceModel service) {
    services.add(service);
    notifyListeners();
  }

  void removeService(ServiceModel service) {
    services.remove(service);
    notifyListeners();
  }

  void updateService(int index, ServiceModel service) {
    if (index >= 0 && index < services.length) {
      services[index] = service;
      notifyListeners();
    }
  }

  void nextPage() {
    if (formKey.currentState?.saveAndValidate(focusOnInvalid: false) ?? false) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> submitForm(BuildContext context) async {
    _serverErrors = {}; // Limpiar errores anteriores
    if (formKey.currentState?.saveAndValidate(focusOnInvalid: false) ?? false) {
      _isSubmitting = true;
      notifyListeners();

      try {
        final formData = formKey.currentState!.value;

        final submissionModel = RealFormModel(
          fullName: formData['fullName'],
          identification: formData['identification'],
          providerType: formData['providerType'],
          isInReps: formData['isInReps'],
          services: services,
          createdAt: DateTime.now(),
        );

        final result = await _formRepository.submitForm(submissionModel);

        if (context.mounted) {
          if (result.success) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => SubmissionResultPage(
                  success: true,
                  message: result.message,
                  submissionId: result.submissionId,
                ),
              ),
              (route) => route.isFirst,
            );
          } else {
            if (result.errors != null) {
              // Procesar y almacenar errores del servidor
              result.errors!.forEach((field, messages) {
                if (messages.isNotEmpty) {
                  _serverErrors[field] = messages.first;
                }
              });
              // Volver a la primera página para mostrar el error
              pageController.jumpToPage(0);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${result.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ocurrió un error inesperado: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        _isSubmitting = false;
        notifyListeners();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrige los errores en el formulario.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}