import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stores/game_store.dart';

/// Cabecera flotante con título dinámico + botones Help y Exit.
/// Debe insertarse dentro de un Stack, preferiblemente envuelto
/// en un SafeArea para respetar notch y barras de estado.
class GameHeader extends StatelessWidget {
  const GameHeader({
    super.key,
    required this.title,
    this.helpContent,
  });

  /// Texto que describe la fase actual (“Round 1”, “Voting”…)
  final String title;

  /// Widget opcional a mostrar dentro del modal de ayuda.
  final Widget? helpContent;

  /*────────────────────────── helpers ─────────────────────────*/

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: helpContent ??
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('How to play', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                const Text(
                  'Give a clue related to your word without saying the word itself. '
                  'Try not to be too obvious so the spy won’t guess your word.',
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got it'),
                ),
              ],
            ),
      ),
    );
  }

  void _confirmExit(BuildContext context) async {
    final bool? leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave the game?'),
        content: const Text('All current progress will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (leave ?? false) {
      // Reset state and return to main menu
      context.read<GameStore>().reset();
      // Cerrar todas las rutas hasta el menú
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  /*────────────────────────── build ──────────────────────────*/
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter, // Centra el header en la parte superior
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: scheme.surfaceTint.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      offset: Offset(0, 3),
                      color: Colors.black26,
                    )
                  ],
                ),
                height: 72,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconButton(
                      context,
                      icon: Icons.help_outline,
                      onTap: () => _showHelp(context),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(width: 16),
                    _iconButton(
                      context,
                      icon: Icons.close,
                      onTap: () => _confirmExit(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(BuildContext context,
      {required IconData icon, required VoidCallback onTap}) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, size: 28, color: Colors.white),
        ),
      ),
    );
  }
}
