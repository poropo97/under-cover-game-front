import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../models/game.dart';
import '../models/role.dart';
import '../stores/game_store.dart';

/* ----- claves prefs ----- */
const kPrefSetupPlayers     = 'setup_players';
const kPrefSetupUndercovers = 'setup_undercovers';
const kPrefSetupReveal      = 'setup_reveal';
const kPrefSetupNames       = 'setup_names';

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});
  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  int  _numPlayers      = 6;
  int  _numUndercovers  = 1;
  bool _revealUndercover = false;

  late final List<TextEditingController> _controllers =
      List.generate(12, (_) => TextEditingController());
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  /* ───────── prefs ───────── */
  Future<void> _loadPrefs() async {
    _prefs           = await SharedPreferences.getInstance();
    _numPlayers      = _prefs.getInt(kPrefSetupPlayers)     ?? 6;
    _numUndercovers  = _prefs.getInt(kPrefSetupUndercovers) ?? 1;
    _revealUndercover= _prefs.getBool(kPrefSetupReveal)     ?? false;

    final namesJson = _prefs.getString(kPrefSetupNames);
    if (namesJson != null) {
      final list = (jsonDecode(namesJson) as List).cast<String>();
      for (var i = 0; i < list.length && i < _controllers.length; i++) {
        _controllers[i].text = list[i];
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _savePrefs() async {
    await _prefs.setInt (kPrefSetupPlayers    , _numPlayers);
    await _prefs.setInt (kPrefSetupUndercovers, _numUndercovers);
    await _prefs.setBool(kPrefSetupReveal     , _revealUndercover);
    final names = _controllers
        .take(_numPlayers)
        .map((c) => c.text.trim())
        .toList(growable: false);
    await _prefs.setString(kPrefSetupNames, jsonEncode(names));
  }

  /* ───────── helpers ───────── */
  void _updatePlayerCount(int d) {
    final n = (_numPlayers + d).clamp(4, 12);
    if (n == _numPlayers) return;
    setState(() {
      _numPlayers     = n;
      _numUndercovers = _numUndercovers.clamp(1, _numPlayers - 1);
    });
    _savePrefs();
  }

  void _updateUndercoverCount(int d) {
    setState(() {
      _numUndercovers = (_numUndercovers + d).clamp(1, _numPlayers - 1);
    });
    _savePrefs();
  }

  /* ───────── UI ───────── */
  @override
  Widget build(BuildContext context) {
    final t  = AppLocalizations.of(context)!;
    final th = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.setup_title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(t.setup_num_players,
                style: th.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            _numberPicker(
              value: _numPlayers,
              onMinus: () => _updatePlayerCount(-1),
              onPlus : () => _updatePlayerCount(1),
            ),
            const SizedBox(height: 16),

            /* ---- lista de nombres reordenable ---- */
            ReorderableListView.builder(
              itemCount: _numPlayers,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldI, newI) {
                setState(() {
                  if (newI > oldI) newI -= 1;
                  final c = _controllers.removeAt(oldI);
                  _controllers.insert(newI, c);
                });
                _savePrefs();
              },
              itemBuilder: (_, i) => ListTile(
                key : ValueKey('p_$i'),
                title: TextField(
                  controller: _controllers[i],
                  decoration: InputDecoration(
                    hintText: t.setup_player_hint(i + 1),
                    border  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    isCollapsed: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (_) => _savePrefs(),
                ),
                trailing: const Icon(Icons.drag_handle),
              ),
            ),

            const SizedBox(height: 16),
            Text(t.setup_settings,
                style: th.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            _numberPicker(
              label  : t.setup_undercover_count,
              value  : _numUndercovers,
              onMinus: () => _updateUndercoverCount(-1),
              onPlus : () => _updateUndercoverCount(1),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(t.setup_extra_options,
                  style: th.textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _revealUndercover,
              title: Text(t.setup_reveal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: th.colorScheme.outlineVariant),
              ),
              onChanged: (v) {
                setState(() => _revealUndercover = v);
                _savePrefs();
              },
            ),
            const SizedBox(height: 24),

            /* ---- botón iniciar ---- */
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: _startGame,
                child: Text(t.setup_start,
                    style: const TextStyle(fontSize: 18, letterSpacing: 1.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---- widgets auxiliares ---- */
  Widget _numberPicker({
    String? label,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    final th = Theme.of(context);
    return Column(
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(label, style: th.textTheme.bodyMedium),
          ),
        Container(
          decoration: BoxDecoration(
            color: th.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _roundBtn(Icons.remove, onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text('$value', style: const TextStyle(fontSize: 24)),
              ),
              _roundBtn(Icons.add, onPlus),
            ],
          ),
        ),
      ],
    );
  }

  Widget _roundBtn(IconData i, VoidCallback tap) => InkWell(
        onTap: tap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(i, size: 24),
        ),
      );

  /* ---- crear objeto Game y navegar ---- */
  void _startGame() {
    final names = List.generate(_numPlayers, (i) {
      final txt = _controllers[i].text.trim();
      return txt.isEmpty ? 'Player ${i + 1}' : txt;
    });

    final game = Game(
      config: GameConfig(
        numPlayers     : _numPlayers,
        numUndercovers : _numUndercovers,
        includeMrWhite : false,
      ),
      playerNames   : names,
      wordCivilian  : 'Lightsaber',
      wordUndercover: 'Wand',
    );

    _savePrefs();
    context.read<GameStore>().start(game);

    Navigator.of(context).pushNamed(
      '/reveal',
      arguments: {'index': 0, 'reveal': _revealUndercover},
    );
  }
}
