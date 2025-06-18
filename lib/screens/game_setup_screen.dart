import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/game.dart';
import '../models/role.dart';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});

  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  /* ---------- estado ---------- */
  int _numPlayers = 6;
  int _numUndercovers = 1;
  bool _revealUndercover = false;

  late List<TextEditingController> _controllers;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(12, (_) => TextEditingController());
    _loadPrefs();
  }

  /* ---------- persistencia ---------- */
  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      _numPlayers     = _prefs.getInt(kPrefSetupPlayers)     ?? 6;
      _numUndercovers = _prefs.getInt(kPrefSetupUndercovers) ?? 1;
      _revealUndercover = _prefs.getBool(kPrefSetupReveal)   ?? false;

      final namesJson = _prefs.getString(kPrefSetupNames);
      if (namesJson != null) {
        final list = (jsonDecode(namesJson) as List).cast<String>();
        for (int i = 0; i < list.length && i < _controllers.length; i++) {
          _controllers[i].text = list[i];
        }
      }
    });
  }

  Future<void> _savePrefs() async {
    await _prefs.setInt(kPrefSetupPlayers, _numPlayers);
    await _prefs.setInt(kPrefSetupUndercovers, _numUndercovers);
    await _prefs.setBool(kPrefSetupReveal, _revealUndercover);

    final names = _controllers
        .take(_numPlayers)
        .map((c) => c.text.trim())
        .toList(growable: false);
    await _prefs.setString(kPrefSetupNames, jsonEncode(names));
  }

  /* ---------- helpers de UI ---------- */
  void _updatePlayerCount(int delta) {
    final newCount = (_numPlayers + delta).clamp(4, 12);
    if (newCount == _numPlayers) return;
    setState(() {
      _numPlayers = newCount;
      _numUndercovers = _numUndercovers.clamp(1, _numPlayers - 1);
    });
    _savePrefs();
  }

  void _updateUndercoverCount(int delta) {
    setState(() {
      _numUndercovers =
          (_numUndercovers + delta).clamp(1, _numPlayers - 1);
    });
    _savePrefs();
  }

  /* ---------- build ---------- */
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('UNDERCOVER')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text('Number of players',
                style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),

            _numberPicker(
              value: _numPlayers,
              onMinus: () => _updatePlayerCount(-1),
              onPlus: () => _updatePlayerCount(1),
            ),
            const SizedBox(height: 16),

            /* ---------- lista reordenable ---------- */
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _numPlayers,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final ctrl = _controllers.removeAt(oldIndex);
                  _controllers.insert(newIndex, ctrl);
                });
                _savePrefs();
              },
              itemBuilder: (context, i) {
                return ListTile(
                  key: ValueKey('player_$i'),
                  title: TextField(
                    controller: _controllers[i],
                    decoration: InputDecoration(
                      hintText: 'Player ${i + 1}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      isCollapsed: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (_) => _savePrefs(),
                  ),
                  trailing: const Icon(Icons.drag_handle),
                );
              },
            ),

            const SizedBox(height: 16),
            Text('Settings',
                style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),

            _numberPicker(
              label: 'Undercover count',
              value: _numUndercovers,
              onMinus: () => _updateUndercoverCount(-1),
              onPlus: () => _updateUndercoverCount(1),
            ),
            const SizedBox(height: 16),

            /* ---------- opciones extra ---------- */
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Extra options',
                  style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _revealUndercover,
              title: const Text('Reveal undercover'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              onChanged: (v) {
                setState(() => _revealUndercover = v);
                _savePrefs();
              },
            ),
            const SizedBox(height: 24),

            /* ---------- START GAME ---------- */
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _startGame,
                child: const Text(
                  'START GAME',
                  style: TextStyle(fontSize: 18, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---------- widgets auxiliares ---------- */
  Widget _numberPicker({
    String? label,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Column(
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _roundIconButton(Icons.remove, onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  '$value',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              _roundIconButton(Icons.add, onPlus),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 24),
      ),
    );
  }

  /* ---------- iniciar partida ---------- */
  void _startGame() {
    final names = List.generate(_numPlayers, (i) {
      final text = _controllers[i].text.trim();
      return text.isEmpty ? 'Player ${i + 1}' : text;
    });

    final game = Game(
      config: GameConfig(
        numPlayers: _numPlayers,
        numUndercovers: _numUndercovers,
        includeMrWhite: false,
      ),
      playerNames: names,
      wordCivilian: 'Lightsaber',
      wordUndercover: 'Wand',
    );

    _savePrefs(); // guarda antes de navegar
    Navigator.of(context).pushNamed('/game', arguments: game);
  }
}
