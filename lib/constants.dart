
library constants;

import 'package:flutter/material.dart';

/// Opacidad para el patrón de fondo.
const double kBackgroundOpacity = 0.03;

/// Retraso mínimo del splash.
const Duration kSplashDelay = Duration(seconds: 1);

/* ---------------- SharedPreferences keys ---------------- */

const String kPrefSetupPlayers      = 'setup_players';      // int
const String kPrefSetupNames        = 'setup_names';        // List<String> JSON
const String kPrefSetupUndercovers  = 'setup_undercovers';  // int
const String kPrefSetupReveal       = 'setup_reveal';       // bool
