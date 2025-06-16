import 'package:flutter/material.dart';
import 'package:undercover_game_front/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.menu_profile)),
      body: Center(child: Text('${t.menu_profile} - Coming soon')),
    );
  }
}
