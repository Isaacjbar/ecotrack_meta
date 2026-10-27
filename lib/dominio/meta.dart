// Domain: weekly goal rules, pure Dart.

// Fixed goal constants from the contract.
const metaInicial = 100.0;
const pasoMeta = 10.0;
const metaMinima = 10.0;

// Adds the change to the current goal, never going below metaMinima.
double ajustarMeta(double actual, double cambio) {
  final nueva = actual + cambio;
  return nueva < metaMinima ? metaMinima : nueva;
}

// Fraction of the goal already used, clamped between 0 and 1.
// Guards against division by zero.
double avanceDeMeta({required double total, required double meta}) {
  if (meta <= 0) {
    return 0;
  }
  final fraccion = total / meta;
  return fraccion.clamp(0.0, 1.0).toDouble();
}
