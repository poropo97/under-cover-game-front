import 'package:flutter/material.dart';
import 'package:undercover_game_front/l10n/app_localizations.dart';
import 'package:undercover_game_front/constants.dart'; // contiene kBackgroundOpacity

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const double _buttonWidth = 240.0;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.app_title)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- TILED BACKGROUND ----------
          Opacity(
            opacity: kBackgroundOpacity,
            child: Image.asset(
              'assets/bgs/undercover_bg_400.png',
              repeat: ImageRepeat.repeat,
              fit: BoxFit.none,          // no escala; patrón real 1:1
            ),
          ),

          // ---------- MAIN UI ----------
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _menuButton(
                  context,
                  icon: Icons.play_arrow,
                  label: t.menu_play,
                  route: '/game',
                ),
                const SizedBox(height: 20),
                _menuButton(
                  context,
                  icon: Icons.person,
                  label: t.menu_profile,
                  route: '/profile',
                ),
                const SizedBox(height: 20),
                _menuButton(
                  context,
                  icon: Icons.settings,
                  label: t.menu_settings,
                  route: '/settings',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // helper
  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return SizedBox(
      width: _buttonWidth,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: () => Navigator.of(context).pushNamed(route),
      ),
    );
  }
}
