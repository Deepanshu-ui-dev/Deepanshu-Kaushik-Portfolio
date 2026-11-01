import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_theme.dart';

/// Full-screen welcome card shown before the main portfolio.
/// Dismisses on tap with a smooth fade-out.
class EdWelcome extends StatefulWidget {
  const EdWelcome({super.key, required this.onDismiss});
  final VoidCallback onDismiss;

  @override
  State<EdWelcome> createState() => _EdWelcomeState();
}

class _EdWelcomeState extends State<EdWelcome>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final AnimationController _bobCtrl;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    _bobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _bobCtrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_dismissing) return;
    setState(() => _dismissing = true);
    await _fadeCtrl.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);

    return FadeTransition(
      opacity: _fadeAnim,
      child: Scaffold(
        backgroundColor: ed.page,
        body: Stack(
          children: [
            // Subtle noise grain
            Positioned.fill(child: CustomPaint(painter: _NoisePainter(dark: ed.dark))),

            // Radial amber glow behind avatar
            Center(
              child: Container(
                width: 480,
                height: 480,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFE07B39).withOpacity(ed.dark ? 0.09 : 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Floating avatar
                  AnimatedBuilder(
                    animation: _bobCtrl,
                    builder: (ctx, child) => Transform.translate(
                      offset: Offset(0, -math.sin(_bobCtrl.value * math.pi) * 8),
                      child: child,
                    ),
                    child: _Avatar(ed: ed),
                  ),

                  const SizedBox(height: 28),

                  // "Hello, I'm Deepanshu"
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'InstrumentSerif',
                        fontSize: 36,
                        height: 1.1,
                        letterSpacing: -0.4,
                        color: ed.ink,
                      ),
                      children: const [
                        TextSpan(text: "Hello, I'm "),
                        TextSpan(
                          text: PortfolioConfig.firstName,
                          style: TextStyle(
                            color: Color(0xFFE07B39),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    PortfolioConfig.headline,
                    style: ed.mono(12, color: ed.ink3, ls: 0.7),
                  ),

                  const SizedBox(height: 32),

                  _ExploreButton(ed: ed, onTap: _dismiss),
                ],
              ),
            ),

            // Bottom-left corner tag
            Positioned(
              left: 28,
              bottom: 24,
              child: Text(
                'v2025 · ${PortfolioConfig.location}',
                style: ed.mono(10, color: ed.ink3, ls: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatefulWidget {
  const _Avatar({required this.ed});
  final Ed ed;

  @override
  State<_Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<_Avatar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        child: Container(
          width: 116,
          height: 116,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFE07B39).withOpacity(0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE07B39).withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(widget.ed.dark ? 0.45 : 0.08),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.asset(
              'assets/images/profile.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: widget.ed.raised,
                alignment: Alignment.center,
                child: Text(
                  PortfolioConfig.initials,
                  style: TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontSize: 34,
                    color: widget.ed.ink,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Explore Button ────────────────────────────────────────────────────────────

class _ExploreButton extends StatefulWidget {
  const _ExploreButton({required this.ed, required this.onTap});
  final Ed ed;
  final VoidCallback onTap;

  @override
  State<_ExploreButton> createState() => _ExploreButtonState();
}

class _ExploreButtonState extends State<_ExploreButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dark = widget.ed.dark;
    final bg = dark ? const Color(0xFFF4F4F5) : const Color(0xFF111113);
    final fg = dark ? const Color(0xFF111113) : const Color(0xFFF4F4F5);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          decoration: BoxDecoration(
            color: _hovered ? bg.withOpacity(0.86) : bg,
            borderRadius: BorderRadius.circular(100),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tap to explore',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.1,
                  color: fg,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSlide(
                offset: _hovered ? const Offset(0.25, 0) : Offset.zero,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: Icon(Icons.arrow_forward_rounded, size: 16, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Noise Painter ─────────────────────────────────────────────────────────────

class _NoisePainter extends CustomPainter {
  const _NoisePainter({required this.dark});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final p = Paint()
      ..color = (dark ? Colors.white : Colors.black).withOpacity(0.018);
    for (var i = 0; i < 3200; i++) {
      canvas.drawCircle(
        Offset(rng.nextDouble() * size.width, rng.nextDouble() * size.height),
        0.6,
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => old.dark != dark;
}
