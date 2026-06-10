import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HATCH BACKGROUND
//
// Hairline diagonal texture — matches the editorial depth of abdulrehmanwaseem.me.
//
// Defaults (tuned to be imperceptible but present):
//   • 45° angle
//   • 16px spacing between lines
//   • 0.5px stroke
//   • 0.025 opacity (dark) / 0.03 opacity (light) — barely visible
//
// All parameters are configurable for denser/lighter variants.
// Uses RepaintBoundary + shouldRepaint guard — zero repaints on scroll.
//
// Usage:
//   HatchBackground(child: Scaffold(...))
//
// Denser variant (e.g. hero section):
//   HatchBackground(
//     spacing: 10,
//     opacity: 0.04,
//     child: HeroContent(),
//   )
// ─────────────────────────────────────────────────────────────────────────────

class HatchBackground extends StatelessWidget {
  final Widget child;

  /// Pixels between parallel hatch lines. Default: 16.
  final double spacing;

  /// Stroke width of each line. Default: 0.5.
  final double strokeWidth;

  /// Line opacity. Default: uses theme-appropriate value (0.025 dark / 0.03 light).
  /// Pass a value to override both light and dark.
  final double? opacity;

  /// Angle in degrees. Default: 45.
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
    // ── 1. Background fill ──────────────────────────────────────────────────
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = isDark ? AppColors.bgDark : AppColors.bgLight
        ..style = PaintingStyle.fill,
    );

    // ── 2. Hatch lines ──────────────────────────────────────────────────────
    final lineColor = (isDark ? Colors.white : Colors.black)
        .withValues(alpha: opacity);

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final rad = angleDeg * math.pi / 180.0;

    // To support arbitrary angles, we use canvas transforms.
    // 1. Translate to center
    // 2. Rotate by angle
    // 3. Draw horizontal lines across an enlarged canvas to cover all corners
    // 4. Restore

    // Diagonal extent needed to cover the full widget at any rotation
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

// ─────────────────────────────────────────────────────────────────────────────
// DOT GRID BACKGROUND (alternative texture)
//
// Small dot grid — more geometric feel for section backgrounds.
// Same zero-repaint design as HatchBackground.
// ─────────────────────────────────────────────────────────────────────────────

class DotGridBackground extends StatelessWidget {
  final Widget child;
  final double spacing;
  final double dotRadius;
  final double? opacity;

  const DotGridBackground({
    super.key,
    required this.child,
    this.spacing = 24.0,
    this.dotRadius = 0.75,
    this.opacity,
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
              painter: _DotGridPainter(
                isDark: isDark,
                spacing: spacing,
                dotRadius: dotRadius,
                opacity: resolvedOpacity,
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

class _DotGridPainter extends CustomPainter {
  final bool isDark;
  final double spacing;
  final double dotRadius;
  final double opacity;

  const _DotGridPainter({
    required this.isDark,
    required this.spacing,
    required this.dotRadius,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = isDark ? AppColors.bgDark : AppColors.bgLight
        ..style = PaintingStyle.fill,
    );

    final dotColor = (isDark ? Colors.white : Colors.black)
        .withValues(alpha: opacity);

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
        old.opacity != opacity;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION DIVIDER
//
// Editorial full-bleed section break matching abdulrehmanwaseem.me.
// Structure:
//   ─────────────────── (top hairline, 0.75px)
//   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ (diagonal stripe band, 18px, 315°)
//   ─────────────────── (bottom hairline, 0.75px)
//
// Zero repaints on scroll — uses RepaintBoundary + shouldRepaint guard.
// ─────────────────────────────────────────────────────────────────────────────

class SectionDivider extends StatelessWidget {
  /// Height of the diagonal stripe band. Default: 20.
  final double bandHeight;

  /// Override stripe opacity (default: 0.06 dark / 0.07 light).
  final double? stripeOpacity;

  /// Include top/bottom hairlines. Default: true.
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
    // Hairline border color — stronger in light mode for visibility
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

    // Draw diagonal lines at 315° (same as reference: repeating-linear-gradient(315deg,...))
    // 315° = upper-right to lower-left direction
    // We draw lines from top-right to bottom-left across the band
    final step = spacing;
    final h = size.height;
    final w = size.width;

    // For 315°, lines go from (x+h, 0) to (x, h) — that's upper-right to lower-left
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

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN LINE DIVIDER
//
// A full-bleed hairline that extends beyond the content width —
// matches the `screen-line-before / screen-line-after` pattern from
// abdulrehmanwaseem.me. Used before/after major content panels.
// ─────────────────────────────────────────────────────────────────────────────

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