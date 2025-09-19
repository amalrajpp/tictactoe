// lib/app/modules/home/widgets/wave_container.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;
import '../../../utils/app_colors.dart';

enum ParticleType { none, fire, water }

class WaveContainer extends StatefulWidget {
  const WaveContainer({
    Key? key,
    required this.size,
    required this.offset,
    this.color,
    this.duration = const Duration(seconds: 4),
    this.sinWidthFraction = 3,
    this.fillController,
    this.particleType = ParticleType.none,
  }) : super(key: key);
  final Size size;
  final Offset offset;
  final Color? color;
  final Duration duration;
  final int sinWidthFraction;
  final AnimationController? fillController;
  final ParticleType particleType;
  @override
  State<StatefulWidget> createState() => _WaveContainerState();
}

class _WaveContainerState extends State<WaveContainer>
    with TickerProviderStateMixin {
  late AnimationController _waveController, _amplitudeController;
  late Animation<double> _amplitudeAnimation;
  List<Offset> _wavePoints = [];
  List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _amplitudeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _amplitudeAnimation = Tween<double>(begin: 15.0, end: 4.0)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(_amplitudeController);
    widget.fillController?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _amplitudeController.forward(from: 0);
      }
    });
    final listener = () => _updateWaveAndParticles();
    _waveController.addListener(listener);
    _amplitudeController.addListener(listener);
    if (widget.particleType != ParticleType.none) {
      for (int i = 0; i < 20; i++) {
        _particles.add(Particle(random: _random, size: widget.size));
      }
    }
  }

  void _updateWaveAndParticles() {
    if (!mounted) return;
    final double amplitude = widget.fillController == null
        ? 8.0
        : (widget.fillController!.isAnimating
              ? 15.0
              : _amplitudeAnimation.value);
    final newPoints = <Offset>[];
    for (
      double i = -2 - widget.offset.dx;
      i <= widget.size.width.toInt() + 2;
      i++
    ) {
      newPoints.add(
        Offset(
          i.toDouble() + widget.offset.dx,
          sin(
                    (((_waveController.value * 360 - i) %
                            360 *
                            vector.degrees2Radians) *
                        widget.sinWidthFraction),
                  ) *
                  amplitude +
              10 +
              widget.offset.dy,
        ),
      );
    }
    for (var particle in _particles) {
      particle.update(widget.size);
    }
    setState(() => _wavePoints = newPoints);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _amplitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(
        wavePoints: _wavePoints,
        color: widget.color ?? CustomColors.player1Color,
        particles: _particles,
        particleType: widget.particleType,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class WavePainter extends CustomPainter {
  final List<Offset> wavePoints;
  final Color color;
  final List<Particle> particles;
  final ParticleType particleType;
  WavePainter({
    required this.wavePoints,
    required this.color,
    required this.particles,
    required this.particleType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (wavePoints.isNotEmpty) {
      path.addPolygon(wavePoints, false);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }
    canvas.drawPath(path, Paint()..color = color);
    if (particleType != ParticleType.none) {
      final paint = Paint();
      for (var p in particles) {
        if (particleType == ParticleType.fire) {
          paint.color = Colors.orangeAccent.withOpacity(p.opacity);
        } else {
          paint.color = Colors.white.withOpacity(p.opacity);
        }
        canvas.drawCircle(p.position, p.radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class Particle {
  Offset position;
  double radius;
  double opacity;
  double ySpeed;
  final Random random;
  Particle({required this.random, required Size size})
    : position = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      ),
      radius = random.nextDouble() * 2 + 1,
      opacity = random.nextDouble() * 0.5 + 0.2,
      ySpeed = random.nextDouble() * -0.5 - 0.2;
  void update(Size size) {
    position = Offset(position.dx, position.dy + ySpeed);
    if (position.dy < 0) {
      position = Offset(random.nextDouble() * size.width, size.height);
    }
  }
}
