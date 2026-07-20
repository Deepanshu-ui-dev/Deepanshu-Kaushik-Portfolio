import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';







class ScrollFadeIn extends StatefulWidget {
  final Widget child;

  /// Optional delay before the entrance animation begins.
  final Duration delay;

  /// How far (in logical pixels) the widget slides in from below.
  final double slideBeginPx;

  const ScrollFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideBeginPx = 12.0,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<double> _slideY;

  bool _animated = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController.unbounded(vsync: this)..value = 0.0;

    _opacity = _ClampedTween(begin: 0.0, end: 1.0).animate(_ctrl);

    // Use pixel-based tween directly so Transform.translate is clean.
    _slideY = _ctrl.drive(
      Tween<double>(begin: widget.slideBeginPx, end: 0.0),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
    }
  }

  void _maybeAnimate() {
    if (_animated || !mounted) return;

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
          0.0,
          1.0,
          0.0,
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
    // Use AnimatedBuilder with Opacity + Transform.translate instead of
    // FadeTransition + SlideTransition. The *Transition widgets propagate
    // dirty semantics up to their parent RenderObject, which triggers the
    // '!semantics.parentDataDirty' assertion when multiple animations run
    // simultaneously inside a CustomScrollView/SliverList.
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: Offset(0, _slideY.value),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}









class _ClampedTween extends Tween<double> {
  _ClampedTween({required super.begin, required super.end});

  @override
  double transform(double t) => super.transform(t.clamp(0.0, 1.0));
}
