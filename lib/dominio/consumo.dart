// Domain: pure Dart rules, no Flutter.

// The three UTEZ labs, in this fixed order.
const laboratoriosUtez = ['Lab Química', 'Lab Redes', 'Lab Física'];

// A single consumption record: which lab and how many liters.
class Consumo {
  const Consumo({required this.laboratorio, required this.litros});

  final String laboratorio;
  final double litros;
}

// Validates liters. Returns an error message, or null when valid.
// Order of rules: not a number (null), <= 0, > 10000.
String? validarLitros(double? litros) {
  if (litros == null) {
    return 'Escribe los litros con número';
  }
  if (litros <= 0) {
    return 'Los litros deben ser mayores que cero';
  }
  if (litros > 10000) {
    return 'Los litros superan el tope de 10000';
  }
  return null;
}
