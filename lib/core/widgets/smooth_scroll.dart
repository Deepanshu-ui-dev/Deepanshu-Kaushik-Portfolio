import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Inertial mouse-wheel scrolling for web/desktop.
///
/// Wheel notches move a target offset; a ticker eases the real offset toward
/// it every frame (frame-rate independent exponential smoothing). Unlike
/// restarting `animateTo` on every notch, velocity stays continuous, so fast
/// wheel spins glide instead of stuttering.
///
/// Trackpads already send fine-grained, momentum-smoothed deltas, so small
/// deltas are left to the platform's native scrolling.
class SmoothScroll extends StatefulWidget {
  final ScrollController controller;
  final Widget child;

  /// Fraction of the remaining distance covered per 60 Hz frame (0–1).
  /// Higher is snappier, lower is floatier.
  final double smoothing;

  const SmoothScroll({
    super.key,
    required this.controller,
    required this.child,
    this.smoothing = 0.16,
  });

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  double _target = 0;
  double _current = 0;
  Duration _last = Duration.zero;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final c = widget.controller;
    if (!c.hasClients) return;
    final delta = event.scrollDelta.dy;
    if (delta.abs() < 20) return; // trackpad: keep native momentum

    GestureBinding.instance.pointerSignalResolver.register(event, (_) {});

    final pos = c.position;
    if (!_ticker.isActive) {
      _current = pos.pixels;
      _target = pos.pixels;
      _last = Duration.zero;
      _ticker.start();
    }
    _target = (_target + delta).clamp(pos.minScrollExtent, pos.maxScrollExtent);
  }

  void _tick(Duration elapsed) {
    final c = widget.controller;
    if (!c.hasClients) return _ticker.stop();
    final pos = c.position;

    // Something else moved the page (scrollbar drag, keyboard, animateTo):
    // hand control back instead of fighting it.
    if ((pos.pixels - _current).abs() > 1.5) return _ticker.stop();

    final dtFrames = _last == Duration.zero
        ? 1.0
        : ((elapsed - _last).inMicroseconds / 16667).clamp(0.25, 4.0);
    _last = elapsed;

    final k = 1 - math.pow(1 - widget.smoothing, dtFrames);
    _target = _target.clamp(pos.minScrollExtent, pos.maxScrollExtent);
    final remaining = _target - _current;
    if (remaining.abs() < 0.5) {
      _current = _target;
      pos.jumpTo(_current);
      return _ticker.stop();
    }
    _current += remaining * k;
    pos.jumpTo(_current);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(onPointerSignal: _onPointerSignal, child: widget.child);
  }
}
