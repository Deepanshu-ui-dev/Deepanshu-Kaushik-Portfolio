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
  bool _triggered = false;

  @override
  void initState() {
    super.initState();

    // Unbounded so spring overshoot is not silently clamped
    _ctrl = AnimationController.unbounded(vsync: this);

    // Clamp the unbounded value to [0,1] for opacity
    _opacity = _ctrl.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 1.0, curve: Curves.linear)),
      ),
    );

    // Slide from slideBegin → 0 offset
    _slide = _ctrl.drive(
      Tween<Offset>(
        begin: Offset(0, widget.slideBegin),
        end: Offset.zero,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
  }

  void _maybeAnimate() {
    if (_triggered || !mounted) return;
    _triggered = true;

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
      opacity: _opacity.drive(
        Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: const _ClampCurve())),
      ),
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

/// Clamps the animation value to [0, 1] so spring overshoot doesn't cause
/// opacity > 1 (which would be invisible but wastes compositing budget).
class _ClampCurve extends Curve {
  const _ClampCurve();
  @override
  double transformInternal(double t) => t.clamp(0.0, 1.0);
}
