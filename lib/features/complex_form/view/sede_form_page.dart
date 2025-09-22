// lib/features/complex_form/view/sede_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_gemini_tutorial/features/complex_form/model/sede_model.dart';

class SedeFormPage extends StatefulWidget {
  final Sede? sedeToEdit;
  final int? sedeIndex;

  const SedeFormPage({super.key, this.sedeToEdit, this.sedeIndex});

  @override
  State<SedeFormPage> createState() => _SedeFormPageState();
}

class _SedeFormPageState extends State<SedeFormPage> {
  final _sedeFormKey = GlobalKey<FormBuilderState>();
  late Sede _currentSede;

  @override
  void initState() {
    super.initState();
    // Si estamos editando, clonamos el objeto para no modificar el original hasta guardar.
    // Si no, creamos una sede nueva.
    _currentSede = widget.sedeToEdit != null
        ? Sede(
            departamento: widget.sedeToEdit!.departamento,
            ciudad: widget.sedeToEdit!.ciudad,
            direccion: widget.sedeToEdit!.direccion,
            disposicionLocativa: widget.sedeToEdit!.disposicionLocativa,
            tieneRetie: widget.sedeToEdit!.tieneRetie,
            capacidad: List<CapacidadInstalada>.from(widget.sedeToEdit!.capacidadInstalada),
          )
        : Sede(departamento: '', ciudad: '', direccion: '');
  }

  void _saveAndReturn() {
    if (_sedeFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = _sedeFormKey.currentState!.value;
      
      final finalSede = Sede(
        departamento: formData['departamento'],
        ciudad: formData['ciudad'],
        direccion: formData['direccion'],
        disposicionLocativa: formData['disposicion_locativa'],
        tieneRetie: formData['tiene_retie'],
        capacidad: _currentSede.capacidadInstalada,
      );
      // Devolvemos el objeto Sede completo a la página anterior
      Navigator.of(context).pop(finalSede);
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
                    _currentSede.capacidadInstalada.add(
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
        title: Text(widget.sedeToEdit == null ? "Añadir Sede" : "Editar Sede"),
        actions: [
          IconButton(icon: const Icon(Icons.save_alt_outlined), tooltip: "Guardar Sede", onPressed: _saveAndReturn),
        ],
      ),
      body: FormBuilder(
        key: _sedeFormKey,
        initialValue: {
          'departamento': _currentSede.departamento,
          'ciudad': _currentSede.ciudad,
          'direccion': _currentSede.direccion,
          'disposicion_locativa': _currentSede.disposicionLocativa,
          'tiene_retie': _currentSede.tieneRetie,
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PASO 9: Ubicación ---
              Text("Ubicación de la Sede", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              FormBuilderTextField(name: 'departamento', decoration: const InputDecoration(labelText: 'Departamento', border: OutlineInputBorder()), validator: FormBuilderValidators.required()),
              const SizedBox(height: 16),
              FormBuilderTextField(name: 'ciudad', decoration: const InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder()), validator: FormBuilderValidators.required()),
              const SizedBox(height: 16),
              FormBuilderTextField(name: 'direccion', decoration: const InputDecoration(labelText: 'Dirección', border: OutlineInputBorder()), validator: FormBuilderValidators.required()),
              const SizedBox(height: 24),

              // --- PASO 10: Infraestructura ---
              Text("Infraestructura", style: Theme.of(context).textTheme.titleLarge),
              FormBuilderRadioGroup(
                name: 'disposicion_locativa',
                decoration: const InputDecoration(labelText: 'Disposición locativa', border: InputBorder.none),
                options: const [
                  FormBuilderFieldOption(value: 'primer_piso', child: Text('Primer piso')),
                  FormBuilderFieldOption(value: 'segundo_piso_o_mas', child: Text('Segundo piso o más')),
                ],
              ),
              FormBuilderSwitch(name: 'tiene_retie', title: const Text('¿Este lugar cuenta con RETIE?')),
              const SizedBox(height: 24),
              
              // --- PASO 11: Capacidad Instalada ---
              Text("Capacidad Instalada", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(icon: const Icon(Icons.add_circle_outline), label: const Text('Consultorio'), onPressed: () => _addCapacidad('consultorio')),
                  ElevatedButton.icon(icon: const Icon(Icons.add_circle_outline), label: const Text('Sala'), onPressed: () => _addCapacidad('sala')),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _currentSede.capacidadInstalada.length,
                itemBuilder: (context, index) {
                  final item = _currentSede.capacidadInstalada[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(item.tipo == 'consultorio' ? Icons.personal_injury_outlined : Icons.meeting_room_outlined),
                      title: Text(item.toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => setState(() => _currentSede.capacidadInstalada.removeAt(index)),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}