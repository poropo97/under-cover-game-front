import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/game_header.dart';
import '../models/role.dart';
import '../stores/game_store.dart';

/*──────────────── Wrapper ───────────────*/
class RevealWordScreenWrapper extends StatelessWidget {
  const RevealWordScreenWrapper({
    super.key,
    required this.index,
    required this.reveal,
  });

  final int  index;
  final bool reveal;

  @override
  Widget build(BuildContext context) {
    final store = context.read<GameStore>();

    // Guard: si no hay partida o el índice es inválido → volver al menú
    if (store.game == null ||
        index < 0 ||
        index >= store.game!.players.length) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).popUntil((r) => r.isFirst),
      );
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return RevealWordScreen().buildWith(context, index, reveal);
  }
}

/*────────────────────────────────────────*/
class RevealWordScreen extends StatelessWidget {
  const RevealWordScreen({super.key});

  // Evita que se use directamente; obliga a pasar por buildWith
  @override
  Widget build(BuildContext _) =>
      throw UnsupportedError('Use buildWith()');

  /// Construye la pantalla pasándole datos de índice y si se revela rol.
  Widget buildWith(BuildContext context, int index, bool revealRole) {
    final game   = context.read<GameStore>().game!;
    final player = game.players[index];
    final role   = player.role;
    final isSpy  = role == Role.undercover || role == Role.mrWhite;
    final word   = isSpy ? game.wordUndercover : game.wordCivilian;
    final isLast = index == game.players.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          /* ─────────── CONTENIDO PRINCIPAL ─────────── */
          _RevealBody(
            playerName : player.name,
            word       : word,
            isSpy      : isSpy,
            revealRole : revealRole,
            isLast     : isLast,
            onNext     : () {
              if (isLast) {
                // → Fase discusión
                Navigator.of(context).pushReplacementNamed('/discussion');
              } else {
                Navigator.of(context).pushReplacementNamed(
                  '/reveal',
                  arguments: {'index': index + 1, 'reveal': revealRole},
                );
              }
            },
          ),

          /* ─────────── CABECERA FLOTANTE ─────────── */
          const GameHeader(title: 'Show your word'),
        ],
      ),
    );
  }
}

/*──────── Body con flip 3D ────────*/
class _RevealBody extends StatefulWidget {
  const _RevealBody({
    required this.playerName,
    required this.word,
    required this.isSpy,
    required this.revealRole,
    required this.isLast,
    required this.onNext,
  });

  final String playerName;
  final String word;
  final bool   isSpy;
  final bool   revealRole;
  final bool   isLast;
  final VoidCallback onNext;

  @override
  State<_RevealBody> createState() => _RevealBodyState();
}

class _RevealBodyState extends State<_RevealBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  bool get _flipped => _ctrl.value >= .5;
  bool _everRevealed = false;

  void _flipCard() async {
    if (_flipped) return;
    await _ctrl.forward();
    setState(() => _everRevealed = true);
  }

  void _hideCard() => _ctrl.reverse();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 140, bottom: 40),
        child: Column(
          children: [
            Text('Pass the device to', style: th.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              widget.playerName,
              style: th.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            /*──── Carta ────*/
            GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) {
                  final angle  = _ctrl.value * math.pi;
                  final isBack = angle > math.pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .001)
                      ..rotateY(angle),
                    child: isBack ? _backFace(th) : _frontFace(th),
                  );
                },
              ),
            ),

            const SizedBox(height: 48),

            if (_everRevealed)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: _hideCard,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text('Hide'),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: widget.onNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      widget.isLast ? 'Start discussion' : 'Next player',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /*─────────── Caras de la carta ───────────*/

  Widget _frontFace(ThemeData th) => Container(
        width: 220,
        height: 220,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        decoration: BoxDecoration(
          color: th.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black26,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.visibility, size: 64, color: th.colorScheme.primary),
            const SizedBox(height: 12),
            const Text('Tap to reveal', style: TextStyle(fontSize: 18)),
          ],
        ),
      );

  Widget _backFace(ThemeData th) => Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(math.pi),
        child: Container(
          width: 220,
          height: 220,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
          decoration: BoxDecoration(
            color: th.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black26,
                offset: Offset(0, 6),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.word,
                style: th.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (widget.revealRole && widget.isSpy) ...[
                const SizedBox(height: 8),
                Text(
                  '(Undercover)',
                  style: th.textTheme.bodyMedium?.copyWith(
                    color: th.colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}
