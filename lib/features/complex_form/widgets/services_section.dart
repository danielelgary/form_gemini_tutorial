// lib/features/complex_form/widgets/services_section.dart
import 'package:flutter/material.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/real_form_model.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/service_form_page.dart';
import 'package:provider/provider.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en el controlador para redibujar la lista
    final controller = context.watch<RealFormController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Servicios Prestados", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          
          // Botón para añadir un nuevo servicio
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Añadir Servicio"),
            onPressed: () async {
              // Navegamos a la página del sub-formulario
              final newService = await Navigator.of(context).push<Service>(
                MaterialPageRoute(builder: (_) => const ServiceFormPage()),
              );
              // Si el usuario guardó un servicio, lo añadimos al controlador
              if (newService != null) {
                controller.addService(newService);
              }
            },
          ),
          const SizedBox(height: 16),
          
          Text("Servicios añadidos: ${controller.services.length}", style: Theme.of(context).textTheme.titleSmall),
          const Divider(),

          // La lista de servicios que ya se han añadido
          Expanded(
            child: ListView.builder(
              itemCount: controller.services.length,
              itemBuilder: (context, index) {
                final service = controller.services[index];
                return ListTile(
                  title: Text(service.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => controller.removeService(service),
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