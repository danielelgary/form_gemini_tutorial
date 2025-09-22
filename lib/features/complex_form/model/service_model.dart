// lib/features/complex_form/model/service_model.dart

// Modelo para la capacidad instalada (consultorios, salas, etc.)
class CapacidadInstalada {
  String tipo; // "consultorio" o "sala"
  String finalidad;

  CapacidadInstalada({
    required this.tipo,
    required this.finalidad,
  });

  @override
  String toString() {
    final tipoCapitalizado = tipo[0].toUpperCase() + tipo.substring(1);
    return '$tipoCapitalizado: $finalidad';
  }
}

// Modelo para la Sede (ahora llamada Infraestructura para coincidir con el JSON)
class Infraestructura {
  // Paso 9: Ubicación
  String departamento;
  String ciudad;
  String direccion;

  // Paso 10: Detalles
  String disposicionLocativa; // 'primer_piso', 'segundo_piso_o_mas'
  bool tieneRetie;

  // Paso 11: Capacidad Instalada
  List<CapacidadInstalada> capacidadInstalada;

  Infraestructura({
    required this.departamento,
    required this.ciudad,
    required this.direccion,
    this.disposicionLocativa = 'primer_piso',
    this.tieneRetie = false,
    List<CapacidadInstalada>? capacidad,
  }) : capacidadInstalada = capacidad ?? [];

  @override
  String toString() {
    return '$direccion, $ciudad';
  }
}

// El modelo principal que representa un Servicio completo
class ServiceModel {
  String nombre; // 'Atención de urgencias', 'Consulta externa', etc.
  String modalidad;
  Infraestructura infraestructura;

  ServiceModel({
    required this.nombre,
    required this.modalidad,
    required this.infraestructura,
  });

  @override
  String toString() {
    return '$nombre ($modalidad)';
  }
}