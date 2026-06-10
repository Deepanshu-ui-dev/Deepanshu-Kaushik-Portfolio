import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'magnet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FLOATING NAV BAR
//
// Design language:
//   • Pure zinc solid background — NO backdrop blur, NO glassmorphism
//   • 0.5px border all around
//   • Active: accent-colored icon + label, 1.5px underline pill
//   • Hover: textPrimary icon, no background fill (just icon brightens)
//   • Spring entrance from bottom
// ─────────────────────────────────────────────────────────────────────────────

class FloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with SingleTickerProviderStateMixin {
  int _hoveredIndex = -1;
  late final AnimationController _entranceCtrl;
  late final Animation<double> _entranceFade;
  late final Animation<Offset> _entranceSlide;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entranceFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );
    _entranceSlide = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    super.dispose();
  }

  static const _items = [
    _NavItem(icon: Icons.home_outlined,          activeIcon: Icons.home_rounded,         label: 'HOME'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,        label: 'ABOUT'),
    _NavItem(icon: Icons.work_outline_rounded,   activeIcon: Icons.work_rounded,          label: 'WORK'),
    _NavItem(icon: Icons.auto_awesome_outlined,  activeIcon: Icons.auto_awesome,          label: 'SKILLS'),
    _NavItem(icon: Icons.mail_outline_rounded,   activeIcon: Icons.mail_rounded,          label: 'CONTACT'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    // Solid zinc — no blur, no glassmorphism
    final navBg     = isDark ? AppColors.surfaceDark     : AppColors.surfaceLight;
    final navBorder = isDark ? AppColors.borderDark      : AppColors.borderLight;
    final accent    = isDark ? AppColors.accentDark      : AppColors.accentLight;
    final idleIcon  = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final hoverIcon = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return FadeTransition(
      opacity: _entranceFade,
      child: SlideTransition(
        position: _entranceSlide,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  // Solid background — no BackdropFilter
                  color: isDark
                      ? navBg.withValues(alpha: 0.97)
                      : navBg.withValues(alpha: 0.98),
                  borderRadius: AppRadius.subtle,
                  border: Border.all(color: navBorder, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_items.length, (i) {
                    final isActive  = widget.currentIndex == i;
                    final isHovered = _hoveredIndex == i && !isActive;
                    final item = _items[i];

                    final iconColor = isActive
                        ? accent
                        : isHovered
                            ? hoverIcon
                            : idleIcon;

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _hoveredIndex = i),
                      onExit:  (_) => setState(() => _hoveredIndex = -1),
                      child: GestureDetector(
                        onTap: () => widget.onTap(i),
                        child: Magnet(
                          displacement: 0.12,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 140),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                          width: 56,
                          decoration: BoxDecoration(
                            // No fill on hover — just icon brightens
                            color: isActive
                                ? (isDark
                                    ? AppColors.surfaceElevDark
                                    : AppColors.surfaceElevLight)
                                : Colors.transparent,
                            borderRadius: AppRadius.subtle,
                            border: isActive
                                ? Border.all(color: navBorder, width: 0.5)
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 160),
                                  switchInCurve: Curves.easeOutBack,
                                  switchOutCurve: Curves.easeIn,
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Icon(
                                    isActive ? item.activeIcon : item.icon,
                                    key: ValueKey('icon_${i}_$isActive'),
                                    size: 16,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Active indicator — small accent underline
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  width: isActive ? 12 : 0,
                                  height: 1.5,
                                  decoration: BoxDecoration(
                                    color: accent,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NAV ITEM MODEL
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// PIXEL MONOGRAM — "DK" initials as pixel-art grid
//
// Used in any header or branded position requiring the portfolio monogram.
// Each pixel: 4×4px squares, 1px gap between them.
// ─────────────────────────────────────────────────────────────────────────────

class PixelMonogram extends StatelessWidget {
  final Color? color;
  final double pixelSize;

  const PixelMonogram({super.key, this.color, this.pixelSize = 4.0});

  // Pixel grid for "DK" — 5 rows × 10 cols (5 per letter with 1 gap col)
  // 1 = filled, 0 = empty
  static const _pixels = [
    // D        gap  K
    [1, 1, 0, 0, 0,  0,  1, 0, 0, 1],
    [1, 0, 1, 0, 0,  0,  1, 0, 1, 0],
    [1, 0, 0, 1, 0,  0,  1, 1, 0, 0],
    [1, 0, 1, 0, 0,  0,  1, 0, 1, 0],
    [1, 1, 0, 0, 0,  0,  1, 0, 0, 1],
  ];

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    const gap = 1.0;
    final cols = _pixels[0].length;
    final rows = _pixels.length;
    final totalW = cols * pixelSize + (cols - 1) * gap;
    final totalH = rows * pixelSize + (rows - 1) * gap;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: CustomPaint(
        painter: _MonogramPainter(pixels: _pixels, color: c, pixelSize: pixelSize, gap: gap),
      ),
    );
  }
}

class _MonogramPainter extends CustomPainter {
  final List<List<int>> pixels;
  final Color color;
  final double pixelSize;
  final double gap;

  const _MonogramPainter({
    required this.pixels,
    required this.color,
    required this.pixelSize,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (int r = 0; r < pixels.length; r++) {
      for (int c = 0; c < pixels[r].length; c++) {
        if (pixels[r][c] == 1) {
          final x = c * (pixelSize + gap);
          final y = r * (pixelSize + gap);
          canvas.drawRect(
            Rect.fromLTWH(x, y, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MonogramPainter old) =>
      old.color != color || old.pixelSize != pixelSize;
}