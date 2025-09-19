// lib/app/modules/home/widgets/glass_altar.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class GlassAltar extends StatelessWidget {
  const GlassAltar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.0),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
        ),
        CustomPaint(painter: AltarGridPainter()),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.transparent,
                Colors.white.withOpacity(0.05),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class AltarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.1, paint);
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.33),
      Offset(size.width * 0.9, size.height * 0.33),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.66),
      Offset(size.width * 0.9, size.height * 0.66),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.33, size.height * 0.1),
      Offset(size.width * 0.33, size.height * 0.9),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.66, size.height * 0.1),
      Offset(size.width * 0.66, size.height * 0.9),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
