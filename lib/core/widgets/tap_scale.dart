import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps any [child] with a press-to-shrink scale animation and optional
/// haptic feedback, providing tactile interaction feel across all tappable
/// surfaces in the portfolio theme.
///
/// Use this wherever [GestureDetector]/[InkWell] is used without built-in
/// press feedback. Pairs well with Termos components for a unified feel.
class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// How far to scale down on press. Defaults to 0.94.
  final double scale;

  /// Duration of the press/release animation. Defaults to 100ms.
  final Duration duration;

  /// Whether to emit a [HapticFeedback.selectionClick] on tap.
  final bool haptic;

  final MouseCursor cursor;

  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.94,
    this.duration = const Duration(milliseconds: 100),
    this.haptic = true,
    this.cursor = SystemMouseCursors.click,
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> {
  bool _pressed = false;

  void _setPressed(bool val) {
    if (_pressed == val) return;
    setState(() => _pressed = val);
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    if (widget.haptic) HapticFeedback.selectionClick();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? widget.cursor : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap != null ? _handleTap : null,
        onLongPress: widget.onLongPress,
        onTapDown: widget.onTap != null ? (_) => _setPressed(true) : null,
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? widget.scale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
