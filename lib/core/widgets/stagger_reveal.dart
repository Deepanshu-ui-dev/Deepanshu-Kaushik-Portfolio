import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';



















class StaggerReveal extends StatefulWidget {
  final List<Widget> children;

  
  final double slideOffset;

  
  final Duration duration;

  
  final Duration staggerDelay;

  
  final double visibilityThreshold;

  
  
  final bool wrapInColumn;

  
  final CrossAxisAlignment crossAxisAlignment;

  const StaggerReveal({
    super.key,
    required this.children,
    this.slideOffset = 20.0,
    this.duration = const Duration(milliseconds: 500),
    this.staggerDelay = const Duration(milliseconds: 80),
    this.visibilityThreshold = 0.08,
    this.wrapInColumn = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  State<StaggerReveal> createState() => _StaggerRevealState();
}

class _StaggerRevealState extends State<StaggerReveal>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fades;
  // Use pixel offsets instead of fractional Offset to avoid SlideTransition
  // which marks parent semantics dirty during animation.
  late final List<Animation<double>> _slideYs;

  bool _triggered = false;

  @override
  void initState() {
    super.initState();

    const curve = Cubic(0.165, 0.84, 0.44, 1.0);

    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(vsync: this, duration: widget.duration),
    );

    _fades = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: curve))
        .toList();

    _slideYs = _controllers
        .map((c) => Tween<double>(
              begin: widget.slideOffset,
              end: 0.0,
            ).animate(CurvedAnimation(parent: c, curve: curve)))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;

    for (int i = 0; i < _controllers.length; i++) {
      final delay = widget.staggerDelay * i;
      if (delay == Duration.zero) {
        if (mounted) _controllers[i].forward();
      } else {
        Future.delayed(delay, () {
          if (mounted) _controllers[i].forward();
        });
      }
    }
  }

  List<Widget> _buildAnimated() {
    return List.generate(
      widget.children.length,
      (i) => AnimatedBuilder(
        animation: _controllers[i],
        builder: (context, child) => Opacity(
          opacity: _fades[i].value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, _slideYs[i].value),
            child: child,
          ),
        ),
        child: widget.children[i],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final detectorKey = widget.key ?? ValueKey('stagger_${identityHashCode(this)}');

    final animated = _buildAnimated();

    return VisibilityDetector(
      key: detectorKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.visibilityThreshold) _trigger();
      },
      child: widget.wrapInColumn
          ? Column(
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: animated,
            )
          : _MultiChildWrapper(children: animated),
    );
  }
}



class _MultiChildWrapper extends StatelessWidget {
  final List<Widget> children;
  const _MultiChildWrapper({required this.children});

  @override
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}


















class SectionFadeReveal extends StatefulWidget {
  final Widget child;

  
  final Duration delay;

  
  final double visibilityThreshold;

  const SectionFadeReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.visibilityThreshold = 0.08,
  });

  @override
  State<SectionFadeReveal> createState() => _SectionFadeRevealState();
}

class _SectionFadeRevealState extends State<SectionFadeReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;

    if (widget.delay == Duration.zero) {
      if (mounted) _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detectorKey = widget.key ?? ValueKey('section_fade_${identityHashCode(this)}');

    return VisibilityDetector(
      key: detectorKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.visibilityThreshold) _trigger();
      },
      child: AnimatedBuilder(
        animation: _fade,
        builder: (context, child) => Opacity(
          opacity: _fade.value.clamp(0.0, 1.0),
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}














class FadeSlideReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;
  final double visibilityThreshold;

  const FadeSlideReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.slideOffset = 20.0,
    this.visibilityThreshold = 0.08,
  });

  @override
  State<FadeSlideReveal> createState() => _FadeSlideRevealState();
}

class _FadeSlideRevealState extends State<FadeSlideReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  // Pixel-based slide to avoid SlideTransition's semantic dirty propagation.
  late final Animation<double> _slideY;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    const curve = Cubic(0.165, 0.84, 0.44, 1.0);

    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: curve);
    _slideY = Tween<double>(
      begin: widget.slideOffset,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: curve));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;

    if (widget.delay == Duration.zero) {
      if (mounted) _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final detectorKey = widget.key ?? ValueKey('fade_slide_${identityHashCode(this)}');

    return VisibilityDetector(
      key: detectorKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction >= widget.visibilityThreshold) _trigger();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Opacity(
          opacity: _fade.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, _slideY.value),
            child: child,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}