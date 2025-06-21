import 'package:flutter/material.dart';
import '../models/game.dart';

/// Maneja el estado global de una partida.
class GameStore extends ChangeNotifier {
  Game? _game;          // partida actual
  int  _turn  = 0;      // índice de jugador que habla
  int  _round = 1;      // nº de ronda

  /* ───────── getters públicos ───────── */
  Game? get game  => _game;
  int   get turn  => _turn;
  int   get round => _round;

  /// Inicia una nueva partida.
  void start(Game game) {
    _game = game;
    _turn = 0;
    _round = 1;
    notifyListeners();
  }

  /// Avanza al siguiente jugador (o ronda).
  void advanceTurn() {
    if (_game == null) return;

    _turn++;
    if (_turn >= _game!.players.length) {
      _turn = 0;
      _round++;
    }
    notifyListeners();
  }

  /// Limpia todo el estado.
  void reset() {
    _game  = null;
    _turn  = 0;
    _round = 1;
    notifyListeners();
  }
}
