// lib/features/complex_form/view/sedes_section_page.dart
import 'package:flutter/material.dart';
import 'package:form_gemini_tutorial/features/complex_form/controller/form_controller.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/sede_model.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/sede_form_page.dart';
import 'package:provider/provider.dart';

class SedesSectionPage extends StatelessWidget {
  const SedesSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CharacterizationFormController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sedes (Paso 9 de X)",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_business),
              label: const Text("Añadir Nueva Sede"),
              onPressed: () async {
                final Sede? nuevaSede = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SedeFormPage()),
                );
                if (nuevaSede != null) {
                  controller.addSede(nuevaSede);
                }
              },
            ),
            const SizedBox(height: 16),
            Text("Sedes añadidas: ${controller.sedes.length}", style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: controller.sedes.length,
                itemBuilder: (context, index) {
                  final sede = controller.sedes[index];
                  return Card(
                    child: ListTile(
                      title: Text(sede.toString()),
                      subtitle: Text("Capacidad: ${sede.capacidadInstalada.length} items"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              final Sede? sedeActualizada = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => SedeFormPage(sedeToEdit: sede, sedeIndex: index)),
                              );
                              if (sedeActualizada != null) {
                                controller.updateSede(index, sedeActualizada);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                            onPressed: () => controller.removeSede(sede),
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
      ),
    );
  }
}