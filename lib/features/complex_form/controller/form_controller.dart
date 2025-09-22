// lib/features/complex_form/controller/form_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/submission_result_page.dart';
import '../model/service_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterizationFormController with ChangeNotifier {
  final formKey = GlobalKey<FormBuilderState>();
  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  List<ServiceModel> services = [];
  bool? isInReps;
  bool isLoading = false;
  
  // Clave para guardar en SharedPreferences
  static const String _draftKey = 'form_draft';

  CharacterizationFormController() {
    _loadDraft(); // Intentamos cargar un borrador al iniciar
    pageController.addListener(() {
      final newPage = pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        _currentPage = newPage;
        notifyListeners();
        _saveDraft(); // Guardamos el progreso al cambiar de página
      }
    });
  }
  
  // --- LÓGICA DE PERSISTENCIA DE ESTADO ---

  Future<void> _saveDraft() async {
    if (formKey.currentState == null) return;
    
    formKey.currentState!.save();
    final formData = formKey.currentState!.value;

    final draftData = {
      'currentPage': _currentPage,
      'formData': formData,
      'services': services.map((s) => {
        'nombre': s.nombre,
        'modalidad': s.modalidad,
        'infraestructura': {
          'departamento': s.infraestructura.departamento,
          'ciudad': s.infraestructura.ciudad,
          'direccion': s.infraestructura.direccion,
          'disposicionLocativa': s.infraestructura.disposicionLocativa,
          'tieneRetie': s.infraestructura.tieneRetie,
          'capacidadInstalada': s.infraestructura.capacidadInstalada.map((c) => {'tipo': c.tipo, 'finalidad': c.finalidad}).toList(),
        }
      }).toList(),
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, json.encode(draftData));
    print("Borrador guardado.");
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftString = prefs.getString(_draftKey);

    if (draftString != null) {
      final draftData = json.decode(draftString);
      
      // Cargamos los servicios
      if (draftData['services'] != null) {
        services = (draftData['services'] as List).map((s) => ServiceModel(
          nombre: s['nombre'],
          modalidad: s['modalidad'],
          infraestructura: Infraestructura(
            departamento: s['infraestructura']['departamento'],
            ciudad: s['infraestructura']['ciudad'],
            direccion: s['infraestructura']['direccion'],
            disposicionLocativa: s['infraestructura']['disposicionLocativa'],
            tieneRetie: s['infraestructura']['tieneRetie'],
            capacidad: (s['infraestructura']['capacidadInstalada'] as List).map((c) => CapacidadInstalada(tipo: c['tipo'], finalidad: c['finalidad'])).toList(),
          ),
        )).toList();
      }
      
      // Cargamos los datos del formulario
      if (draftData['formData'] != null) {
        formKey.currentState?.patchValue(draftData['formData']);
        isInReps = formKey.currentState?.fields['isInReps']?.value;
      }
      
      // Navegamos a la página guardada
      if (draftData['currentPage'] != null && pageController.hasClients) {
        pageController.jumpToPage(draftData['currentPage']);
      }

      print("Borrador cargado.");
      notifyListeners();
    }
  }

  Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
    
    // Reseteamos el estado
    services.clear();
    isInReps = null;
    formKey.currentState?.reset();
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    print("Borrador eliminado.");
    notifyListeners();
  }

  // --- MÉTODOS EXISTENTES ---
  
  void onFieldChanged() {
    notifyListeners();
    _saveDraft(); // Guardamos el progreso al cambiar un campo
  }

  void setIsInReps(bool? value) {
    if (isInReps != value) {
      isInReps = value;
      notifyListeners();
      _saveDraft();
    }
  }

  void addService(ServiceModel service) {
    services.add(service);
    notifyListeners();
    _saveDraft();
  }
  
  void removeService(ServiceModel service) {
    services.remove(service);
    notifyListeners();
    _saveDraft();
  }
  
  void updateService(int index, ServiceModel service) {
    if (index >= 0 && index < services.length) {
      services[index] = service;
      notifyListeners();
      _saveDraft();
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
    // ... (La lógica de construcción del JSON se mantiene igual)
    // ...
    // Al final, después del éxito, limpiamos el borrador.
    try {
      // ... (tu lógica de envío)
      await clearDraft(); // Limpia el borrador después de un envío exitoso
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const SubmissionResultPage(success: true, message: 'Tu caracterización ha sido registrada correctamente.'),
      ));
    } catch (e) {
      // ... (tu manejo de errores)
    }
  }
}