// Presentation: dumb widgets. They receive data and callbacks and know
// nothing about the ViewModel, provider or the data layer. Only material
// and the Consumo entity are allowed here.

import 'package:ecotrack_meta/dominio/consumo.dart';
import 'package:flutter/material.dart';

// Registration form: lab dropdown, liters field and a Guardar button.
// The chosen lab and the field text are ephemeral state living in its State.
class FormularioRegistro extends StatefulWidget {
  const FormularioRegistro({
    super.key,
    required this.alGuardar,
    required this.error,
    required this.guardando,
  });

  final Future<bool> Function(String laboratorio, String litros) alGuardar;
  final String? error;
  final bool guardando;

  @override
  State<FormularioRegistro> createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  String _laboratorio = laboratoriosUtez.first;
  final _litros = TextEditingController();

  @override
  void dispose() {
    _litros.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final ok = await widget.alGuardar(_laboratorio, _litros.text);
    if (!mounted) return;
    if (ok) {
      _litros.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consumo guardado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _laboratorio,
            decoration: const InputDecoration(labelText: 'Laboratorio'),
            items: [
              for (final lab in laboratoriosUtez)
                DropdownMenuItem(value: lab, child: Text(lab)),
            ],
            onChanged: (valor) {
              if (valor != null) setState(() => _laboratorio = valor);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('litros'),
            controller: _litros,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Litros',
              errorText: widget.error,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: widget.guardando ? null : _guardar,
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}

// History list: "Sin consumos" when empty, otherwise a total row and one row
// per consumption.
class ListaHistorial extends StatelessWidget {
  const ListaHistorial({super.key, required this.consumos, required this.total});

  final List<Consumo> consumos;
  final double total;

  @override
  Widget build(BuildContext context) {
    if (consumos.isEmpty) {
      return const Center(child: Text('Sin consumos'));
    }
    return ListView(
      children: [
        ListTile(
          title: Text('Total: ${total.toStringAsFixed(1)} L'),
        ),
        const Divider(height: 1),
        for (final c in consumos)
          ListTile(
            title: Text(c.laboratorio),
            trailing: Text('${c.litros.toStringAsFixed(1)} L'),
          ),
      ],
    );
  }
}

// Goal panel: the "Usado: … de … L" text, a progress bar, a status text and
// the two buttons with their keys.
class PanelMeta extends StatelessWidget {
  const PanelMeta({
    super.key,
    required this.usado,
    required this.meta,
    required this.avance,
    required this.superada,
    required this.alSubir,
    required this.alBajar,
  });

  final double usado;
  final double meta;
  final double avance;
  final bool superada;
  final VoidCallback alSubir;
  final VoidCallback alBajar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Usado: ${usado.toStringAsFixed(1)} de ${meta.toStringAsFixed(1)} L',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: avance),
          const SizedBox(height: 12),
          Text(superada ? 'Te pasaste de la meta' : 'Dentro de la meta'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                key: const Key('bajarMeta'),
                onPressed: alBajar,
                child: const Text('- 10'),
              ),
              OutlinedButton(
                key: const Key('subirMeta'),
                onPressed: alSubir,
                child: const Text('+ 10'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Shell: Scaffold with an AppBar, a bottom bar of three destinations and a
// body showing the chosen tab. The active tab is ephemeral state.
class PantallasEcoTrack extends StatefulWidget {
  const PantallasEcoTrack({
    super.key,
    required this.titulo,
    required this.registro,
    required this.historial,
    required this.meta,
  });

  final String titulo;
  final Widget registro;
  final Widget historial;
  final Widget meta;

  @override
  State<PantallasEcoTrack> createState() => _PantallasEcoTrackState();
}

class _PantallasEcoTrackState extends State<PantallasEcoTrack> {
  int _indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: IndexedStack(
        index: _indice,
        children: [widget.registro, widget.historial, widget.meta],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Registro'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Meta'),
        ],
      ),
    );
  }
}
