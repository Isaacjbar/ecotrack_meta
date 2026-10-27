// Entry point for variant A. One of the only two places that knows the
// in-memory implementation.

import 'package:ecotrack_meta/datos/memoria_consumo_repository.dart';
import 'package:ecotrack_meta/variantes/a_change_notifier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AppChangeNotifier(repositorio: MemoriaConsumoRepository()));
}
