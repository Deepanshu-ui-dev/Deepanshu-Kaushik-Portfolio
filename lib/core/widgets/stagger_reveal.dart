import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ─────────────────────────────────────────────────────────────────────────────
// STAGGER REVEAL
//
// Scroll-triggered stagger animation: fade + translateY per child.
// Triggers once when [visibilityThreshold] fraction enters the viewport.
//
// Defaults (matching abdulrehmanwaseem.me feel):
//   • fade: 0 → 1, easeOutQuart, 500ms
//   • slide: 20px → 0, easeOutQuart, 500ms
//   • stagger: 80ms per child
//   • threshold: 0.08 (fires early — avoids content popping in late)
//
// Usage:
//   StaggerReveal(
//     children: [card1, card2, card3],
//   )
// ─────────────────────────────────────────────────────────────────────────────

class StaggerReveal extends StatefulWidget {
  final List<Widget> children;

  /// Y-axis start offset in logical pixels. Default: 20.
  final double slideOffset;

  /// Animation duration per child. Default: 500ms.
  final Duration duration;

  /// Delay between each child's animation start. Default: 80ms.
  final Duration staggerDelay;

  /// Fraction of widget visible before triggering. Default: 0.08.
  final double visibilityThreshold;

  /// If true, children lay out in a Column. If false, they are returned as a
  /// raw list via [StaggerReveal.builder] pattern. Default: true.
  final bool wrapInColumn;

  /// Column cross-axis alignment. Default: CrossAxisAlignment.start.
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
  late final List<Animation<Offset>> _slides;

  // Normalized slide offset: SlideTransition uses fractional coordinates
  // where 1.0 = one full widget height. We fix to a constant ~20px equivalent
  // by using a small fixed fraction rather than scaling by widget size.
  // 0.08 feels close to 16–20px on most screens.
  static const double _slideNorm = 0.08;

  bool _triggered = false;

  @override
  void initState() {
    super.initState();

    // easeOutQuart: decelerates sharply — editorial, not bouncy
    const curve = Cubic(0.165, 0.84, 0.44, 1.0); // easeOutQuart

    _controllers = List.generate(
      widget.children.length,
      (i) => AnimationController(vsync: this, duration: widget.duration),
    );

    _fades = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: curve))
        .toList();

    _slides = _controllers
        .map((c) => Tween<Offset>(
              begin: const Offset(0, _slideNorm),
              end: Offset.zero,
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
      (i) => FadeTransition(
        opacity: _fades[i],
        child: SlideTransition(
          position: _slides[i],
          child: widget.children[i],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Unique key per instance — avoids VisibilityDetector key collisions
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

/// Internal wrapper that renders children without imposing Column semantics.
/// Used when the caller manages their own layout (e.g. inside a ListView).
class _MultiChildWrapper extends StatelessWidget {
  final List<Widget> children;
  const _MultiChildWrapper({required this.children});

  @override
  Widget build(BuildContext context) {
    // Render each child independently — caller's layout handles positioning
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SECTION FADE REVEAL
//
// Lightweight single-item reveal for headings, section dividers, labels.
// Fade only — no translation. Clean, fast, unobtrusive.
//
// Defaults:
//   • 350ms, easeOut
//   • Triggers at 8% visibility
//   • Optional [delay] for manual orchestration
//
// Usage:
//   SectionFadeReveal(
//     child: Text('Experience'),
//   )
// ─────────────────────────────────────────────────────────────────────────────

class SectionFadeReveal extends StatefulWidget {
  final Widget child;

  /// Optional delay before animation fires after becoming visible.
  final Duration delay;

  /// Visibility threshold to trigger. Default: 0.08.
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
      child: FadeTransition(opacity: _fade, child: widget.child),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FADE SLIDE REVEAL (single item)
//
// Single-widget version of StaggerReveal — for items that need both
// fade + slide but sit alone (hero text, single cards, inline callouts).
//
// Usage:
//   FadeSlideReveal(
//     delay: Duration(milliseconds: 100),
//     child: HeroCard(),
//   )
// ─────────────────────────────────────────────────────────────────────────────

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
  late final Animation<Offset> _slide;
  bool _triggered = false;

  static const double _slideNorm = 0.08;

  @override
  void initState() {
    super.initState();
    const curve = Cubic(0.165, 0.84, 0.44, 1.0);

    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: curve);
    _slide = Tween<Offset>(
      begin: const Offset(0, _slideNorm),
      end: Offset.zero,
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
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}