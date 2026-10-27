// Presentation: the shared state owner. No drawing here, so it imports
// foundation (ChangeNotifier), never material.

import 'package:ecotrack_meta/datos/consumo_repository.dart';
import 'package:ecotrack_meta/dominio/consumo.dart';
import 'package:ecotrack_meta/dominio/meta.dart';
import 'package:flutter/foundation.dart';

// Owns the shared state and talks only to the repository contract and the
// domain rules. It never creates a repository nor knows which one it is.
class ConsumosViewModel extends ChangeNotifier {
  ConsumosViewModel(this._repositorio);

  final ConsumoRepository _repositorio;

  // Shared state with its initial values.
  List<Consumo> consumos = [];
  String? error;
  bool guardando = false;
  double meta = metaInicial;

  // Derived state: computed getters, never stored fields.
  double get total => consumos.fold(0.0, (suma, c) => suma + c.litros);
  double get avance => avanceDeMeta(total: total, meta: meta);
  bool get metaSuperada => total > meta;

  // Reads whatever the repository already had and notifies.
  Future<void> cargar() async {
    consumos = await _repositorio.todos();
    notifyListeners();
  }

  // Tries to save. Returns true only when it was stored.
  Future<bool> guardar(String laboratorio, String litrosTexto) async {
    final litros = _aNumero(litrosTexto);
    final mensaje = validarLitros(litros);
    if (mensaje != null) {
      error = mensaje;
      notifyListeners();
      return false;
    }

    guardando = true;
    error = null;
    notifyListeners();

    await _repositorio.guardar(
      Consumo(laboratorio: laboratorio, litros: litros!),
    );
    consumos = await _repositorio.todos();

    guardando = false;
    notifyListeners();
    return true;
  }

  // Goal actions: move one step using the domain rule, then notify.
  void subirMeta() {
    meta = ajustarMeta(meta, pasoMeta);
    notifyListeners();
  }

  void bajarMeta() {
    meta = ajustarMeta(meta, -pasoMeta);
    notifyListeners();
  }

  // Parses text into a number, accepting a decimal comma and spaces.
  double? _aNumero(String texto) {
    final limpio = texto.trim().replaceAll(',', '.');
    return double.tryParse(limpio);
  }
}
