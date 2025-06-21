// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Undercover';

  @override
  String get menu_play => 'Play Undercover';

  @override
  String get menu_profile => 'My Profile';

  @override
  String get menu_settings => 'Settings';

  @override
  String get label_language => 'Language';

  @override
  String get label_theme => 'Theme';

  @override
  String get label_accent_color => 'Accent color';

  @override
  String get option_system_default => 'System default';

  @override
  String get option_theme_system => 'Same as system';

  @override
  String get option_theme_light => 'Light';

  @override
  String get option_theme_dark => 'Dark';

  @override
  String get setup_title => 'UNDERCOVER';

  @override
  String get setup_num_players => 'Number of players';

  @override
  String setup_player_hint(Object index) {
    return 'Player $index';
  }

  @override
  String get setup_settings => 'Settings';

  @override
  String get setup_undercover_count => 'Undercover count';

  @override
  String get setup_extra_options => 'Extra options';

  @override
  String get setup_reveal => 'Reveal undercover';

  @override
  String get setup_start => 'START GAME';
}
