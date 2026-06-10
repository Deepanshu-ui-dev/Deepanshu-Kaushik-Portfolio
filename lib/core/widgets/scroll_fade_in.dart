import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A wrapper that plays a spring-driven fade + slide-up the first time
/// its child is built in the widget tree.
///
/// Uses FadeTransition + SlideTransition (GPU-composited) instead of
/// Opacity + FractionalTranslation so the animation runs entirely on the
/// raster thread with zero CPU cost per frame.
class ScrollFadeIn extends StatefulWidget {
  final Widget child;

  /// Extra delay before the animation starts (for staggering siblings).
  final Duration delay;

  /// How far the widget slides up from (fraction of its own height).
  final double slideBegin;

  const ScrollFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideBegin = 0.035,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  // Unbounded controller — spring can overshoot past 1.0
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  /// Whether _trigger() has been called and completed at least one
  /// successful animateWith() call (i.e., the ticker was enabled).
  bool _animated = false;

  @override
  void initState() {
    super.initState();

    // Unbounded so the spring overshoot is not silently clamped
    _ctrl = AnimationController.unbounded(vsync: this)..value = 0.0;

    // _ClampedTween.transform() clamps t to [0,1] BEFORE delegating to
    // super.transform(). This is the only correct way to guard against
    // spring overshoot — overriding Curve.transformInternal() does NOT work
    // because Curve.transform() asserts t ∈ [0,1] before calling it.
    _opacity = _ClampedTween(begin: 0.0, end: 1.0).animate(_ctrl);

    // Slide from slideBegin → 0 offset (Offset lerp has no [0,1] assert)
    _slide = _ctrl.drive(
      Tween<Offset>(
        begin: Offset(0, widget.slideBegin),
        end: Offset.zero,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-attempt animation when TickerMode flips from disabled → enabled.
    // This handles the case where the widget was built inside an Offstage
    // or TickerMode(enabled: false) screen and the ticker was not yet active.
    if (!_animated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
    }
  }

  void _maybeAnimate() {
    if (_animated || !mounted) return;

    // Check if our ticker is actually enabled — if TickerMode is disabled,
    // animateWith() is a no-op and we must retry later (via didChangeDependencies).
    final tickerEnabled = TickerMode.of(context);
    if (!tickerEnabled) return;

    _animated = true;

    void runSpring() {
      if (!mounted) return;
      _ctrl.animateWith(
        SpringSimulation(
          const SpringDescription(
            mass: 0.5,
            stiffness: 200,
            damping: 18,
          ),
          0.0, // start value
          1.0, // end value
          0.0, // initial velocity
        ),
      );
    }

    if (widget.delay == Duration.zero) {
      runSpring();
    } else {
      Future.delayed(widget.delay, runSpring);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FadeTransition and SlideTransition are GPU-composited:
    // they never trigger a repaint of the child — only the raster layer
    // is composited at the new opacity/offset each frame.
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

/// A [Tween<double>] whose [transform] clamps [t] to [0, 1] before
/// evaluating, safely absorbing spring-animation overshoot.
///
/// Why not CurveTween + a clamping Curve?
/// [Curve.transform] asserts `t >= 0.0 && t <= 1.0` BEFORE calling
/// [transformInternal], so any subclass override of [transformInternal]
/// never executes when t is out of range. Clamping must happen at the
/// [Tween.transform] level instead.
class _ClampedTween extends Tween<double> {
  _ClampedTween({required super.begin, required super.end});

  @override
  double transform(double t) => super.transform(t.clamp(0.0, 1.0));
}
