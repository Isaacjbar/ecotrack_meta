// Data: repository contract, spoken in domain terms.

import 'package:ecotrack_meta/dominio/consumo.dart';

// Abstract contract: any source of consumptions must offer these two.
abstract class ConsumoRepository {
  Future<void> guardar(Consumo consumo);
  Future<List<Consumo>> todos();
}
