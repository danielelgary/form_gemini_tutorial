// lib/features/complex_form/controller/form_controller_improved.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../model/service_model.dart'; // Usar el modelo original por compatibilidad
import '../model/real_form_model.dart';
import '../repository/form_repository.dart';

/// Estados posibles del formulario
enum FormState {
  initial,
  loading,
  loaded,
  submitting,
  submitted,
  error,
  validating,
}

/// Controller mejorado con gestión de estado robusta
class CharacterizationFormControllerImproved with ChangeNotifier {
  final FormRepository _repository;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final PageController pageController = PageController();

  // Estado actual
  FormState _state = FormState.initial;
  FormState get state => _state;

  // Datos
  int _currentPage = 0;
  int get currentPage => _currentPage;

  List<ServiceModel> _services = [];
  List<ServiceModel> get services => List.unmodifiable(_services);

  bool? _isInReps;
  bool? get isInReps => _isInReps;

  // Datos auxiliares
  List<String> _availableServices = [];
  List<String> get availableServices => List.unmodifiable(_availableServices);

  Map<String, List<String>> _locationsData = {};
  Map<String, List<String>> get locationsData => Map.unmodifiable(_locationsData);

  // Manejo de errores
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, List<String>>? _validationErrors;
  Map<String, List<String>>? get validationErrors => _validationErrors;

  // Progreso del formulario
  double _progress = 0.0;
  double get progress => _progress;

  // Control de auto-guardado
  bool _autoSaveEnabled = true;
  bool get autoSaveEnabled => _autoSaveEnabled;

  CharacterizationFormControllerImproved({FormRepository? repository})
      : _repository = repository ?? FormRepository() {
    _initializeController();
  }

  /// Inicialización del controller
  Future<void> _initializeController() async {
    pageController.addListener(_onPageChanged);
    await loadInitialData();
    await _loadDraftIfExists();
  }

  /// Carga datos iniciales desde el backend (método público)
  Future<void> loadInitialData() async {
    _setState(FormState.loading);
    
    try {
      // Cargar servicios disponibles y ubicaciones en paralelo
      final results = await Future.wait([
        _repository.getAvailableServices(),
        _repository.getLocationsData(),
      ]);
      
      _availableServices = results[0] as List<String>;
      _locationsData = results[1] as Map<String, List<String>>;
      
      _setState(FormState.loaded);
    } catch (e) {
      _setError('Error cargando datos: ${e.toString()}');
    }
  }

  /// Maneja cambios de página
  void _onPageChanged() {
    final newPage = pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      _currentPage = newPage;
      _updateProgress();
      
      // Auto-guardar al cambiar de página
      if (_autoSaveEnabled) {
        _autoSaveDraft();
      }
      
      notifyListeners();
    }
  }

  /// Actualiza el progreso del formulario
  void _updateProgress() {
    const totalPages = 12; // Ajusta según tu formulario
    _progress = (_currentPage + 1) / totalPages;
  }

  /// Establece si está en REPS
  void setIsInReps(bool? value) {
    if (_isInReps != value) {
      _isInReps = value;
      clearValidationErrors();
      notifyListeners();
      
      if (_autoSaveEnabled) {
        _autoSaveDraft();
      }
    }
  }

  /// Método para manejar cambios en campos del formulario
  void onFieldChanged(String fieldName, dynamic value) {
    // Limpiar errores de validación para el campo específico
    if (_validationErrors?.containsKey(fieldName) == true) {
      _validationErrors!.remove(fieldName);
      notifyListeners();
    }
    
    // Auto-guardar si está habilitado
    if (_autoSaveEnabled) {
      _autoSaveDraft();
    }
  }

  /// Valida y navega a la siguiente página
  Future<bool> validateAndNext() async {
    if (!_validateCurrentPage()) {
      return false;
    }
    
    if (formKey.currentState?.saveAndValidate(focusOnInvalid: false) ?? false) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      return true;
    }
    
    return false;
  }

  /// Agrega un servicio con validación
  Future<bool> addService(ServiceModel service) async {
    _setState(FormState.validating);
    
    try {
      // Verificar duplicados
      if (_services.any((s) => s.nombre == service.nombre && 
                             s.modalidad == service.modalidad)) {
        _setError('Este servicio ya fue agregado');
        return false;
      }
      
      // Validar en el backend (simulado por ahora)
      await Future.delayed(const Duration(milliseconds: 500));
      
      _services.add(service);
      clearErrors();
      _setState(FormState.loaded);
      
      if (_autoSaveEnabled) {
        _autoSaveDraft();
      }
      
      return true;
    } catch (e) {
      _setError('Error agregando servicio: ${e.toString()}');
      return false;
    }
  }

  /// Remueve un servicio
  void removeService(ServiceModel service) {
    _services.remove(service);
    clearErrors();
    notifyListeners();
    
    if (_autoSaveEnabled) {
      _autoSaveDraft();
    }
  }

  /// Actualiza un servicio existente
  Future<bool> updateService(int index, ServiceModel service) async {
    if (index < 0 || index >= _services.length) {
      _setError('Índice de servicio inválido');
      return false;
    }
    
    _setState(FormState.validating);
    
    try {
      // Simular validación en backend
      await Future.delayed(const Duration(milliseconds: 500));
      
      _services[index] = service;
      clearErrors();
      _setState(FormState.loaded);
      
      if (_autoSaveEnabled) {
        _autoSaveDraft();
      }
      
      return true;
    } catch (e) {
      _setError('Error actualizando servicio: ${e.toString()}');
      return false;
    }
  }

  /// Navega a la siguiente página
  Future<bool> nextPage() async {
    return await validateAndNext();
  }

  /// Navega a la página anterior
  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  /// Valida la página actual
  bool _validateCurrentPage() {
    clearValidationErrors();
    
    // Validaciones específicas por página
    switch (_currentPage) {
      case 0: // Página inicial
        if (_isInReps == null) {
          _setValidationErrors({
            'isInReps': ['Debe seleccionar si está en REPS']
          });
          return false;
        }
        break;
      
      case 8: // Página de servicios
        if (_services.isEmpty) {
          _setValidationErrors({
            'services': ['Debe agregar al menos un servicio']
          });
          return false;
        }
        break;
    }
    
    return true;
  }

  /// Envía el formulario al backend
  Future<FormSubmissionResult?> submitForm() async {
    _setState(FormState.submitting);
    
    try {
      if (!_validateCompleteForm()) {
        _setState(FormState.error);
        return null;
      }
      
      final formData = _buildFormData();
      final result = await _repository.submitForm(formData);
      
      if (result.success) {
        _setState(FormState.submitted);
        await _clearDraft(); // Limpiar borrador después del envío exitoso
      } else {
        _setError(result.message);
        if (result.errors != null) {
          _setValidationErrors(result.errors!);
        }
      }
      
      return result;
    } catch (e) {
      _setError('Error enviando formulario: ${e.toString()}');
      return null;
    }
  }

  /// Construye el modelo de datos del formulario
  RealFormModel _buildFormData() {
    final formValues = formKey.currentState?.value ?? {};
    
    return RealFormModel(
      isInReps: _isInReps,
      nombres: formValues['nombres'],
      apellidos: formValues['apellidos'],
      documento: formValues['documento'],
      email: formValues['email'],
      telefono: formValues['telefono'],
      services: _services,
      createdAt: DateTime.now(),
      isDraft: false,
    );
  }

  /// Valida el formulario completo
  bool _validateCompleteForm() {
    final errors = <String, List<String>>{};
    
    // Validar formulario
    if (!(formKey.currentState?.saveAndValidate(focusOnInvalid: false) ?? false)) {
      errors['form'] = ['Hay errores en el formulario'];
    }
    
    // Validar REPS
    if (_isInReps == null) {
      errors['isInReps'] = ['Debe seleccionar si está en REPS'];
    }
    
    // Validar servicios
    if (_services.isEmpty) {
      errors['services'] = ['Debe agregar al menos un servicio'];
    }
    
    if (errors.isNotEmpty) {
      _setValidationErrors(errors);
      return false;
    }
    
    return true;
  }

  /// Guarda borrador automáticamente
  Future<void> _autoSaveDraft() async {
    if (_state == FormState.submitting || _state == FormState.submitted) {
      return;
    }
    
    try {
      final formData = _buildFormData().copyWith(isDraft: true);
      await _repository.saveDraft(formData);
    } catch (e) {
      // Error silencioso para auto-guardado
      debugPrint('Error auto-guardando: $e');
    }
  }

  /// Carga borrador existente
  Future<void> _loadDraftIfExists() async {
    try {
      final drafts = await _repository.getDrafts();
      if (drafts.isNotEmpty) {
        final latestDraft = drafts.first;
        _services = latestDraft.services.toList();
        _isInReps = latestDraft.isInReps;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cargando borrador: $e');
    }
  }

  /// Limpia el borrador guardado
  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('form_draft');
  }

  /// Alterna auto-guardado
  void toggleAutoSave() {
    _autoSaveEnabled = !_autoSaveEnabled;
    notifyListeners();
  }

  /// Reinicia el formulario
  void resetForm() {
    _services.clear();
    _isInReps = null;
    _currentPage = 0;
    _progress = 0.0;
    clearErrors();
    formKey.currentState?.reset();
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    notifyListeners();
  }

  // Métodos de gestión de estado
  void _setState(FormState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = FormState.error;
    notifyListeners();
  }

  void _setValidationErrors(Map<String, List<String>> errors) {
    _validationErrors = errors;
    _state = FormState.error;
    notifyListeners();
  }

  void clearErrors() {
    _errorMessage = null;
    _validationErrors = null;
    if (_state == FormState.error) {
      _state = FormState.loaded;
    }
    notifyListeners();
  }

  void clearValidationErrors() {
    _validationErrors = null;
  }

  // Getters de utilidad
  bool get isLoading => _state == FormState.loading;
  bool get isSubmitting => _state == FormState.submitting;
  bool get isValidating => _state == FormState.validating;
  bool get hasError => _state == FormState.error;
  bool get isSubmitted => _state == FormState.submitted;
  bool get canNavigateNext => !isLoading && !isSubmitting && !isValidating;
  bool get canSubmit => _services.isNotEmpty && _isInReps != null && !hasError;

  @override
  void dispose() {
    pageController.removeListener(_onPageChanged);
    pageController.dispose();
    super.dispose();
  }
}