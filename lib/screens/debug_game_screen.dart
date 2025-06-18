import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/role.dart';

/// Pantalla de depuración: crea una partida ficticia, muestra
/// los roles y permite expulsar jugadores hasta que alguien gana.
class DebugGameScreen extends StatefulWidget {
  const DebugGameScreen({super.key});

  @override
  State<DebugGameScreen> createState() => _DebugGameScreenState();
}

class _DebugGameScreenState extends State<DebugGameScreen> {
  late Game _game;

  @override
  void initState() {
    super.initState();
    _createNewGame();
  }

  void _createNewGame() {
    _game = Game(
      config: GameConfig(numPlayers: 10, numUndercovers: 2),
      playerNames: ['Ana', 'Ben', 'Carla', 'Dan', 'Eva', 'Fran', 
                    'Gina', 'Hugo', 'Iris', 'Jack'],
      wordCivilian: 'Lightsaber',
      wordUndercover: 'Wand',
    );
  }

  /* ---------- helpers ---------- */
  bool _isSpy(Role r) => r == Role.undercover || r == Role.mrWhite;

  String _label(Role r) => switch (r) {
        Role.civilian   => 'Civilian',
        Role.undercover => 'Undercover',
        Role.mrWhite    => 'Mr White',
      };

  /* ---------- UI ---------- */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug – Roles assigned'),
        actions: [
          IconButton(
            onPressed: () => setState(_createNewGame),
            tooltip: 'New game',
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _game.players.map((p) {
          final spy = _isSpy(p.role);
          return Card(
            child: ListTile(
              leading: Icon(
                spy ? Icons.visibility_off : Icons.person,
                color: spy ? Colors.red : Colors.green,
              ),
              title: Text(p.name),
              subtitle: Text(_label(p.role)),
              trailing:
                  p.alive ? null : const Icon(Icons.cancel, color: Colors.grey),
              onTap: p.alive
                  ? () {
                      // 1. Ejecuta la lógica
                      final finished = _game.eject(p.id);

                      // 2. Redibuja
                      setState(() {});

                      // 3. Si terminó, muestra ganador
                      if (finished) {
                        final winner = _game.winner == Winner.citizens
                            ? 'Civilians'
                            : 'Spies';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('🏆  $winner win!')),
                        );
                      }
                    }
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
