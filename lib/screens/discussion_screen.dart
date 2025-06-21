import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/game_store.dart';
import '../widgets/game_header.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<GameStore>();
    final game  = store.game!;

    return Scaffold(
      body: Stack(
        children: [
          /*──────────────── CONTENIDO ────────────────*/
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cada jugador, por orden, debe dar una pista relacionada con su palabra SIN decirla. '
                  'Cuando todos hayan hablado pulsa “Empezar votación”.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                /* ── lista orden de turno ── */
                Expanded(
                  child: ListView.builder(
                    itemCount: game.players.length,
                    itemBuilder: (_, i) {
                      final isCurrent = i == store.turn;
                      return ListTile(
                        leading: Text(
                          '${i + 1}.',
                          style: TextStyle(
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.normal),
                        ),
                        title: Text(
                          game.players[i].name,
                          style: TextStyle(
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.normal),
                        ),
                      );
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    // TODO: Navegar a /vote cuando exista
                    store.reset();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Empezar votación'),
                ),
              ],
            ),
          ),

          /*──────────────── CABECERA ────────────────*/
          GameHeader(title: 'Round ${store.round}'),
        ],
      ),
    );
  }
}
