import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undercover_game_front/constants.dart';            
import 'package:undercover_game_front/l10n/app_localizations.dart';

import 'screens/menu_screen.dart';
import 'screens/game_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/debug_game_screen.dart';       
import 'screens/game_setup_screen.dart';   


void main() => runApp(const UndercoverApp());

class UndercoverApp extends StatefulWidget {
  const UndercoverApp({super.key});

  @override
  State<UndercoverApp> createState() => _UndercoverAppState();
}

class _UndercoverAppState extends State<UndercoverApp> {
  Locale? _locale;            // null → idioma del sistema
  ThemeMode _themeMode = ThemeMode.system;
  Color _seed = Colors.deepPurple;
  bool _ready = false;        // muestra Splash hasta que todo está listo

  /* ---------- bootstrap ---------- */
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();

    // idioma
    final code = prefs.getString('locale');
    if (code != null && code.isNotEmpty) _locale = Locale(code);

    // themeMode
    switch (prefs.getString('themeMode')) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
    }

    // color primario
    final seedInt = prefs.getInt('colorSeed');
    if (seedInt != null) _seed = Color(seedInt);

    await Future.delayed(kSplashDelay); // p. ej. const Duration(seconds: 1)
    if (mounted) setState(() => _ready = true);
  }

  /* ---------- persistencia ---------- */
  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // idioma
    _locale == null
        ? await prefs.remove('locale')
        : await prefs.setString('locale', _locale!.languageCode);

    // tema
    await prefs.setString(
      'themeMode',
      switch (_themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark  => 'dark',
        _               => 'system',
      },
    );

    // color
    await prefs.setInt('colorSeed', _seed.value);
  }

  /* ---------- callbacks desde Settings ---------- */
  void _setLocale(Locale? loc) {
    setState(() => _locale = loc);
    _savePrefs();
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    _savePrefs();
  }

  void _setSeed(Color c) {
    setState(() => _seed = c);
    _savePrefs();
  }

  /* ---------- build ---------- */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seed,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seed,
        brightness: Brightness.dark,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
      title: 'Undercover',
      home: _ready ? const MenuScreen() : const SplashScreen(),
      routes: {
        '/game':    (_) => const GameScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings':(_) => SettingsScreen(
              currentLocale: _locale,
              themeMode: _themeMode,
              seedColor: _seed,
              onLocaleChanged: _setLocale,
              onThemeModeChanged: _setThemeMode,
              onColorChanged: _setSeed,
            ),
        '/debug':   (_) => const DebugGameScreen(),  
        '/setup'  : (_) => const GameSetupScreen(),
      },
    );
  }
}
