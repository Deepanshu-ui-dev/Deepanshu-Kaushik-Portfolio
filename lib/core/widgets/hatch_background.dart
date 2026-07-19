import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';


























class HatchBackground extends StatelessWidget {
  final Widget child;

  
  final double spacing;

  
  final double strokeWidth;

  
  
  final double? opacity;

  
  final double angleDeg;

  const HatchBackground({
    super.key,
    required this.child,
    this.spacing = 16.0,
    this.strokeWidth = 0.5,
    this.opacity,
    this.angleDeg = 45.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedOpacity = opacity ?? (isDark ? 0.06 : 0.08);

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _HatchPainter(
                isDark: isDark,
                spacing: spacing,
                strokeWidth: strokeWidth,
                opacity: resolvedOpacity,
                angleDeg: angleDeg,
              ),
              isComplex: true,
              willChange: false,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _HatchPainter extends CustomPainter {
  final bool isDark;
  final double spacing;
  final double strokeWidth;
  final double opacity;
  final double angleDeg;

  const _HatchPainter({
    required this.isDark,
    required this.spacing,
    required this.strokeWidth,
    required this.opacity,
    required this.angleDeg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = isDark ? AppColors.bgDark : AppColors.bgLight
        ..style = PaintingStyle.fill,
    );

    
    final lineColor = (isDark ? Colors.white : Colors.black)
        .withValues(alpha: opacity);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final rad = angleDeg * math.pi / 180.0;

    
    
    
    
    

    
    final diagonal = math.sqrt(size.width * size.width + size.height * size.height);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rad);

    final halfD = diagonal / 2;

    double y = -halfD;
    while (y <= halfD) {
      canvas.drawLine(Offset(-halfD, y), Offset(halfD, y), paint);
      y += spacing;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HatchPainter old) {
    return old.isDark != isDark ||
        old.spacing != spacing ||
        old.strokeWidth != strokeWidth ||
        old.opacity != opacity ||
        old.angleDeg != angleDeg;
  }
}








class DotGridBackground extends StatelessWidget {
  final Widget child;
  final double spacing;
  final double dotRadius;
  final double? opacity;
  final bool drawBackground;
  final bool enableVignette;

  const DotGridBackground({
    super.key,
    required this.child,
    this.spacing = 24.0,
    this.dotRadius = 0.75,
    this.opacity,
    this.drawBackground = true,
    this.enableVignette = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedOpacity = opacity ?? (isDark ? 0.09 : 0.12);

    Widget dotLayer = CustomPaint(
      painter: _DotGridPainter(
        isDark: isDark,
        spacing: spacing,
        dotRadius: dotRadius,
        opacity: resolvedOpacity,
        drawBackground: drawBackground,
      ),
      isComplex: true,
      willChange: false,
    );

    if (enableVignette) {
      dotLayer = ShaderMask(
        shaderCallback: (Rect bounds) {
          
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.0),
              Colors.black.withValues(alpha: 1.0),
              Colors.black.withValues(alpha: 1.0),
              Colors.black.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.18, 0.82, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              center: Alignment.center,
              radius: 0.90,
              colors: [
                Colors.black.withValues(alpha: 1.0),
                Colors.black.withValues(alpha: 0.0),
              ],
              stops: const [0.45, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: dotLayer,
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: dotLayer,
          ),
        ),
        child,
      ],
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final bool isDark;
  final double spacing;
  final double dotRadius;
  final double opacity;
  final bool drawBackground;

  const _DotGridPainter({
    required this.isDark,
    required this.spacing,
    required this.dotRadius,
    required this.opacity,
    this.drawBackground = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drawBackground) {
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..color = isDark ? AppColors.bgDark : AppColors.bgLight
          ..style = PaintingStyle.fill,
      );
    }

    
    
    final dotColor = isDark
        ? Colors.white.withValues(alpha: opacity)
        : const Color(0xFF71717A).withValues(alpha: opacity); 

    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter old) {
    return old.isDark != isDark ||
        old.spacing != spacing ||
        old.dotRadius != dotRadius ||
        old.drawBackground != drawBackground ||
        old.opacity != opacity;
  }
}













class SectionDivider extends StatelessWidget {
  
  final double bandHeight;

  
  final double? stripeOpacity;

  
  final bool showLines;

  const SectionDivider({
    super.key,
    this.bandHeight = 20,
    this.stripeOpacity,
    this.showLines = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final lineColor = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final opacity = stripeOpacity ?? (isDark ? 0.06 : 0.08);
    final stripeColor = (isDark ? Colors.white : Colors.black).withValues(alpha: opacity);

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLines)
            Container(height: 0.75, color: lineColor),
          SizedBox(
            height: bandHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: _HatchBandPainter(
                color: stripeColor,
                spacing: 7.0,
                angleDeg: 315.0,
                lineWidth: isDark ? 0.75 : 1.0,
              ),
              isComplex: true,
              willChange: false,
            ),
          ),
          if (showLines)
            Container(height: 0.75, color: lineColor),
        ],
      ),
    );
  }
}

class _HatchBandPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double angleDeg;
  final double lineWidth;

  const _HatchBandPainter({
    required this.color,
    this.spacing = 7.0,
    this.angleDeg = 315.0,
    this.lineWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    
    
    
    final step = spacing;
    final h = size.height;
    final w = size.width;

    
    for (double x = -h; x < w + h; x += step) {
      canvas.drawLine(
        Offset(x + h, 0),
        Offset(x, h),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HatchBandPainter old) =>
      old.color != color ||
      old.spacing != spacing ||
      old.angleDeg != angleDeg ||
      old.lineWidth != lineWidth;
}









class ScreenLineDivider extends StatelessWidget {
  final double thickness;

  const ScreenLineDivider({super.key, this.thickness = 0.5});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.borderDark : AppColors.borderLight;
    return Container(
      height: thickness,
      width: double.infinity,
      color: color,
    );
  }
}