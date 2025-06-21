import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../stores/game_store.dart';
import '../models/role.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t     = AppLocalizations.of(context)!;
    final store = context.watch<GameStore>();
    final game  = store.game;

    // Si alguien llegó aquí sin partida válida volvemos al menú
    if (game == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).popUntil((r) => r.isFirst),
      );
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.menu_play)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Players',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: game.players.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final p = game.players[i];
                  return ListTile(
                    leading: Icon(
                      p.role == Role.undercover || p.role == Role.mrWhite
                          ? Icons.visibility_off
                          : Icons.person,
                    ),
                    title: Text(p.name),
                    subtitle: Text(
                      p.role == Role.mrWhite
                          ? 'Mr. White'
                          : p.role == Role.undercover
                              ? 'Undercover'
                              : 'Civilian',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // reinicia partida y vuelve al menú
                store.reset();
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
              child: const Text('End game'),
            ),
          ],
        ),
      ),
    );
  }
}
