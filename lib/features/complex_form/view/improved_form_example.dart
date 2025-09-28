// lib/features/complex_form/view/improved_form_example.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../controller/form_controller_improved.dart';
import '../widgets/loading_overlay.dart';
import '../model/service_model.dart'; // Usar modelo original

/// Ejemplo de implementación de la página de formulario mejorada
class ImprovedFormExample extends StatelessWidget {
  const ImprovedFormExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterizationFormControllerImproved(),
      child: const _FormContent(),
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterizationFormControllerImproved>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Formulario Mejorado'),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(6),
              child: ProgressIndicatorWidget(
                progress: controller.progress,
                color: Colors.white,
              ),
            ),
            actions: [
              // Botón de auto-guardado
              IconButton(
                onPressed: controller.toggleAutoSave,
                icon: Icon(
                  controller.autoSaveEnabled 
                      ? Icons.save 
                      : Icons.save_outlined,
                ),
                tooltip: controller.autoSaveEnabled 
                    ? 'Auto-guardado activado'
                    : 'Auto-guardado desactivado',
              ),
              // Botón de reinicio
              IconButton(
                onPressed: () => _showResetDialog(context, controller),
                icon: const Icon(Icons.refresh),
                tooltip: 'Reiniciar formulario',
              ),
            ],
          ),
          body: LoadingOverlay(
            isLoading: controller.isLoading,
            message: _getLoadingMessage(controller),
            child: Column(
              children: [
                // Mostrar errores si los hay
                if (controller.hasError)
                  ErrorDisplay(
                    message: controller.errorMessage,
                    fieldErrors: controller.validationErrors,
                    onRetry: () => controller.loadInitialData(),
                    onDismiss: () => controller.clearErrors(),
                  ),
                
                Expanded(
                  child: FormBuilder(
                    key: controller.formKey,
                    child: PageView(
                      controller: controller.pageController,
                      children: [
                        _buildWelcomePage(context, controller),
                        _buildPersonalInfoPage(context, controller),
                        _buildServicesPage(context, controller),
                        _buildSummaryPage(context, controller),
                      ],
                    ),
                  ),
                ),
                
                // Barra de navegación
                _buildNavigationBar(context, controller),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Página de bienvenida
  Widget _buildWelcomePage(BuildContext context, CharacterizationFormControllerImproved controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            '¿Está registrado en REPS?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'REPS (Registro Especial de Prestadores de Servicios de Salud)',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          FormBuilderRadioGroup<bool>(
            name: 'is_in_reps',
            decoration: const InputDecoration(
              labelText: 'Estado REPS',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              controller.setIsInReps(value);
              controller.onFieldChanged('is_in_reps', value);
            },
            validator: FormBuilderValidators.required(
              errorText: 'Debe seleccionar una opción',
            ),
            options: const [
              FormBuilderFieldOption(
                value: true,
                child: Text('Sí, estoy registrado en REPS'),
              ),
              FormBuilderFieldOption(
                value: false,
                child: Text('No, no estoy registrado en REPS'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          if (controller.isInReps != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: controller.isInReps! 
                    ? Colors.green.shade50 
                    : Colors.orange.shade50,
                border: Border.all(
                  color: controller.isInReps! 
                      ? Colors.green.shade200 
                      : Colors.orange.shade200,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.isInReps!
                    ? 'Perfecto. Procederemos con el formulario completo.'
                    : 'Entendido. Le ayudaremos con el proceso de registro.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: controller.isInReps! 
                      ? Colors.green.shade800 
                      : Colors.orange.shade800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Página de información personal
  Widget _buildPersonalInfoPage(BuildContext context, CharacterizationFormControllerImproved controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Información Personal',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            FormBuilderTextField(
              name: 'nombres',
              decoration: const InputDecoration(
                labelText: 'Nombres completos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) => controller.onFieldChanged('nombres', value),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Los nombres son requeridos'),
                FormBuilderValidators.minLength(2, errorText: 'Mínimo 2 caracteres'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'apellidos',
              decoration: const InputDecoration(
                labelText: 'Apellidos completos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              onChanged: (value) => controller.onFieldChanged('apellidos', value),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Los apellidos son requeridos'),
                FormBuilderValidators.minLength(2, errorText: 'Mínimo 2 caracteres'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'documento',
              decoration: const InputDecoration(
                labelText: 'Número de documento',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => controller.onFieldChanged('documento', value),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'El documento es requerido'),
                FormBuilderValidators.numeric(errorText: 'Solo números'),
                FormBuilderValidators.minLength(6, errorText: 'Mínimo 6 dígitos'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'email',
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => controller.onFieldChanged('email', value),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'El email es requerido'),
                FormBuilderValidators.email(errorText: 'Ingrese un email válido'),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'telefono',
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
                hintText: '300XXXXXXX',
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) => controller.onFieldChanged('telefono', value),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'El teléfono es requerido'),
                FormBuilderValidators.numeric(errorText: 'Solo números'),
                FormBuilderValidators.minLength(10, errorText: 'Mínimo 10 dígitos'),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  /// Página de servicios
  Widget _buildServicesPage(BuildContext context, CharacterizationFormControllerImproved controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Servicios de Salud',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          // Lista de servicios agregados
          if (controller.services.isNotEmpty) ..[
            Text(
              'Servicios agregados (${controller.services.length}):',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index];
                  return Card(
                    child: ListTile(
                      title: Text(service.nombre),
                      subtitle: Text('${service.modalidad}\n${service.infraestructura}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removeService(service),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ..[
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay servicios agregados',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Agregue al menos un servicio para continuar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          ElevatedButton.icon(
            onPressed: () => _showAddServiceDialog(context, controller),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Servicio'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  /// Página de resumen
  Widget _buildSummaryPage(BuildContext context, CharacterizationFormControllerImproved controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Resumen del Formulario',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSummaryCard(
                    context,
                    'Estado REPS',
                    controller.isInReps == true ? 'Registrado' : 'No registrado',
                    Icons.verified_user,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildSummaryCard(
                    context,
                    'Servicios',
                    '${controller.services.length} servicio(s) agregado(s)',
                    Icons.medical_services,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (controller.isSubmitting)
                    const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Enviando formulario...'),
                        ],
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: controller.canSubmit 
                          ? () => _submitForm(context, controller)
                          : null,
                      icon: const Icon(Icons.send),
                      label: const Text('Enviar Formulario'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye una tarjeta de resumen
  Widget _buildSummaryCard(BuildContext context, String title, String content, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Barra de navegación
  Widget _buildNavigationBar(BuildContext context, CharacterizationFormControllerImproved controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (controller.currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: controller.previousPage,
                child: const Text('Anterior'),
              ),
            ),
          
          if (controller.currentPage > 0) const SizedBox(width: 16),
          
          Expanded(
            child: ElevatedButton(
              onPressed: controller.canNavigateNext 
                  ? () async {
                      if (controller.currentPage < 3) {
                        await controller.validateAndNext();
                      }
                    }
                  : null,
              child: Text(
                controller.currentPage < 3 ? 'Siguiente' : 'Finalizar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Diálogo para agregar servicio
  Future<void> _showAddServiceDialog(BuildContext context, CharacterizationFormControllerImproved controller) async {
    // Implementar diálogo de agregar servicio
    // Por ahora, agregar un servicio de ejemplo
    final service = ServiceModel(
      nombre: 'Consulta Externa',
      modalidad: 'Presencial',
      infraestructura: Infraestructura(
        departamento: 'Antioquia',
        ciudad: 'Medellín',
        direccion: 'Calle 123 #45-67',
      ),
    );
    
    await controller.addService(service);
  }

  /// Envía el formulario
  Future<void> _submitForm(BuildContext context, CharacterizationFormControllerImproved controller) async {
    final result = await controller.submitForm();
    
    if (result != null && result.success) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: Text(result.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  /// Diálogo de confirmación para reiniciar
  Future<void> _showResetDialog(BuildContext context, CharacterizationFormControllerImproved controller) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reiniciar Formulario'),
        content: const Text('¿Está seguro de que desea reiniciar el formulario? Se perderán todos los datos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      controller.resetForm();
    }
  }

  /// Obtiene el mensaje de carga apropiado
  String _getLoadingMessage(CharacterizationFormControllerImproved controller) {
    if (controller.isSubmitting) return 'Enviando formulario...';
    if (controller.isValidating) return 'Validando...';
    return 'Cargando...';
  }
}