import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A wrapper widget that provides smooth scrolling for discrete mouse wheel input on web and desktop.
///
/// Under Flutter Web, mouse scroll wheel events by default cause instant, jumpy scrolling.
/// This widget intercepts those events, cancels the native jumps, and smoothly animates the
/// [ScrollController] to the target position. It automatically detects and permits trackpad/high-precision
/// scrolling (small deltas) to bypass the animator and scroll natively, preserving natural momentum.
class SmoothScroll extends StatefulWidget {
  /// The ScrollController attached to the scrollable child.
  final ScrollController controller;

  /// The scrollable widget (e.g. CustomScrollView, ListView, SingleChildScrollView).
  final Widget child;

  /// Duration of the scroll animation. Default: 280ms.
  final int animationDuration;

  /// Curve of the scroll animation. Default: Curves.easeOutCubic.
  final Curve curve;

  const SmoothScroll({
    super.key,
    required this.controller,
    required this.child,
    this.animationDuration = 280,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll> {
  double _targetOffset = 0.0;
  bool _isAnimating = false;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (!widget.controller.hasClients) return;

      final double scrollDelta = event.scrollDelta.dy;
      if (scrollDelta == 0) return;

      // Filter out trackpad/high-precision scrolls (small deltas).
      // Trackpad scrolls issue rapid streams of small float deltas (usually < 20).
      // Mouse scroll wheels issue discrete tick deltas (usually >= 20, e.g. 40, 100, 120).
      if (scrollDelta.abs() < 20.0) {
        return; // Allow trackpad momentum to scroll natively
      }

      // Consume the pointer scroll event to prevent the default instant jump
      GestureBinding.instance.pointerSignalResolver.register(event, (PointerEvent event) {});

      final double maxScroll = widget.controller.position.maxScrollExtent;

      // Base target: if already animating, accumulate from the target;
      // otherwise, start from the current controller position.
      final double baseOffset = _isAnimating ? _targetOffset : widget.controller.offset;
      _targetOffset = (baseOffset + scrollDelta).clamp(0.0, maxScroll);
      _isAnimating = true;

      widget.controller.animateTo(
        _targetOffset,
        duration: Duration(milliseconds: widget.animationDuration),
        curve: widget.curve,
      ).whenComplete(() {
        // Only reset _isAnimating if we have actually reached the targeted offset.
        // If a subsequent scroll event is currently running, offset won't match _targetOffset.
        if (mounted && (widget.controller.offset - _targetOffset).abs() < 1.0) {
          _isAnimating = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _onPointerSignal,
      child: widget.child,
    );
  }
}
