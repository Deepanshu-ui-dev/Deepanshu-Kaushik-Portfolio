import 'package:flutter/material.dart';
import '../theme/app_theme.dart';













class TechChip extends StatefulWidget {
  final String label;
  
  final bool showDot;
  
  final Color? dotColor;

  const TechChip({
    super.key,
    required this.label,
    this.showDot = false,
    this.dotColor,
  });

  @override
  State<TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<TechChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final border  = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppRadius.chip,
          border: Border.all(
            color: _hovered ? border2 : border,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showDot) ...[
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: widget.dotColor ??
                      (isDark ? AppColors.accentDark : AppColors.accentLight),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: _hovered ? textPri : textSec,
                letterSpacing: 0.0,
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}











class SectionHeading extends StatelessWidget {
  final String title;
  final String? subtitle;
  
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const SectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final border  = isDark ? AppColors.borderDark  : AppColors.borderLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              if (action != null) action!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textTer,
                  ),
            ),
          ],
          const SizedBox(height: 10),
          Divider(thickness: 0.5, color: border, height: 0.5),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}








class EyebrowLabel extends StatelessWidget {
  final String text;
  final bool showSlash;

  const EyebrowLabel({super.key, required this.text, this.showSlash = true});

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;

    return Text(
      showSlash ? '/ $text' : text,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: textTer,
        letterSpacing: 0.9, 
      ),
    );
  }
}
