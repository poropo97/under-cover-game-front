// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_title => 'Undercover';

  @override
  String get menu_play => 'Jugar a Undercover';

  @override
  String get menu_profile => 'Mi perfil';

  @override
  String get menu_settings => 'Opciones';

  @override
  String get label_language => 'Idioma';

  @override
  String get label_theme => 'Tema';

  @override
  String get label_accent_color => 'Color de acento';

  @override
  String get option_system_default => 'Por defecto del sistema';

  @override
  String get option_theme_system => 'Igual que el sistema';

  @override
  String get option_theme_light => 'Claro';

  @override
  String get option_theme_dark => 'Oscuro';
}
