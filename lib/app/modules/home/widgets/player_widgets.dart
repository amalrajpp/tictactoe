// lib/app/modules/home/widgets/player_widgets.dart
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

class PlayerPod extends StatefulWidget {
  final String player;
  final bool isActive;
  const PlayerPod({Key? key, required this.player, required this.isActive})
    : super(key: key);
  @override
  _PlayerPodState createState() => _PlayerPodState();
}

class _PlayerPodState extends State<PlayerPod>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.player == 'X'
        ? CustomColors.player1Color
        : CustomColors.player2Color;
    final playerName = widget.player == 'X' ? 'PLAYER 1' : 'PLAYER 2';
    return Expanded(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final shadowOpacity = widget.isActive
              ? 0.4 + _controller.value * 0.4
              : 0.0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(widget.isActive ? 0.5 : 0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(widget.isActive ? 0.7 : 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(shadowOpacity),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              playerName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              widget.player,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VictoryHeader extends StatelessWidget {
  final String winner;
  const VictoryHeader({Key? key, required this.winner}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final victoryText = winner == 'X' ? 'PLAYER 1 WINS!' : 'PLAYER 2 WINS!';
    final color = winner == 'X'
        ? CustomColors.player1Color
        : CustomColors.player2Color;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: color, blurRadius: 25, spreadRadius: 5)],
        ),
        child: Text(
          victoryText,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
