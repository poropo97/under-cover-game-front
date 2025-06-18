import 'dart:math';
import 'player.dart';
import 'role.dart';

/// Configuration chosen in the lobby.
class GameConfig {
  GameConfig({
    required this.numPlayers,
    required this.numUndercovers,
    this.includeMrWhite = false,
  }) : assert(numUndercovers < numPlayers, 'Undercovers must be fewer than players');

  final int numPlayers;
  final int numUndercovers;
  final bool includeMrWhite;
}

/// Runtime state of a match.
class Game {
  Game({
    required this.config,
    required List<String> playerNames,
    required this.wordCivilian,
    required this.wordUndercover,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString() {
    _createPlayers(playerNames);
  }

  final String id;
  final GameConfig config;

  /// Secret words (same language, similar topic).
  final String wordCivilian;
  final String wordUndercover;

  /// Ordered list of participants.
  late final List<Player> players;

  /// 0-based index of current round.
  int round = 0;

  /// Returns all players still in the game.
  Iterable<Player> get alivePlayers => players.where((p) => p.alive);

  /// Convenience accessors.
  Iterable<Player> get spies   => players.where((p) => p.role.isSpy && p.alive);
  Iterable<Player> get citizens => players.where((p) => !p.role.isSpy && p.alive);

  /* ------------------------------------------------------------------ */
  /*  Public API                                                        */
  /* ------------------------------------------------------------------ */

  /// Eliminate a player by id and return `true` if game ends.
  bool eject(String playerId) {
    final p = players.firstWhere((p) => p.id == playerId);
    p.alive = false;

    // Win conditions after each vote
    if (spies.isEmpty)  {
      winner = Winner.citizens;
      return true;
    }
    if (spies.length >= alivePlayers.length / 2) {
      winner = Winner.spies;
      return true;
    }
    round += 1;
    return false;
  }

  late Winner? winner = null;     // null until game ends

  /* ------------------------------------------------------------------ */
  /*  Private helpers                                                   */
  /* ------------------------------------------------------------------ */

  void _createPlayers(List<String> names) {
    if (names.length != config.numPlayers) {
      throw ArgumentError('Expected ${config.numPlayers} names, got ${names.length}');
    }

    // Build a shuffled pool of roles.
    final roles = <Role>[
      ...List.filled(config.numUndercovers, Role.undercover),
      if (config.includeMrWhite) Role.mrWhite,
      ...List.filled(config.numPlayers -
          config.numUndercovers -
          (config.includeMrWhite ? 1 : 0), Role.civilian),
    ]..shuffle();

    // Assign roles + speaking order.
    players = List.generate(names.length, (i) {
      return Player(name: names[i], role: roles[i], order: i);
    });
  }
}

/// Possible winners.
enum Winner { citizens, spies }
