import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// LEFT BORDER HOVER
//
// The abdulrehmanwaseem.me interaction pattern:
//   Rest:  0.5px full border in borderColor, transparent bg
//   Hover: 2px left border in accentColor, surfaceElev bg
//   Press: slight opacity dip (0.85) for tactile feedback
//   Transition: 150ms easeOutCubic
//
// Keyboard accessible — responds to focus via FocusNode.
// Supports custom border-radius for rounded card variants.
//
// Use for: project cards, blog rows, experience items, award rows,
//          certification chips, any tappable list item.
//
// Usage:
//   LeftBorderHover(
//     onTap: () => launch(url),
//     padding: const EdgeInsets.all(16),
//     child: ProjectRow(...),
//   )
// ─────────────────────────────────────────────────────────────────────────────

class LeftBorderHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final bool enabled;

  /// Override accent border color. Defaults to AppColors.accent[Dark|Light].
  final Color? accentColor;

  /// Border radius for rounded variants. Default: zero (sharp edges, per site aesthetic).
  final BorderRadius borderRadius;

  /// Width of left accent border when hovered. Default: 2.
  final double accentBorderWidth;

  const LeftBorderHover({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.accentColor,
    this.borderRadius = BorderRadius.zero,
    this.accentBorderWidth = 2.0,
  });

  @override
  State<LeftBorderHover> createState() => _LeftBorderHoverState();
}

class _LeftBorderHoverState extends State<LeftBorderHover> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _isActive => widget.enabled && (_hovered || _focused);

  void _setHover(bool v) {
    if (!widget.enabled) return;
    setState(() => _hovered = v);
  }

  void _setFocus(bool v) {
    if (!widget.enabled) return;
    setState(() => _focused = v);
  }

  void _setPressed(bool v) {
    if (!widget.enabled) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surfElev = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final accent = widget.accentColor ??
        (isDark ? AppColors.accentDark : AppColors.accentLight);

    // Hairline borders on non-left sides — rest state
    const hairline = 0.5;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      cursor: widget.onTap != null && widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: FocusableActionDetector(
        onFocusChange: _setFocus,
        actions: const {},
        child: GestureDetector(
          onTap: widget.enabled ? widget.onTap : null,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 80),
            opacity: _pressed ? 0.82 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: _isActive ? surfElev : Colors.transparent,
                borderRadius: widget.borderRadius,
                border: Border(
                  left: BorderSide(
                    color: _isActive ? accent : borderColor,
                    width: _isActive ? widget.accentBorderWidth : hairline,
                  ),
                  top: BorderSide(color: borderColor, width: hairline),
                  right: BorderSide(color: borderColor, width: hairline),
                  bottom: BorderSide(color: borderColor, width: hairline),
                ),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BORDER HOVER (all-sides variant)
//
// Same interaction as LeftBorderHover but brightens the full border on hover
// instead of accenting only the left edge.
// Use for: grid cells, chips, tag badges — items without inherent directionality.
// ─────────────────────────────────────────────────────────────────────────────

class BorderHover extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool enabled;
  final Color? accentColor;
  final BorderRadius borderRadius;

  const BorderHover({
    super.key,
    required this.child,
    this.onTap,
    this.padding = EdgeInsets.zero,
    this.enabled = true,
    this.accentColor,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<BorderHover> createState() => _BorderHoverState();
}

class _BorderHoverState extends State<BorderHover> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final surfElev = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final accent = widget.accentColor ??
        (isDark ? AppColors.accentDark : AppColors.accentLight);

    final isActive = widget.enabled && _hovered;

    return MouseRegion(
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      cursor: widget.onTap != null && widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: isActive ? surfElev : Colors.transparent,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: isActive ? accent : borderColor,
              width: isActive ? 1.0 : 0.5,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}