// Data: in-memory implementation of the contract.

import 'package:ecotrack_meta/datos/consumo_repository.dart';
import 'package:ecotrack_meta/dominio/consumo.dart';

// Keeps consumptions in a private list. Methods are async because a real
// source (network, disk) would take time.
class MemoriaConsumoRepository implements ConsumoRepository {
  final List<Consumo> _guardados = [];

  @override
  Future<void> guardar(Consumo consumo) async {
    _guardados.add(consumo);
  }

  // Returns an unmodifiable copy so nobody can mutate the source from outside.
  @override
  Future<List<Consumo>> todos() async => List.unmodifiable(_guardados);
}
