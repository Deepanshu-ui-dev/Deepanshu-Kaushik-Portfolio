import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A wrapper that plays a spring-driven fade + slide-up the first time
/// its child is built in the widget tree.
///
/// Uses a SpringSimulation so the entrance feels alive and physical —
/// the element snaps up and gently overshoots before settling, rather
/// than decelerating at a fixed mathematical rate.
///
/// Spring presets:
///   mass: 0.5   → light, responsive object
///   stiffness: 220 → pulls back quickly, sharp entry
///   damping: 22    → just enough bounce suppression to look premium
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
  bool _triggered = false;

  @override
  void initState() {
    super.initState();

    // Unbounded so spring overshoot is not silently clamped
    _ctrl = AnimationController.unbounded(vsync: this);

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
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final val = _ctrl.value;
        // Opacity clamped [0, 1]
        final opacity = val.clamp(0.0, 1.0);
        // Slide uses the raw spring value directly, allowing bounce overshoot
        final slide = Offset(0, widget.slideBegin * (1.0 - val));

        return Opacity(
          opacity: opacity,
          child: FractionalTranslation(
            translation: slide,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
