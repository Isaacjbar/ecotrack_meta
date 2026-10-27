# Gestión de estado — EcoTrack Meta

**Equipo:** Barcelata
**Fecha:** 2026-10-26

## Tipos de estado en nuestro código

| Dato | Tipo (efímero, compartido, derivado, persistido) | Dónde vive |
|---|---|---|
| Pestaña activa | Efímero | `_PantallasEcoTrackState._indice` en `lib/presentacion/vistas.dart` (setState en `onTap`) |
| Texto del campo de litros | Efímero | `_FormularioRegistroState._litros` (TextEditingController) en `lib/presentacion/vistas.dart` |
| consumos y meta | Compartido | campos `consumos` y `meta` de `ConsumosViewModel` en `lib/presentacion/consumos_view_model.dart` |
| total y metaSuperada | Derivado | getters `get total` y `get metaSuperada` del `ConsumosViewModel` (se calculan, no se guardan) |
| Lo que regresa todos() | Persistido | lista `_guardados` de `MemoriaConsumoRepository` en `lib/datos/memoria_consumo_repository.dart` |

## Criterios

| Criterio | A · ChangeNotifier puro | B · provider |
|---|---|---|
| Dato compartido | Un solo `ConsumosViewModel` creado en `_AppChangeNotifierState` y pasado a los tres adaptadores; test "Dato compartido" en verde | El mismo `ConsumosViewModel` colgado con `ChangeNotifierProvider` en `AppProvider`; test "Dato compartido" en verde |
| Capas | `vistas.dart` solo importa `material` y `dominio/consumo.dart`; el error del dominio llega como `error`; test "Capas" en verde | Igual: reusa `vistas.dart` sin cambios; el `read(...).guardar()` propaga el error; test "Capas" en verde |
| Encaje con el diagrama | Vista tonta → adaptador con `ListenableBuilder` → ViewModel → dominio/repositorio | Vista tonta → adaptador con `context.watch`/`context.read` → mismo ViewModel → dominio/repositorio |
| Constructores que reciben vm | 3: `RegistroCN`, `HistorialCN`, `MetaCN` (`required this.vm`) | 0: los adaptadores lo piden al árbol con `context.watch`/`context.read` |
| Quién libera el ViewModel | El dueño: `_AppChangeNotifierState.dispose()` llama `vm.dispose()` | `provider`: lo gestiona `ChangeNotifierProvider`, nosotros no escribimos `dispose()` |
| Costo de adoptarla ahora | Cero paquetes extra, pero hay que enhebrar `vm` por cada constructor nuevo | Depende del paquete `provider`, pero cualquier widget accede al ViewModel sin enhebrarlo |
| Sustitución de la fuente de datos | Solo cambia `main_change_notifier.dart`; test "Sustitución" (RepositorioEspia) en verde | Solo cambia `main.dart`; test "Sustitución" (RepositorioEspia) en verde |

## Elección

Elegimos: **B · provider**, porque al agregar pantallas no hay que pasar el ViewModel por constructor (0 constructores con `vm`) y `provider` libera el ViewModel por nosotros.

Se mantiene esta pieza del diagrama: el `ConsumosViewModel` y las vistas tontas no cambian entre A y B (misma lógica, mismo `vistas.dart`).

Esta pieza es la que podría sustituirse después: la fuente de datos (`ConsumoRepository`), que hoy es `MemoriaConsumoRepository` y mañana podría ser red o disco cambiando solo `main.dart`.
