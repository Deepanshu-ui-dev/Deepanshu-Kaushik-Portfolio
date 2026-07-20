import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'magnet.dart';












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
    with TickerProviderStateMixin {

  late final AnimationController _entranceCtrl;
  late final Animation<double>   _entranceFade;
  late final Animation<double>   _entranceSlide; // pixel Y offset

  late final AnimationController _glowCtrl;
  double _fromPos = 0.4;
  double _toPos   = 0.4;

  int _hovered = -1;

  static const List<_Tab> _tabs = [
    _Tab(icon: Icons.home_outlined,          activeIcon: Icons.home_rounded,         label: 'HOME'),
    _Tab(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded,        label: 'ABOUT'),
    _Tab(icon: Icons.work_outline_rounded,   activeIcon: Icons.work_rounded,          label: 'WORK'),
    _Tab(icon: Icons.auto_awesome_outlined,  activeIcon: Icons.auto_awesome,          label: 'SKILLS'),
    _Tab(icon: Icons.mail_outline_rounded,   activeIcon: Icons.mail_rounded,          label: 'CONTACT'),
  ];

  int    get _n => _tabs.length;
  double _posFor(int i) => (i + 0.5) / _n;

  double get _glowPos {
    final t = Curves.easeOutCubic.transform(_glowCtrl.value);
    return _fromPos + (_toPos - _fromPos) * t;
  }

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceFade = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    // Pixel-based slide (40px up from bottom) — avoids SlideTransition's
    // FractionalTranslation which marks parent semantics dirty.
    _entranceSlide = Tween<double>(begin: 40.0, end: 0.0)
        .animate(CurvedAnimation(
          parent: _entranceCtrl,
          curve: const Cubic(0.22, 1.0, 0.36, 1.0),
        ));

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _fromPos = _posFor(widget.currentIndex);
    _toPos   = _fromPos;

    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void didUpdateWidget(covariant FloatingNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      final t = Curves.easeOutCubic.transform(_glowCtrl.value);
      _fromPos = _fromPos + (_toPos - _fromPos) * t;
      _toPos   = _posFor(widget.currentIndex);
      _glowCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final accent    = isDark ? AppColors.accentDark       : AppColors.accentLight;
    final surface   = isDark ? AppColors.surfaceElevDark  : AppColors.surfaceLight;
    final border    = isDark ? AppColors.borderDark       : AppColors.borderLight;
    final idleTxt   = isDark ? AppColors.textTerDark      : AppColors.textTerLight;
    final activeTxt = isDark ? AppColors.textPrimaryDark  : AppColors.textPrimaryLight;

    
    final screenW = MediaQuery.sizeOf(context).width;
    final totalW  = (screenW * 0.88).clamp(280.0, 360.0);

    const double barH   = 55.0;
    const double radius = 12.0;
    const double padH   = 10.0;

    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (context, child) => Opacity(
        opacity: _entranceFade.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, _entranceSlide.value),
          child: child,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Center(
              child: AnimatedBuilder(
                animation: _glowCtrl,
                builder: (context, _) {
                  final glowPos = _glowPos;

                  return Container(
                    width:  totalW,
                    height: barH,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color:       isDark
                              ? Colors.black.withValues(alpha: 0.50)
                              : AppColors.borderLight.withValues(alpha: 0.25),
                          blurRadius:  28,
                          spreadRadius:-4,
                          offset:      const Offset(0, 8),
                        ),
                        BoxShadow(
                          color:       isDark
                              ? Colors.black.withValues(alpha: 0.22)
                              : AppColors.borderLight.withValues(alpha: 0.12),
                          blurRadius:  8,
                          offset:      const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      foregroundPainter: _GlowTopBorderPainter(
                        position:   glowPos,
                        glowColor:  accent,
                        baseColor:  border.withValues(alpha: isDark ? 0.5 : 0.4),
                        strokeWidth:isDark ? 1.5 : 1.0,
                        radius:     radius,
                        glowSpread: 0.4,
                        glowCore:   0.02,
                        haloSpread: 0.25,
                        haloCore:   0.03,
                        haloAlpha:  isDark ? 0.45 : 0.45,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? surface.withValues(alpha: 0.70)
                                  : surface.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(radius),
                              border: Border.all(
                                color: border.withValues(alpha: isDark ? 0.35 : 0.50),
                                width: 0.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                
                                Positioned.fill(
                                  child: IgnorePointer(
                                    child: CustomPaint(
                                      painter: _DotGridPainter(
                                        activePos:  glowPos,
                                        dotColor:   isDark
                                            ? border.withValues(alpha: 0.28)
                                            : border.withValues(alpha: 0.35),
                                        glowColor:  isDark
                                            ? accent.withValues(alpha: 0.22)
                                            : accent.withValues(alpha: 0.18),
                                        dotRadius:  0.9,
                                        spacing:    9.0,
                                        blobRadius: barH * 2.2,
                                      ),
                                    ),
                                  ),
                                ),

                                
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: padH),
                                  child: Row(
                                    children: List.generate(_n, (i) {
                                      final isActive  = widget.currentIndex == i;
                                      final isHovered = _hovered == i;
                                      final tab = _tabs[i];

                                      return Expanded(
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          onEnter: (_) => setState(() => _hovered = i),
                                          onExit:  (_) => setState(() => _hovered = -1),
                                          child: GestureDetector(
                                            onTap:    () => widget.onTap(i),
                                            behavior: HitTestBehavior.opaque,
                                            child: Magnet(
                                              displacement: 0.08,
                                              child: SizedBox(
                                                height: barH,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    
                                                      AnimatedSwitcher(
                                                        duration: const Duration(milliseconds: 180),
                                                        switchInCurve:  Curves.easeOutBack,
                                                        switchOutCurve: Curves.easeIn,
                                                        transitionBuilder: (child, anim) => AnimatedBuilder(
                                                          animation: anim,
                                                          builder: (context, c) => Transform.scale(
                                                            scale: anim.value,
                                                            child: c,
                                                          ),
                                                          child: child,
                                                        ),
                                                      child: AnimatedOpacity(
                                                        duration: const Duration(milliseconds: 180),
                                                        opacity: isActive
                                                            ? 1.0
                                                            : (isHovered ? 0.70 : 0.40),
                                                        child: Icon(
                                                          isActive ? tab.activeIcon : tab.icon,
                                                          key:   ValueKey('icon_${i}_$isActive'),
                                                          size:  18,
                                                          color: isActive ? activeTxt : idleTxt,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 4),

                                                    
                                                    AnimatedDefaultTextStyle(
                                                      duration: const Duration(milliseconds: 180),
                                                      style: TextStyle(
                                                        fontFamily:    'JetBrainsMono',
                                                        fontSize:      9,
                                                        fontWeight:    isActive
                                                            ? FontWeight.w600
                                                            : FontWeight.w400,
                                                        letterSpacing: isActive ? 0.8 : 0.6,
                                                        color: isActive
                                                            ? activeTxt
                                                            : idleTxt.withValues(
                                                                alpha: isHovered ? 0.70 : 0.45),
                                                      ),
                                                      child: Text(tab.label),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ),
        ),
      ),
    );
  }
}





class _DotGridPainter extends CustomPainter {
  final double activePos;
  final Color  dotColor;
  final Color  glowColor;
  final double dotRadius;
  final double spacing;
  final double blobRadius;

  const _DotGridPainter({
    required this.activePos,
    required this.dotColor,
    required this.glowColor,
    required this.dotRadius,
    required this.spacing,
    required this.blobRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center    = Offset(size.width * activePos, size.height * 0.5);
    final idlePaint = Paint()..color = dotColor;

    for (double x = spacing; x < size.width - spacing * 0.5; x += spacing) {
      for (double y = spacing; y < size.height - spacing * 0.5; y += spacing) {
        final pt   = Offset(x, y);
        final dist = (pt - center).distance;
        if (dist < blobRadius) {
          final t = 1.0 - (dist / blobRadius);
          final c = Color.lerp(dotColor, glowColor, t * t)!;
          canvas.drawCircle(pt, dotRadius + t * 0.4, Paint()..color = c);
        } else {
          canvas.drawCircle(pt, dotRadius, idlePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter old) =>
      old.activePos != activePos || old.dotColor != dotColor || old.glowColor != glowColor;
}





class _GlowTopBorderPainter extends CustomPainter {
  const _GlowTopBorderPainter({
    required this.position,
    required this.glowColor,
    required this.baseColor,
    required this.strokeWidth,
    required this.radius,
    this.glowSpread = 0.12,
    this.glowCore   = 0.025,
    this.haloSpread = 0.15,
    this.haloCore   = 0.04,
    this.haloAlpha  = 0.40,
  });

  final double position;
  final Color  glowColor;
  final Color  baseColor;
  final double strokeWidth;
  final double radius;
  final double glowSpread;
  final double glowCore;
  final double haloSpread;
  final double haloCore;
  final double haloAlpha;

  static const double _haloBoost = 8.0;
  static const double _haloBlur  = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final path = Path()
      ..moveTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius))
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));

    
    canvas.drawPath(
      path,
      Paint()
        ..style       = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + _haloBoost
        ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, _haloBlur)
        ..shader = LinearGradient(
          colors: [
            glowColor.withValues(alpha: 0),
            glowColor.withValues(alpha: haloAlpha),
            glowColor.withValues(alpha: haloAlpha),
            glowColor.withValues(alpha: 0),
          ],
          stops: [
            (position - haloSpread).clamp(0.0, 1.0),
            (position - haloCore  ).clamp(0.0, 1.0),
            (position + haloCore  ).clamp(0.0, 1.0),
            (position + haloSpread).clamp(0.0, 1.0),
          ],
        ).createShader(rect),
    );

    
    canvas.drawPath(
      path,
      Paint()
        ..style       = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..shader = LinearGradient(
          colors: [baseColor, glowColor, glowColor, baseColor],
          stops: [
            (position - glowSpread).clamp(0.0, 1.0),
            (position - glowCore  ).clamp(0.0, 1.0),
            (position + glowCore  ).clamp(0.0, 1.0),
            (position + glowSpread).clamp(0.0, 1.0),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _GlowTopBorderPainter old) =>
      position   != old.position  ||
      glowColor  != old.glowColor ||
      baseColor  != old.baseColor ||
      haloAlpha  != old.haloAlpha;
}





class _Tab {
  final IconData icon;
  final IconData activeIcon;
  final String   label;

  const _Tab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}