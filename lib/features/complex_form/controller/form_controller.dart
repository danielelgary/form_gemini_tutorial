// lib/features/complex_form/controller/form_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../model/service_model.dart'; // Importamos el nuevo modelo de Servicio

class CharacterizationFormController with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  // El estado principal ahora es una lista de servicios
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
  
  void setIsInReps(bool value) {
    isInReps = value;
    notifyListeners();
  }

  // --- Métodos para gestionar la lista de servicios ---
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

  Future<void> submitForm() async {
    if (formKey.currentState?.saveAndValidate(focusOnInvalid: false) ?? false) {
      final formData = formKey.currentState!.value;
      print("--- FORMULARIO A ENVIAR ---");
      print("Datos principales:");
      print(formData);
      print("--- Servicios Añadidos (${services.length}) ---");
      for (var service in services) {
        print("- Servicio: ${service.nombre}");
        print("  Modalidad: ${service.modalidad}");
        print("  Infraestructura: ${service.infraestructura.direccion}");
        print("  Capacidad: ${service.infraestructura.capacidadInstalada.length} items");
      }
      print("--------------------------");
    } else {
      print("El formulario contiene errores.");
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}