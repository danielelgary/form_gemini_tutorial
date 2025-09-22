// lib/features/complex_form/model/real_form_model.dart

// Clase para un solo servicio
class Service {
  final int medicalSpecialty;
  final String type;
  final int modality;
  // Podríamos añadir Infrastructure e InstalledCapacity aquí también.
  // Por ahora, lo mantenemos simple para empezar.

  Service({
    required this.medicalSpecialty,
    required this.type,
    required this.modality,
  });

  // Método para mostrarlo en la lista
  @override
  String toString() {
    return 'Especialidad: $medicalSpecialty, Tipo: $type';
  }
}