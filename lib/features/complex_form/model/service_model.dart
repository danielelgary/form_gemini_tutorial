// lib/features/complex_form/model/service_model.dart

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

class Infraestructura {
  String departamento;
  String ciudad;
  String direccion;
  String disposicionLocativa;
  bool tieneRetie;
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

class ServiceModel {
  String nombre;
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