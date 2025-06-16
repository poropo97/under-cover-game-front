import 'package:flutter/material.dart';
import 'package:undercover_game_front/l10n/app_localizations.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.menu_play)),
      body: Center(child: Text('${t.menu_play} - Coming soon')),
    );
  }
}
