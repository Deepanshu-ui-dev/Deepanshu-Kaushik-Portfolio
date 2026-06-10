import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AnimatedHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  State<AnimatedHoverCard> createState() => _AnimatedHoverCardState();
}

class _AnimatedHoverCardState extends State<AnimatedHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final surfElev = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          margin: widget.margin,
          padding: widget.padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovered ? surfElev : surface,
            border: Border.all(
              color: _isHovered ? border2 : border,
              width: 0.5,
            ),
            borderRadius: AppRadius.card, // Flat editorial cards
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
