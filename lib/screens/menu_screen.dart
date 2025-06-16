import 'package:flutter/material.dart';
import 'package:undercover_game_front/l10n/app_localizations.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  // A single constant width keeps every button identical.
  static const double _buttonWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.app_title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _buttonWidth,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(t.menu_play),
                onPressed: () => Navigator.pushNamed(context, '/game'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: _buttonWidth,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: Text(t.menu_profile),
                onPressed: () => Navigator.pushNamed(context, '/profile'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: _buttonWidth,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.settings),
                label: Text(t.menu_settings),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
