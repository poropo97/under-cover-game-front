import 'package:flutter/material.dart';
import 'package:undercover_game_front/constants.dart';
import 'package:undercover_game_front/l10n/app_localizations.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const double _buttonWidth = 240.0;
  static const double kBackgroundScale = 1;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.app_title)),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/bgs/undercover_bg_400.png'),
            repeat: ImageRepeat.repeat,
            fit: BoxFit.none,
            scale: kBackgroundScale,
            opacity: kBackgroundOpacity,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menuButton(context, Icons.play_arrow, t.menu_play, '/setup'),
              const SizedBox(height: 20),
              _menuButton(context, Icons.person, t.menu_profile, '/profile'),
              const SizedBox(height: 20),
              _menuButton(context, Icons.settings, t.menu_settings, '/settings'),
              const SizedBox(height: 40),
              _menuButton(context, Icons.bug_report, 'Debug logic', '/debug'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, IconData icon, String label, String route) {
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
