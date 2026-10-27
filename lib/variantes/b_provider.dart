// Variant B: provider over the SAME ViewModel. The adapters receive nothing
// by constructor; they ask the tree for the ViewModel. watch to show,
// read to act.

import 'package:ecotrack_meta/datos/consumo_repository.dart';
import 'package:ecotrack_meta/presentacion/consumos_view_model.dart';
import 'package:ecotrack_meta/presentacion/vistas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Hangs a ChangeNotifierProvider above MaterialApp. provider owns the
// lifecycle: it disposes the ViewModel for us.
class AppProvider extends StatelessWidget {
  const AppProvider({super.key, required this.repositorio});

  final ConsumoRepository repositorio;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ConsumosViewModel>(
      create: (_) => ConsumosViewModel(repositorio)..cargar(),
      child: const MaterialApp(
        title: 'EcoTrack Meta',
        home: PantallasEcoTrack(
          titulo: 'B · provider',
          registro: RegistroProvider(),
          historial: HistorialProvider(),
          meta: MetaProvider(),
        ),
      ),
    );
  }
}

// Registro adapter: watches to render, reads inside the callback to act.
class RegistroProvider extends StatelessWidget {
  const RegistroProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return FormularioRegistro(
      alGuardar: (laboratorio, litros) =>
          context.read<ConsumosViewModel>().guardar(laboratorio, litros),
      error: vm.error,
      guardando: vm.guardando,
    );
  }
}

// Historial adapter.
class HistorialProvider extends StatelessWidget {
  const HistorialProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return ListaHistorial(consumos: vm.consumos, total: vm.total);
  }
}

// Meta adapter.
class MetaProvider extends StatelessWidget {
  const MetaProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConsumosViewModel>();
    return PanelMeta(
      usado: vm.total,
      meta: vm.meta,
      avance: vm.avance,
      superada: vm.metaSuperada,
      alSubir: () => context.read<ConsumosViewModel>().subirMeta(),
      alBajar: () => context.read<ConsumosViewModel>().bajarMeta(),
    );
  }
}
