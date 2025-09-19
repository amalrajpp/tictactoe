// lib/app/modules/home/widgets/misc_widgets.dart
import 'dart:math';
import 'package:flutter/material.dart';

class EmpoweredTileAura extends StatefulWidget {
  const EmpoweredTileAura({Key? key}) : super(key: key);
  @override
  _EmpoweredTileAuraState createState() => _EmpoweredTileAuraState();
}

class _EmpoweredTileAuraState extends State<EmpoweredTileAura>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1 + _controller.value * 0.2),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WinningLineOverlay extends StatefulWidget {
  final List<int> winningLine;
  final Color color;
  const WinningLineOverlay({
    Key? key,
    required this.winningLine,
    required this.color,
  }) : super(key: key);
  @override
  _WinningLineOverlayState createState() => _WinningLineOverlayState();
}

class _WinningLineOverlayState extends State<WinningLineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WinningLinePainter(
        winningLine: widget.winningLine,
        color: widget.color,
        progress: _controller.value,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _WinningLinePainter extends CustomPainter {
  final List<int> winningLine;
  final Color color;
  final double progress;
  _WinningLinePainter({
    required this.winningLine,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintGlow = Paint()
      ..color = color.withOpacity(0.7)
      ..strokeWidth = 16.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);
    final paintCore = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    final tileSize = size.width / 3;
    final halfTile = tileSize / 2;
    Offset getTileCenter(int index) {
      final col = index % 3;
      final row = index ~/ 3;
      return Offset(col * tileSize + halfTile, row * tileSize + halfTile);
    }

    final startPoint = getTileCenter(winningLine.first);
    final endPoint = getTileCenter(winningLine.last);
    final currentPoint = Offset.lerp(startPoint, endPoint, progress)!;
    canvas.drawLine(startPoint, currentPoint, paintGlow);
    canvas.drawLine(startPoint, currentPoint, paintCore);
  }

  @override
  bool shouldRepaint(_WinningLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class ParticleBurst extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  const ParticleBurst({Key? key, required this.controller, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => controller.isAnimating
          ? CustomPaint(
              painter: _BurstPainter(progress: controller.value, color: color),
              child: const SizedBox.expand(),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _BurstPainter extends CustomPainter {
  final double progress;
  final Color color;
  _BurstPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    double opacity = 1.0 - progress;
    double radius = size.width / 2 * progress;
    canvas.drawCircle(
      size.center(Offset.zero),
      radius,
      paint..color = color.withOpacity(opacity),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RunePainter extends CustomPainter {
  final String mark;
  final double progress;
  RunePainter({required this.mark, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (mark == 'X') {
      final double halfProgress = progress * 2;
      // Draw first slash
      canvas.drawLine(
        const Offset(0, 0),
        Offset(
          size.width * min(1.0, halfProgress),
          size.height * min(1.0, halfProgress),
        ),
        paint,
      );
      // Draw second slash
      if (halfProgress > 1.0) {
        canvas.drawLine(
          Offset(size.width, 0),
          Offset(
            size.width * (1 - (halfProgress - 1)),
            size.height * (halfProgress - 1),
          ),
          paint,
        );
      }
    } else if (mark == 'O') {
      canvas.drawArc(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2,
        ),
        -pi / 2,
        2 * pi * progress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RunePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.mark != mark;
}
