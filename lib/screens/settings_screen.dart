import 'package:flutter/material.dart';
import 'package:undercover_game_front/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.currentLocale,
    required this.themeMode,
    required this.seedColor,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    required this.onColorChanged,
  });

  final Locale? currentLocale;
  final ThemeMode themeMode;
  final Color seedColor;

  final void Function(Locale? locale) onLocaleChanged;
  final void Function(ThemeMode mode) onThemeModeChanged;
  final void Function(Color color) onColorChanged;

  static const _choices = [
    Colors.deepPurple,
    Colors.teal,
    Colors.orange,
    Colors.pink,
    Colors.indigo,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final initialLocale = currentLocale?.languageCode ?? 'system';
    final themeValue = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark  => 'dark',
      _               => 'system',
    };

    return Scaffold(
      appBar: AppBar(title: Text(t.menu_settings)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(t.menu_settings, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),

            /* ---------- idioma ---------- */
            Text(t.label_language, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: initialLocale,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(t.option_system_default),
                ),
                const DropdownMenuItem(value: 'en', child: Text('English')),
                const DropdownMenuItem(value: 'es', child: Text('Español')),
              ],
              onChanged: (value) {
                if (value == null) return;
                onLocaleChanged(value == 'system' ? null : Locale(value));
              },
            ),
            const SizedBox(height: 32),

            /* ---------- tema ---------- */
            Text(t.label_theme, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: themeValue,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(t.option_theme_system),
                ),
                DropdownMenuItem(
                  value: 'light',
                  child: Text(t.option_theme_light),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text(t.option_theme_dark),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                onThemeModeChanged(
                  switch (v) {
                    'light'  => ThemeMode.light,
                    'dark'   => ThemeMode.dark,
                    _        => ThemeMode.system,
                  },
                );
              },
            ),
            const SizedBox(height: 32),

            /* ---------- color ---------- */
            Text(t.label_accent_color, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _choices.map((c) {
                final bool selected = c.value == seedColor.value;
                return GestureDetector(
                  onTap: () => onColorChanged(c),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? Colors.white : Colors.grey.shade400,
                        width: selected ? 4 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
