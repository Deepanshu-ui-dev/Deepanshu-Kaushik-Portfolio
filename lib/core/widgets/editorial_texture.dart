import 'package:flutter/material.dart';



class GrainOverlay extends StatelessWidget {
  final Widget child;
  final double opacity;

  const GrainOverlay({
    super.key,
    required this.child,
    this.opacity = 0.012, 
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        IgnorePointer(
          child: RepaintBoundary(
            child: Opacity(
              opacity: opacity,
              child: const _NoiseTexture(),
            ),
          ),
        ),
      ],
    );
  }
}

class _NoiseTexture extends StatelessWidget {
  const _NoiseTexture();

  @override
  Widget build(BuildContext context) {
    
    
    return CustomPaint(
      painter: _NoisePainter(),
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    
    final random = _SeededRandom(42);
    
    
    
    
    const step = 2.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        if (random.nextDouble() > 0.5) {
          canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeededRandom {
  int seed;
  _SeededRandom(this.seed);
  double nextDouble() {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return seed / 0x7fffffff;
  }
}
