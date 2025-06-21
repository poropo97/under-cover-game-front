import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'l10n/app_localizations.dart';

/* ---- pantallas ---- */
import 'screens/menu_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/game_setup_screen.dart';
import 'screens/game_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/debug_game_screen.dart';
import 'screens/reveal_word_screen.dart'           // ⬅️ solo exponemos el wrapper

    show RevealWordScreenWrapper;
import 'screens/discussion_screen.dart';

import 'stores/game_store.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => GameStore(),
        child: const UndercoverApp(),
      ),
    );

/* ═════════════════════════════════════════════════════════════════════ */

class UndercoverApp extends StatefulWidget {
  const UndercoverApp({super.key});
  @override
  State<UndercoverApp> createState() => _UndercoverAppState();
}

class _UndercoverAppState extends State<UndercoverApp> {
  Locale? _locale;                   // null → idioma sistema
  ThemeMode _theme = ThemeMode.system;
  Color _seed     = Colors.deepPurple;
  bool  _ready    = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  /* ---- carga de prefs + splash mínimo ---- */
  Future<void> _bootstrap() async {
    final p = await SharedPreferences.getInstance();

    final code = p.getString('locale');
    if (code?.isNotEmpty ?? false) _locale = Locale(code!);

    switch (p.getString('themeMode')) {
      case 'light': _theme = ThemeMode.light; break;
      case 'dark' : _theme = ThemeMode.dark;  break;
      default     : _theme = ThemeMode.system;
    }

    final v = p.getInt('colorSeed');
    if (v != null) _seed = Color(v);

    await Future.delayed(kSplashDelay);
    if (mounted) setState(() => _ready = true);
  }

  /* ---- guardar prefs comunes ---- */
  Future<void> _savePrefs() async {
    final p = await SharedPreferences.getInstance();
    if (_locale == null) {
      await p.remove('locale');
    } else {
      await p.setString('locale', _locale!.languageCode);
    }
    await p.setString(
      'themeMode',
      _theme == ThemeMode.light
          ? 'light'
          : _theme == ThemeMode.dark
              ? 'dark'
              : 'system',
    );
    await p.setInt('colorSeed', _seed.value);
  }

  /* setters recibidos desde Settings */
  void _setLocale(Locale? loc) { setState(() => _locale = loc); _savePrefs(); }
  void _setTheme (ThemeMode m){ setState(() => _theme  = m ); _savePrefs(); }
  void _setSeed  (Color c)    { setState(() => _seed   = c ); _savePrefs(); }

  /* ---- MaterialApp ---- */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale   : _locale,
      themeMode: _theme,
      theme    : ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seed,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seed,
        brightness: Brightness.dark,
      ),
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'Undercover',
      /* -------- navegación -------- */
      home : _ready ? const MenuScreen() : const SplashScreen(),
      routes: {
        '/setup' : (_) => const GameSetupScreen(),
        '/game'  : (_) => const GameScreen(),
        '/profile':(_) => const ProfileScreen(),
        '/settings':(_) => SettingsScreen(
              currentLocale      : _locale,
              themeMode          : _theme,
              seedColor          : _seed,
              onLocaleChanged    : _setLocale,
              onThemeModeChanged : _setTheme,
              onColorChanged     : _setSeed,
            ),
        '/debug' : (_) => const DebugGameScreen(),
        /* ---- pantalla de reveal con wrapper ---- */
        '/reveal': (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as Map;
          return RevealWordScreenWrapper(
            index : args['index']  as int,
            reveal: args['reveal'] as bool,
          );
        },
        '/discussion': (_) => const DiscussionScreen(),
      },
    );
  }
}
