# 🚀 HabiGO - Formulario Avanzado con Flutter

> **Proyecto mejorado de formularios complejos con integración backend, validaciones robustas y mejores prácticas de desarrollo.**

## 💫 Características Principales

### ✅ **Arquitectura Robusta**
- **Clean Architecture** con separación clara de responsabilidades
- **Patrón Repository** para abstracción de datos
- **Gestión de estado** avanzada con Provider + ChangeNotifier
- **Inyección de dependencias** para mejor testeo

### 🌐 **Comunicación Backend**
- **Cliente HTTP robusto** con Dio
- **Interceptores** para autenticación, logging y manejo de errores
- **Manejo de errores centralizado** con mensajes amigables
- **Fallback a datos mock** durante desarrollo

### 📝 **Formularios Avanzados**
- **Validación en tiempo real** en frontend y backend
- **Auto-guardado** de borradores
- **Progreso visual** del formulario
- **Navegación inteligente** entre páginas

### 💱 **UX/UI Mejorada**
- **Estados de carga** con overlays y mensajes
- **Manejo de errores** con UI amigable
- **Indicadores de progreso** visuales
- **Componentes reutilizables** para consistencia

## 📁 Estructura del Proyecto

```
lib/
├── core/                          # Core de la aplicación
│   └── network/                   # Configuración de red
│       ├── api_client.dart        # Cliente HTTP principal
│       └── api_interceptors.dart  # Interceptores HTTP
│
├── features/                       # Features por dominio
│   └── complex_form/              # Feature de formularios
│       ├── controller/            # Lógica de negocio
│       │   ├── form_controller.dart
│       │   └── form_controller_improved.dart
│       │
│       ├── data/                  # Datos mock
│       │   └── mock_services.dart
│       │
│       ├── model/                 # Modelos de datos
│       │   ├── service_model.dart
│       │   ├── service_model_improved.dart
│       │   └── real_form_model.dart
│       │
│       ├── repository/            # Capa de datos
│       │   └── form_repository.dart
│       │
│       ├── view/                  # Pantallas
│       │   ├── improved_form_example.dart
│       │   └── [...otras pantallas]
│       │
│       └── widgets/               # Widgets reutilizables
│           └── loading_overlay.dart
│
├── main.dart                       # Punto de entrada
└── welcome_screen.dart            # Pantalla de bienvenida
```

## 🔧 Tecnologías y Dependencias

### **Principales**
- **Flutter SDK** ^3.9.0
- **Dio** ^5.4.3+1 - Cliente HTTP avanzado
- **Provider** ^6.1.2 - Gestión de estado
- **SharedPreferences** ^2.2.3 - Persistencia local

### **Formularios**
- **flutter_form_builder** ^10.2.0 - Constructor de formularios
- **form_builder_validators** ^11.2.0 - Validadores predefinidos

### **Desarrollo**
- **json_serializable** ^6.7.1 - Generación de código JSON
- **build_runner** ^2.4.9 - Herramientas de build
- **mockito** ^5.4.4 - Testing con mocks

## 🚀 Comenzando

### **1. Instalar Dependencias**
```bash
flutter pub get
```

### **2. Generar Código JSON** (si usas los modelos mejorados)
```bash
flutter packages pub run build_runner build
```

### **3. Configurar Backend**
En `lib/core/network/api_client.dart`, actualiza la URL base:
```dart
static const String _baseUrl = 'https://tu-api.com'; // ← Cambia esto
```

### **4. Ejecutar la App**
```bash
flutter run
```

## 📚 Conceptos Clave Implementados

### **1. Clean Architecture**
```
Presentación (View) ↔ Lógica (Controller) ↔ Datos (Repository) ↔ Fuente Externa (API)
```

- **View**: UI y interacción del usuario
- **Controller**: Lógica de negocio y gestión de estado
- **Repository**: Abstracción de fuentes de datos
- **Models**: Representación de datos con validaciones

### **2. Gestión de Estado**
```dart
// Controller con estados bien definidos
enum FormState {
  initial, loading, loaded, submitting, submitted, error, validating
}

class CharacterizationFormController with ChangeNotifier {
  FormState _state = FormState.initial;
  
  void _setState(FormState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners(); // Notifica cambios a la UI
    }
  }
}
```

### **3. Comunicación con Backend**
```dart
// Ejemplo de envío de formulario
Future<FormSubmissionResult> submitForm(RealFormModel formData) async {
  try {
    final jsonData = _prepareFormDataForSubmission(formData);
    
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/api/forms/characterization/submit',
      data: jsonData,
    );
    
    return FormSubmissionResult.fromJson(response.data!);
  } catch (e) {
    return FormSubmissionResult(
      success: false,
      message: 'Error: ${e.toString()}',
    );
  }
}
```

### **4. Estructura JSON de Envío**
```json
{
  "form_data": {
    "is_in_reps": true,
    "nombres": "Juan",
    "apellidos": "Pérez",
    "documento": "12345678",
    "email": "juan@example.com",
    "telefono": "3001234567"
  },
  "services": [
    {
      "id": null,
      "nombre": "Consulta Externa",
      "codigo_cups": "890201",
      "modalidad": "Presencial",
      "descripcion": "Consulta médica general",
      "infraestructura": {
        "departamento": "Antioquia",
        "ciudad": "Medellín",
        "direccion": "Calle 123 #45-67",
        "codigo_postal": "050001",
        "disposicion_locativa": "primer_piso",
        "tiene_retie": true,
        "capacidad_instalada": [
          {
            "tipo": "consultorio",
            "finalidad": "Medicina General",
            "cantidad": 2,
            "area_metros_cuadrados": 15.5
          }
        ]
      },
      "estado": "activo"
    }
  ],
  "submission_timestamp": "2025-09-28T23:30:00.000Z",
  "app_version": "1.0.0",
  "platform": "flutter"
}
```

## 🧪 Mejores Prácticas Implementadas

### **✅ Validación Doble**
```dart
// 1. Validación local inmediata
final localErrors = service.validate();
if (localErrors.isNotEmpty) {
  _setValidationErrors({'service': localErrors});
  return false;
}

// 2. Validación en backend
final validationResult = await _repository.validateService(service);
if (!validationResult.isValid) {
  _setError(validationResult.message);
  return false;
}
```

### **✅ Manejo de Errores Robusto**
```dart
/// Manejo centralizado de errores HTTP
Exception _handleError(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkException('Tiempo de conexión agotado');
      case DioExceptionType.badResponse:
        return ServerException(
          'Error del servidor: ${error.response?.statusCode}',
          statusCode: error.response?.statusCode,
        );
      // ... más casos
    }
  }
  return Exception('Error desconocido: $error');
}
```

### **✅ Auto-guardado Inteligente**
```dart
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
```

### **✅ UI Responsiva a Estados**
```dart
// UI que responde automáticamente a cambios de estado
Consumer<CharacterizationFormController>(
  builder: (context, controller, child) {
    return LoadingOverlay(
      isLoading: controller.isLoading,
      message: _getLoadingMessage(controller),
      child: Column(
        children: [
          if (controller.hasError)
            ErrorDisplay(
              message: controller.errorMessage,
              fieldErrors: controller.validationErrors,
              onRetry: () => controller._loadInitialData(),
            ),
          // ... resto de la UI
        ],
      ),
    );
  },
)
```

## 🧑‍💻 Cómo Usar las Mejoras

### **1. Reemplazar el Controller Actual**
```dart
// En lugar de usar FormController, usar:
import '../controller/form_controller_improved.dart';

// En tu widget:
ChangeNotifierProvider(
  create: (_) => CharacterizationFormController(),
  child: MyFormWidget(),
)
```

### **2. Implementar la Nueva UI**
```dart
// Usar el ejemplo mejorado como base:
import '../view/improved_form_example.dart';

// En tu app:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ImprovedFormExample(),
  ),
);
```

### **3. Configurar tu Backend**
Endpoints que debes implementar:

```
GET  /api/services/available           # Lista servicios disponibles
GET  /api/locations/colombia           # Departamentos y ciudades
POST /api/forms/characterization/submit # Envío del formulario
POST /api/forms/characterization/draft  # Guardar borrador
GET  /api/forms/characterization/drafts # Obtener borradores
POST /api/services/validate            # Validar servicio
```

## 🔍 Testing

### **Ejecutar Tests**
```bash
flutter test
```

### **Ejemplo de Test Unitario**
```dart
test('should add service successfully', () async {
  // Arrange
  final controller = CharacterizationFormController(
    repository: MockFormRepository(),
  );
  final service = ServiceModel(/* ... */);
  
  // Act
  final result = await controller.addService(service);
  
  // Assert
  expect(result, true);
  expect(controller.services.length, 1);
});
```

## 📝 Próximos Pasos

### **Mejoras Sugeridas**
- [ ] **Tests automatizados** completos
- [ ] **Offline support** con sincronización
- [ ] **Firma digital** en formularios
- [ ] **Notificaciones push** para estado del formulario
- [ ] **Analytics** de uso del formulario
- [ ] **Tema oscuro** y personalización

### **Integraciones Adicionales**
- [ ] **Firebase** para analytics y crashlytics
- [ ] **Auth0/Firebase Auth** para autenticación
- [ ] **PDF generation** para reportes
- [ ] **Geolocation** para dirección automática

## 👥 Contribuir

1. **Fork** el proyecto
2. Crea tu **feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. **Push** a la branch (`git push origin feature/AmazingFeature`)
5. Abre un **Pull Request**

## 📝 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

---

**🚀 ¡Tu formulario ahora es robusto, escalable y listo para producción!**