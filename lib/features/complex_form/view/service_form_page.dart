// lib/features/complex_form/view/service_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/service_model_improved.dart';
import 'package:form_gemini_tutorial/features/complex_form/view/service_search_page.dart';

class ServiceFormPage extends StatefulWidget {
  final ServiceModel? serviceToEdit;

  const ServiceFormPage({super.key, this.serviceToEdit});

  @override
  State<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  final _serviceFormKey = GlobalKey<FormBuilderState>();
  late List<CapacidadInstalada> _capacidadInstalada;

  @override
  void initState() {
    super.initState();
    _capacidadInstalada = List<CapacidadInstalada>.from(widget.serviceToEdit?.infraestructura.capacidadInstalada ?? []);
  }

  void _saveAndReturn() {
    if (_serviceFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = _serviceFormKey.currentState!.value;

      final newService = ServiceModel(
        nombre: formData['nombre_servicio'],
        modalidad: formData['modalidad'],
        infraestructura: Infraestructura(
          departamento: formData['departamento'],
          ciudad: formData['ciudad'],
          direccion: formData['direccion'],
          disposicionLocativa: formData['disposicion_locativa'],
          tieneRetie: formData['tiene_retie'],
          capacidadInstalada: _capacidadInstalada,
        ),
      );

      Navigator.of(context).pop(newService);
    }
  }

  void _addCapacidad(String tipo) {
    showDialog(
      context: context,
      builder: (context) {
        final finalidadController = TextEditingController();
        return AlertDialog(
          title: Text('Añadir nuevo $tipo'),
          content: TextField(
            controller: finalidadController,
            decoration: const InputDecoration(labelText: 'Finalidad (Ej: Entrevista y examen)'),
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                if (finalidadController.text.isNotEmpty) {
                  setState(() {
                    _capacidadInstalada.add(
                      CapacidadInstalada(tipo: tipo, finalidad: finalidadController.text),
                    );
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceToEdit == null ? "Añadir Servicio" : "Editar Servicio"),
        actions: [
          IconButton(icon: const Icon(Icons.save_alt_outlined), tooltip: "Guardar Servicio", onPressed: _saveAndReturn),
        ],
      ),
      body: FormBuilder(
        key: _serviceFormKey,
        initialValue: {
          'nombre_servicio': widget.serviceToEdit?.nombre,
          'modalidad': widget.serviceToEdit?.modalidad,
          'departamento': widget.serviceToEdit?.infraestructura.departamento,
          'ciudad': widget.serviceToEdit?.infraestructura.ciudad,
          'direccion': widget.serviceToEdit?.infraestructura.direccion,
          'disposicion_locativa': widget.serviceToEdit?.infraestructura.disposicionLocativa ?? 'primer_piso',
          'tiene_retie': widget.serviceToEdit?.infraestructura.tieneRetie ?? false,
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Detalles del Servicio", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              FormBuilderTextField(
                name: 'nombre_servicio',
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre del servicio a inscribir',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                validator: FormBuilderValidators.required(),
                onTap: () async {
                  final selectedService = await Navigator.of(context).push<String>(
                    MaterialPageRoute(builder: (_) => const ServiceSearchPage()),
                  );

                  if (selectedService != null) {
                    _serviceFormKey.currentState?.patchValue({
                      'nombre_servicio': selectedService,
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              FormBuilderDropdown(
                name: 'modalidad',
                decoration: const InputDecoration(labelText: 'Modalidad del servicio', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'intramural', child: Text('Intramural')),
                  DropdownMenuItem(value: 'extramural', child: Text('Extramural')),
                  DropdownMenuItem(value: 'telemedicina', child: Text('Telemedicina')),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const Divider(height: 48),

              Text("Infraestructura de la Sede", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              FormBuilderTextField(name: 'departamento', decoration: const InputDecoration(labelText: 'Departamento', border: OutlineInputBorder()), validator: FormBuilderValidators.required()),
              const SizedBox(height: 16),
              FormBuilderTextField(name: 'ciudad', decoration: const InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder()), validator: FormBuilderValidators.required()),
              const SizedBox(height: 16),
              FormBuilderTextField(name: 'direccion', decoration: const InputDecoration(labelText: 'Dirección', border: OutlineInputBorder()), validator: FormBuilderValidators.required()),
              const SizedBox(height: 16),
              FormBuilderRadioGroup(name: 'disposicion_locativa', decoration: const InputDecoration(labelText: 'Disposición locativa', border: InputBorder.none), options: const [FormBuilderFieldOption(value: 'primer_piso', child: Text('Primer piso')), FormBuilderFieldOption(value: 'segundo_piso_o_mas', child: Text('Segundo piso o más'))]),
              FormBuilderSwitch(name: 'tiene_retie', title: const Text('¿Este lugar cuenta con RETIE?')),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Capacidad Instalada", style: Theme.of(context).textTheme.titleMedium),
                   Row(
                    children: [
                      IconButton(icon: const Icon(Icons.add_circle), tooltip: "Añadir Consultorio", onPressed: () => _addCapacidad('consultorio')),
                      IconButton(icon: const Icon(Icons.add_circle), tooltip: "Añadir Sala", onPressed: () => _addCapacidad('sala')),
                    ],
                  )
                ],
              ),
               ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _capacidadInstalada.length,
                itemBuilder: (context, index) {
                  final item = _capacidadInstalada[index];
                  return ListTile(title: Text(item.toString()), trailing: IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => setState(() => _capacidadInstalada.removeAt(index))));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}