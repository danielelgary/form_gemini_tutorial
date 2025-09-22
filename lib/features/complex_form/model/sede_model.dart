// lib/features/complex_form/model/sede_model.dart

// Modelo para la capacidad instalada (consultorios, salas, etc.)
class CapacidadInstalada {
  String tipo; // Será "consultorio" o "sala"
  String finalidad;

  CapacidadInstalada({
    required this.tipo,
    required this.finalidad,
  });

  // Cómo se mostrará el objeto en una lista
  @override
  String toString() {
    final tipoCapitalizado = tipo[0].toUpperCase() + tipo.substring(1);
    return '$tipoCapitalizado: $finalidad';
  }
}

// Modelo principal para una Sede, conteniendo toda su información
class Sede {
  // Paso 9: Ubicación
  String departamento;
  String ciudad;
  String direccion;

  // Paso 10: Infraestructura
  String disposicionLocativa; // 'primer_piso' o 'segundo_piso_o_mas'
  bool tieneRetie;

  // Paso 11: Capacidad Instalada
  List<CapacidadInstalada> capacidadInstalada;

  Sede({
    required this.departamento,
    required this.ciudad,
    required this.direccion,
    this.disposicionLocativa = 'primer_piso', // Valor por defecto
    this.tieneRetie = false, // Valor por defecto
    List<CapacidadInstalada>? capacidad,
  }) : capacidadInstalada = capacidad ?? []; // Inicializa la lista vacía si no se provee

  // Cómo se mostrará la sede en la lista principal
  @override
  String toString() {