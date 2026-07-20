import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:termos_ui/termos_ui.dart';
import 'package:monofolio/core/theme/app_theme.dart';
import 'package:monofolio/core/widgets/tap_scale.dart';

class PortfolioDrawer extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const PortfolioDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  State<PortfolioDrawer> createState() => _PortfolioDrawerState();
}

class _PortfolioDrawerState extends State<PortfolioDrawer>
    with SingleTickerProviderStateMixin {
  bool _enableAnimations = true;
  double _animationSpeed = 1.0;

  static const List<String> _tabs = [
    'HOME',
    'ABOUT',
    'PROJECTS',
    'SKILLS',
    'CONTACT',
  ];

  static const List<IconData> _tabIcons = [
    LucideIcons.home,
    LucideIcons.user,
    LucideIcons.briefcase,
    LucideIcons.sparkles,
    LucideIcons.mail,
  ];

  // prefix labels shown before the route name
  static const List<String> _prefixes = [
    '~/',
    '~/',
    '~/',
    '~/',
    '~/',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;
    final surface = isDark ? const Color(0xFF0E0E0F) : Colors.white;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Drawer(
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 16),
              child: Row(
                children: [
                  // Terminal-style prompt prefix
                  Text(
                    'portfolio@dk:',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      letterSpacing: 0.3,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '~',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: textTer,
                    ),
                  ),
                  Text(
                    ' \$',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      color: textTer,
                    ),
                  ),
                  const Spacer(),
                  TapScale(
                    onTap: () => Navigator.pop(context),
                    scale: 0.88,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        border: Border.all(color: border, width: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        LucideIcons.x,
                        size: 14,
                        color: textTer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 0.5, color: border),
            const SizedBox(height: 12),

            // ── Nav Items ───────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final isActive = index == widget.currentIndex;
                  return _DrawerNavItem(
                    label: _tabs[index],
                    prefix: _prefixes[index],
                    icon: _tabIcons[index],
                    isActive: isActive,
                    index: index,
                    accent: accent,
                    textPri: textPri,
                    textTer: textTer,
                    border: border,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      widget.onSelect(index);
                    },
                  );
                },
              ),
            ),

            // ── Preferences ─────────────────────────────────────────
            Container(height: 0.5, color: border),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '// preferences',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      letterSpacing: 1.5,
                      color: textTer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Heavy Effects',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12,
                          color: textPri,
                        ),
                      ),
                      TermosSwitch(
                        value: _enableAnimations,
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          setState(() => _enableAnimations = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Anim Speed',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      color: textPri,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TermosSlider(
                    value: _animationSpeed,
                    start: 0.5,
                    end: 2.0,
                    step: 0.5,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      setState(() => _animationSpeed = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerNavItem extends StatefulWidget {
  final String label;
  final String prefix;
  final IconData icon;
  final bool isActive;
  final int index;
  final Color accent;
  final Color textPri;
  final Color textTer;
  final Color border;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.label,
    required this.prefix,
    required this.icon,
    required this.isActive,
    required this.index,
    required this.accent,
    required this.textPri,
    required this.textTer,
    required this.border,
    required this.onTap,
  });

  @override
  State<_DrawerNavItem> createState() => _DrawerNavItemState();
}

class _DrawerNavItemState extends State<_DrawerNavItem> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: active
                    ? widget.accent.withValues(alpha: isDark ? 0.1 : 0.08)
                    : _hovered
                        ? widget.accent.withValues(alpha: isDark ? 0.05 : 0.04)
                        : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: active
                        ? widget.accent
                        : _hovered
                            ? widget.accent.withValues(alpha: 0.4)
                            : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Icon
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: active
                            ? widget.accent.withValues(alpha: 0.3)
                            : widget.border,
                        width: 0.75,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      widget.icon,
                      size: 14,
                      color: active ? widget.accent : widget.textTer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Label with terminal-prefix
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          widget.prefix,
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 12,
                            color: widget.textTer,
                          ),
                        ),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 14,
                            letterSpacing: 0.5,
                            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                            color: active ? widget.accent : widget.textPri,
                          ),
                          child: Text(widget.label.toLowerCase()),
                        ),
                      ],
                    ),
                  ),
                  // Active indicator
                  AnimatedOpacity(
                    opacity: active ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: widget.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
