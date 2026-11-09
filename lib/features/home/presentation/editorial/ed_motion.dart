import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'ed_theme.dart';

/// True when the OS asks for reduced motion — every effect here honours it.
bool edReduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

// ════════════════════════════════════════════════════════════════════
//  EdReveal — fades in from a soft blur + small rise the first time the
//  widget scrolls into view. Mirrors a CSS `.reveal` → `.visible` swap.
// ════════════════════════════════════════════════════════════════════

class EdReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double rise;
  final double blur;
  const EdReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.rise = 14,
    this.blur = 10,
  });

  @override
  State<EdReveal> createState() => _EdRevealState();
}

class _EdRevealState extends State<EdReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
  late final Animation<double> _t = CurvedAnimation(parent: _c, curve: Ed.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(0, widget.rise),
    end: Offset.zero,
  ).animate(_t);
  late final Key _vk = Key('reveal-${identityHashCode(this)}');
  Timer? _delay;
  bool _started = false;

  void _start() {
    if (_started || !mounted) return;
    _started = true;
    if (edReduceMotion(context)) {
      _c.value = 1;
      return;
    }
    // Delays are kept short so content never feels like it is lagging.
    final d = widget.delay.inMilliseconds ~/ 2;
    if (d == 0) {
      _c.forward();
    } else {
      _delay = Timer(Duration(milliseconds: d), () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _delay?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No blur filter here: ImageFiltered over whole sections is extremely
    // expensive on Flutter web and was the main source of jank.
    return VisibilityDetector(
      key: _vk,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.02) _start();
      },
      child: RepaintBoundary(
        child: FadeTransition(
          opacity: _t,
          child: AnimatedBuilder(
            animation: _slide,
            child: widget.child,
            builder: (_, child) => _c.isCompleted
                ? child!
                : Transform.translate(offset: _slide.value, child: child),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════

class SplitReveal extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final Duration stagger;
  const SplitReveal(
    this.text, {
    super.key,
    required this.style,
    this.delay = Duration.zero,
    this.stagger = const Duration(milliseconds: 22),
  });

  @override
  State<SplitReveal> createState() => _SplitRevealState();
}

class _SplitRevealState extends State<SplitReveal> with SingleTickerProviderStateMixin {
  static const _each = 450; // ms per letter
  late final int _total =
      widget.delay.inMilliseconds + widget.stagger.inMilliseconds * widget.text.length + _each;
  late final AnimationController _c =
      AnimationController(vsync: this, duration: Duration(milliseconds: _total));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c.status == AnimationStatus.dismissed) {
      if (edReduceMotion(context)) {
        _c.value = 1;
      } else {
        _c.forward();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chars = widget.text.characters.toList();
    return Semantics(
      label: widget.text,
      header: true,
      excludeSemantics: true,
      child: RepaintBoundary(child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          if (_c.isCompleted) return Text(widget.text, style: widget.style);
          final now = _c.value * _total;
          return Wrap(children: [
            for (int i = 0; i < chars.length; i++)
              Builder(builder: (_) {
                final start = widget.delay.inMilliseconds + widget.stagger.inMilliseconds * i;
                final raw = ((now - start) / _each).clamp(0.0, 1.0);
                final v = Ed.easeOut.transform(raw);
                final glyph = Text(chars[i], style: widget.style);
                if (v >= 0.999) return glyph;
                return Opacity(
                  opacity: v,
                  child: Transform.translate(
                    offset: Offset(0, (widget.style.fontSize ?? 20) * 0.22 * (1 - v)),
                    child: glyph,
                  ),
                );
              }),
          ]);
        },
      )),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  PaperGrain — a faint, jittering film-grain overlay over the whole page.
// ════════════════════════════════════════════════════════════════════

class PaperGrain extends StatefulWidget {
  final double opacity;
  const PaperGrain({super.key, this.opacity = 0.03});

  @override
  State<PaperGrain> createState() => _PaperGrainState();
}

class _PaperGrainState extends State<PaperGrain> {
  static ui.Image? _tile;
  static Future<ui.Image>? _loading;

  static Future<ui.Image> _makeTile() {
    const size = 160;
    final rnd = math.Random(7);
    final px = Uint8List(size * size * 4);
    for (int i = 0; i < size * size; i++) {
      final g = rnd.nextInt(256);
      px[i * 4] = g;
      px[i * 4 + 1] = g;
      px[i * 4 + 2] = g;
      px[i * 4 + 3] = 255;
    }
    final c = Completer<ui.Image>();
    ui.decodeImageFromPixels(px, size, size, ui.PixelFormat.rgba8888, c.complete);
    return c.future;
  }

  @override
  void initState() {
    super.initState();
    _loading ??= _makeTile();
    _loading!.then((img) {
      _tile = img;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Static grain: the old 280ms jitter repainted a full-viewport layer
    // forever, which cost frames on every scroll.
    final tile = _tile;
    if (tile == null) return const SizedBox.shrink();
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _GrainPainter(tile, Offset.zero, widget.opacity),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GrainPainter extends CustomPainter {
  final ui.Image tile;
  final Offset shift;
  final double opacity;
  _GrainPainter(this.tile, this.shift, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final m = Matrix4.translationValues(shift.dx, shift.dy, 0).storage;
    // Paint alpha modulates the shader directly — no offscreen saveLayer.
    canvas.drawRect(
      rect,
      Paint()
        ..color = Color.fromRGBO(0, 0, 0, opacity)
        ..shader = ImageShader(tile, TileMode.repeated, TileMode.repeated, m),
    );
  }

  @override
  bool shouldRepaint(_GrainPainter old) => old.shift != shift || old.tile != tile || old.opacity != opacity;
}

// ════════════════════════════════════════════════════════════════════
//  Dashed rules — the 1px-on / 3px-off hairlines that frame the column.
// ════════════════════════════════════════════════════════════════════

class DashedRulePainter extends CustomPainter {
  final Color color;
  final bool top, bottom, left, right;
  final double dash, gap;
  const DashedRulePainter(
    this.color, {
    this.top = false,
    this.bottom = false,
    this.left = false,
    this.right = false,
    this.dash = 1,
    this.gap = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    final step = dash + gap;
    if (top || bottom) {
      for (double x = 0; x < size.width; x += step) {
        if (top) canvas.drawRect(Rect.fromLTWH(x, 0, dash, 1), p);
        if (bottom) canvas.drawRect(Rect.fromLTWH(x, size.height - 1, dash, 1), p);
      }
    }
    if (left || right) {
      for (double y = 0; y < size.height; y += step) {
        if (left) canvas.drawRect(Rect.fromLTWH(0, y, 1, dash), p);
        if (right) canvas.drawRect(Rect.fromLTWH(size.width - 1, y, 1, dash), p);
      }
    }
  }

  @override
  bool shouldRepaint(DashedRulePainter old) =>
      old.color != color || old.top != top || old.bottom != bottom || old.left != left || old.right != right;
}

/// A dashed border drawn around a rounded box (used by the "ask" chips).
class DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  const DashedRRectPainter(this.color, {this.radius = 99});

  @override
  void paint(Canvas canvas, Size size) {
    final rr = RRect.fromRectAndRadius(
        (Offset.zero & size).deflate(0.5), Radius.circular(math.min(radius, size.height / 2)));
    final path = Path()..addRRect(rr);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 6) {
        canvas.drawPath(metric.extractPath(d, math.min(d + 3, metric.length)), p);
      }
    }
  }

  @override
  bool shouldRepaint(DashedRRectPainter old) => old.color != color || old.radius != radius;
}
