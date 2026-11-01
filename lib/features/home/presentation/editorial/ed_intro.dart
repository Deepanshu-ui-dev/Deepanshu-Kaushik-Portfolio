import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_theme.dart';

/// Welcome screen: the profile photo drops into the centre, a greeting rises
/// beneath it, and on tap the photo flies into the hero avatar ([target]) and
/// merges with it while the page fades in behind.
class IntroOverlay extends StatefulWidget {
  final GlobalKey target;
  final VoidCallback onLanded;
  final VoidCallback onDone;
  const IntroOverlay({super.key, required this.target, required this.onLanded, required this.onDone});

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay> with TickerProviderStateMixin {
  late final AnimationController _drop =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
  late final AnimationController _fly =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1050));
  late final AnimationController _hint =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  final _focus = FocusNode(debugLabel: 'intro');

  Rect? _from;
  Rect? _to;
  bool _leaving = false;
  bool _landedCalled = false;

  @override
  void initState() {
    super.initState();
    _drop.forward();
    _fly.addListener(() {
      if (!_landedCalled && _fly.value >= 0.985) {
        _landedCalled = true;
        widget.onLanded();
      }
    });
    _fly.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  void _continue() {
    if (_leaving) return;
    final box = widget.target.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      widget.onLanded();
      widget.onDone();
      return;
    }
    final origin = box.localToGlobal(Offset.zero);
    setState(() {
      _leaving = true;
      _to = origin & box.size;
    });
    _drop.value = 1;
    _fly.forward();
  }

  @override
  void dispose() {
    _drop.dispose();
    _fly.dispose();
    _hint.dispose();
    _focus.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final size = MediaQuery.sizeOf(context);
    final photo = size.width < 600 ? 128.0 : 156.0;
    final restCenter = Offset(size.width / 2, size.height * 0.42);
    _from = Rect.fromCenter(center: restCenter, width: photo, height: photo);

    return Focus(
      focusNode: _focus,
      onKeyEvent: (_, e) {
        if (e is KeyDownEvent &&
            (e.logicalKey == LogicalKeyboardKey.enter ||
                e.logicalKey == LogicalKeyboardKey.space ||
                e.logicalKey == LogicalKeyboardKey.escape)) {
          _continue();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _continue,
        child: MouseRegion(
          cursor: _leaving ? MouseCursor.defer : SystemMouseCursors.click,
          child: AnimatedBuilder(
            animation: Listenable.merge([_drop, _fly, _hint]),
            builder: (context, _) {
              final f = Curves.easeInOutCubic.transform(_fly.value);
              // Background fades once the photo is on its way.
              final bgOpacity = 1 - Curves.easeOut.transform(((_fly.value - 0.15) / 0.75).clamp(0.0, 1.0));

              // Drop: fall from above with a soft landing + tiny squash.
              final d = _drop.value;
              final fall = Curves.easeOutBack.transform((d / 0.55).clamp(0.0, 1.0));
              final dropY = -size.height * 0.6 * (1 - fall);
              final squash = d > 0.32 && d < 0.55 ? math.sin(((d - 0.32) / 0.23) * math.pi) * 0.06 : 0.0;

              Rect rect;
              if (_leaving && _to != null) {
                // Curved flight: lerp the rect, but bow the path upward.
                final base = Rect.lerp(_from, _to, f)!;
                final bow = math.sin(f * math.pi) * -40;
                rect = base.shift(Offset(0, bow));
              } else {
                rect = _from!.shift(Offset(0, dropY));
              }
              final radius = _leaving ? lerpDouble(photo / 2, 8, f) : photo / 2;

              // Text
              final textIn = Curves.easeOutCubic.transform(((d - 0.45) / 0.4).clamp(0.0, 1.0));
              final textOut = _leaving ? (1 - (_fly.value / 0.25).clamp(0.0, 1.0)) : 1.0;
              final textOpacity = textIn * textOut;

              // Landing shadow under the photo
              final shadowT = _leaving ? 0.0 : fall;

              return Stack(children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: bgOpacity,
                    child: Container(
                      color: ed.page,
                      child: CustomPaint(painter: _Grain(ed.line)),
                    ),
                  ),
                ),
                // landing shadow
                if (!_leaving)
                  Positioned(
                    left: restCenter.dx - photo * 0.42 * shadowT,
                    top: _from!.bottom + 18,
                    child: Opacity(
                      opacity: 0.5 * shadowT,
                      child: Container(
                        width: photo * 0.84 * shadowT,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: ed.dark ? 0.8 : 0.35), blurRadius: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                // greeting
                Positioned(
                  left: 24,
                  right: 24,
                  top: _from!.bottom + 44,
                  child: Opacity(
                    opacity: textOpacity,
                    child: Transform.translate(
                      offset: Offset(0, 16 * (1 - textIn)),
                      child: Column(children: [
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(text: 'Hi, I\'m ', style: ed.serif(size.width < 600 ? 34 : 46)),
                            TextSpan(
                              text: PortfolioConfig.shortName,
                              style: ed.serif(size.width < 600 ? 34 : 46, italic: true),
                            ),
                          ]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(PortfolioConfig.headline,
                            textAlign: TextAlign.center, style: ed.mono(12, color: ed.ink2, ls: 0.6)),
                        const SizedBox(height: 34),
                        Opacity(
                          opacity: 0.35 + 0.65 * _hint.value,
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: ed.ink3),
                              ),
                              child: Center(
                                child: Container(
                                  width: 6 + 4 * _hint.value,
                                  height: 6 + 4 * _hint.value,
                                  decoration: BoxDecoration(color: ed.ink2, shape: BoxShape.circle),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('tap to continue', style: ed.mono(10.5, color: ed.ink2, ls: 1.4)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
                // the photo
                Positioned.fromRect(
                  rect: rect,
                  child: Transform.scale(
                    scaleX: 1 + squash,
                    scaleY: 1 - squash,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(
                          color: Color.lerp(ed.paper, ed.line, f)!,
                          width: lerpDouble(4, 1, f),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: (ed.dark ? 0.55 : 0.18) * (1 - f)),
                            blurRadius: 30,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(math.max(0, radius - 1)),
                        child: Image.asset('assets/images/profile.jpeg', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

double lerpDouble(double a, double b, double t) => a + (b - a) * t;

/// Very faint dot texture so the welcome screen isn't a flat fill.
class _Grain extends CustomPainter {
  final Color c;
  const _Grain(this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = c;
    for (double x = 10; x < size.width; x += 22) {
      for (double y = 10; y < size.height; y += 22) {
        canvas.drawCircle(Offset(x, y), 0.8, p);
      }
    }
  }

  @override
  bool shouldRepaint(_Grain o) => o.c != c;
}
