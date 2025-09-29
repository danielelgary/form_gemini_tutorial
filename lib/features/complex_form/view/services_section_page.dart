// lib/features/complex_form/view/services_section_page.dart
import 'package:flutter/material.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/service_model_improved.dart';
// Este import dará error temporalmente hasta que creemos el siguiente archivo.
import 'package:form_gemini_tutorial/features/complex_form/view/service_form_page.dart'; 
import 'package:provider/provider.dart';

class ServicesSectionPage extends StatelessWidget {
  const ServicesSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CharacterizationFormController>();
    final title = controller.isInReps ?? false ? "Servicios Inscritos" : "Servicios a Inscribir";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            controller.isInReps ?? false 
            ? "Añade los servicios que ya tienes inscritos en el REPS."
            : "Añade los servicios que deseas inscribir. Para cada uno, deberás detallar la modalidad y la infraestructura.",
             style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("Añadir Servicio"),
              onPressed: () async {
                final ServiceModel? newService = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ServiceFormPage()),
                );
                if (newService != null) {
                  controller.addService(newService);
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          Text("Servicios añadidos: ${controller.services.length}", style: Theme.of(context).textTheme.titleMedium),
          const Divider(),
          Expanded(
            child: controller.services.isEmpty
            ? const Center(child: Text("Aún no has añadido ningún servicio."))
            : ListView.builder(
              itemCount: controller.services.length,
              itemBuilder: (context, index) {
                final service = controller.services[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.medical_services_outlined),
                    title: Text(service.toString()),
                    subtitle: Text(service.infraestructura.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () async {
                            final ServiceModel? updatedService = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ServiceFormPage(serviceToEdit: service)),
                            );
                            if (updatedService != null) {
                              controller.updateService(index, updatedService);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                          onPressed: () => controller.removeService(service),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}