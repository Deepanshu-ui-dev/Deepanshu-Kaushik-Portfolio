import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_primitives.dart';
import 'ed_theme.dart';

/// Section ids, in page order. Labels double as the INDEX entries.
enum EdSection {
  about('About'),
  work('Projects'),
  experience('Experience'),
  skills('Tech Stack'),
  photography('Photography'),
  github('GitHub'),
  contact('Contact');

  const EdSection(this.label);
  final String label;
}

/// Sub-pages post here to ask the home page to scroll to a section after
/// they've popped back to it.
final edSectionRequest = ValueNotifier<EdSection?>(null);

/// Bumped by sub-pages to ask the home page to scroll back to the top.
final edTopRequest = ValueNotifier<int>(0);

/// Top-level destinations shown in the navbar linking to separate pages.
const navItems = <(String, EdSection?)>[
  ('Home', null),
  ('About', EdSection.about),
  ('Projects', EdSection.work),
  ('Skills', EdSection.skills),
  ('Contact', EdSection.contact),
];

/// Permanent floating glass pill navbar.
class EdNavBar extends StatelessWidget {
  final ValueListenable<bool>? floating;
  final ValueListenable<double>? progress;

  /// Currently highlighted item index into [navItems].
  final ValueListenable<int> activeIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onBrand;
  final VoidCallback onSearch;
  final VoidCallback onToggleTheme;

  /// Shown after the name on sub-pages, e.g. "/ projects".
  final String? trail;

  const EdNavBar({
    super.key,
    this.floating,
    required this.activeIndex,
    required this.onSelect,
    required this.onBrand,
    required this.onSearch,
    required this.onToggleTheme,
    this.progress,
    this.trail,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final screen = MediaQuery.sizeOf(context).width;
    final compact = screen < 760;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: ed.card.withValues(alpha: ed.dark ? 0.94 : 0.96),
        border: Border(bottom: BorderSide(color: ed.line)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: ed.dark ? 0.35 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRect(
        child: RepaintBoundary(
          child: Stack(
            children: [
              // Hatch pattern in the outer gutters (left & right of center column)
              if (screen > Ed.column + 2)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _NavHatchPainter(ed.hatch, Ed.column.toDouble()),
                  ),
                ),
              Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: Ed.column),
                  decoration: BoxDecoration(
                    color: ed.card.withValues(alpha: ed.dark ? 0.90 : 0.92),
                    border: screen > Ed.column + 2
                        ? Border.symmetric(vertical: BorderSide(color: ed.line))
                        : null,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: edPad(context)),
                  child: Row(children: [
                    _DateTimeBrand(trail: trail, onTap: onBrand),
                    const Spacer(),
                    if (!compact) ...[
                      _Tabs(active: activeIndex, onSelect: onSelect),
                      Container(
                        width: 1,
                        height: 18,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        color: ed.line2,
                      ),
                    ],
                    _KbdButton(onTap: onSearch, compact: compact),
                    const SizedBox(width: 6),
                    _ThemeButton(onTap: onToggleTheme),
                    if (compact) ...[
                      const SizedBox(width: 6),
                      EdIconButton(
                        icon: LucideIcons.menu,
                        tooltip: 'Menu',
                        size: 30,
                        onTap: () => showMobileMenu(context, activeIndex.value, onSelect),
                      ),
                    ],
                  ]),
                ),
              ),
              if (progress != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ValueListenableBuilder<double>(
                    valueListenable: progress!,
                    builder: (_, p, __) => FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: p,
                      child: Container(height: 1.5, color: ed.ink.withValues(alpha: 0.55)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hatch painter that only draws in the outer gutters — leaves the centre column clear.
class _NavHatchPainter extends CustomPainter {
  final Color color;
  final double colW;
  const _NavHatchPainter(this.color, this.colW);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    // Gutter widths
    final gutter = (size.width - colW) / 2;
    if (gutter <= 0) return;
    for (final region in [
      Rect.fromLTWH(0, 0, gutter, size.height),
      Rect.fromLTWH(size.width - gutter, 0, gutter, size.height),
    ]) {
      canvas.save();
      canvas.clipRect(region);
      const gap = 7.0;
      final h = region.height;
      for (double x = region.left - h; x < region.right; x += gap) {
        canvas.drawLine(Offset(x, region.bottom), Offset(x + h, region.top), paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_NavHatchPainter old) => old.color != color || old.colW != colW;
}

/// Displays the current date in the navbar by default, and seamlessly transitions
/// to the user's local time on hover.
class _DateTimeBrand extends StatefulWidget {
  final String? trail;
  final VoidCallback onTap;
  const _DateTimeBrand({this.trail, required this.onTap});

  @override
  State<_DateTimeBrand> createState() => _DateTimeBrandState();
}

class _DateTimeBrandState extends State<_DateTimeBrand> {
  bool _hovered = false;
  late Timer _timer;
  DateTime _now = DateTime.now();

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _dateStr {
    final wd = _weekdays[_now.weekday - 1];
    final m = _months[_now.month - 1];
    return '$wd, $m ${_now.day}';
  }

  String get _timeStr {
    final h = _now.hour;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    String two(int n) => n.toString().padLeft(2, '0');
    final ampm = h < 12 ? 'AM' : 'PM';
    return '${two(h12)}:${two(_now.minute)}:${two(_now.second)} $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: _hovered ? 'Local time (Click for home)' : 'Click for home',
      waitDuration: const Duration(milliseconds: 600),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _hovered ? ed.raised : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _hovered ? ed.line2 : Colors.transparent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _hovered ? LucideIcons.clock : LucideIcons.calendar,
                    key: ValueKey(_hovered),
                    size: 13,
                    color: _hovered ? ed.ink : ed.ink3,
                  ),
                ),
                const SizedBox(width: 7),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                  child: Text(
                    _hovered ? _timeStr : _dateStr,
                    key: ValueKey(_hovered),
                    style: ed.mono(
                      12,
                      color: _hovered ? ed.ink : ed.ink2,
                      w: FontWeight.w500,
                      ls: 0.2,
                    ),
                  ),
                ),
                if (widget.trail != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(widget.trail!, style: ed.mono(10, color: ed.ink3)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Segmented nav with a pill indicator that slides between tabs.
class _Tabs extends StatelessWidget {
  final ValueListenable<int> active;
  final ValueChanged<int> onSelect;
  const _Tabs({required this.active, required this.onSelect});

  static const _pad = 11.0;

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final style = ed.sans(12.5, w: FontWeight.w500, h: 1);
    final widths = [
      for (final (label, _) in navItems) () {
        final tp = TextPainter(
          text: TextSpan(text: label, style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        final w = tp.width + _pad * 2;
        tp.dispose();
        return w;
      }(),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: active,
      builder: (_, a, __) {
        final left = widths.take(a).fold<double>(0, (s, w) => s + w);
        return SizedBox(
          height: 30,
          width: widths.fold<double>(0, (s, w) => s + w),
          child: Stack(children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              left: left,
              top: 0,
              bottom: 0,
              width: widths[a],
              child: Container(
                decoration: BoxDecoration(
                  color: ed.raised,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ed.line),
                ),
              ),
            ),
            Row(children: [
              for (int i = 0; i < navItems.length; i++)
                Hover(
                  onTap: () => onSelect(i),
                  semanticLabel: navItems[i].$1,
                  builder: (_, h) => SizedBox(
                    width: widths[i],
                    height: 30,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 150),
                        style: style.copyWith(
                          color: i == a || h ? ed.ink : ed.ink2,
                        ),
                        child: Text(navItems[i].$1),
                      ),
                    ),
                  ),
                ),
            ]),
          ]),
        );
      },
    );
  }
}

class _KbdButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool compact;
  const _KbdButton({required this.onTap, required this.compact});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: 'Search & commands',
      waitDuration: const Duration(milliseconds: 500),
      child: Hover(
        onTap: onTap,
        semanticLabel: 'Open command menu',
        builder: (_, h) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 9),
          decoration: BoxDecoration(
            color: h ? ed.raised : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: h ? ed.line2 : ed.line),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(LucideIcons.search, size: 13, color: h ? ed.ink : ed.ink2),
            if (!compact) ...[
              const SizedBox(width: 6),
              Text('⌘K', style: ed.mono(10, color: ed.ink3)),
            ],
          ]),
        ),
      ),
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ThemeButton({required this.onTap});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: 'Toggle theme (T)',
      waitDuration: const Duration(milliseconds: 500),
      child: Hover(
        onTap: onTap,
        semanticLabel: 'Toggle theme',
        builder: (_, h) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: h ? ed.raised : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: h ? ed.line2 : ed.line),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (c, a) => RotationTransition(
              turns: Tween(begin: 0.6, end: 1.0).animate(a),
              child: FadeTransition(opacity: a, child: c),
            ),
            child: Icon(
              ed.dark ? LucideIcons.sun : LucideIcons.moon,
              key: ValueKey(ed.dark),
              size: 14,
              color: h ? ed.ink : ed.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile full-screen menu ──────────────────────────────────────────

Future<void> showMobileMenu(BuildContext context, int active, ValueChanged<int> onSelect) async {
  final picked = await showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close menu',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => _MobileMenu(active: active),
    transitionBuilder: (_, a, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
      child: child,
    ),
  );
  if (picked != null) onSelect(picked);
}

class _MobileMenu extends StatefulWidget {
  final int active;
  const _MobileMenu({required this.active});
  @override
  State<_MobileMenu> createState() => _MobileMenuState();
}

class _MobileMenuState extends State<_MobileMenu> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    Widget stagger(int i, Widget child) {
      final a = CurvedAnimation(
        parent: _c,
        curve: Interval((0.08 * i).clamp(0, 0.6), (0.08 * i + 0.5).clamp(0, 1), curve: Curves.easeOutCubic),
      );
      return FadeTransition(
        opacity: a,
        child: SlideTransition(position: Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(a), child: child),
      );
    }

    return Material(
      color: ed.page,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('MENU', style: ed.mono(10, ls: 1.8)),
              const Spacer(),
              EdIconButton(icon: LucideIcons.x, tooltip: 'Close', size: 32, onTap: () => Navigator.of(context).pop()),
            ]),
            const SizedBox(height: 28),
            for (int i = 0; i < navItems.length; i++)
              stagger(
                i,
                Hover(
                  onTap: () => Navigator.of(context).pop(i),
                  semanticLabel: navItems[i].$1,
                  builder: (_, h) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: ed.line))),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                      SizedBox(width: 36, child: Text('0${i + 1}', style: ed.mono(10))),
                      Text(navItems[i].$1,
                          style: ed.serif(38, italic: i == widget.active || h, color: i == widget.active ? ed.ink : ed.ink2)),
                      const Spacer(),
                      if (i == widget.active) Icon(LucideIcons.dot, color: ed.ink, size: 28),
                    ]),
                  ),
                ),
              ),
            const Spacer(),
            stagger(
              navItems.length,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('ELSEWHERE', style: ed.mono(9, ls: 1.6)),
                const SizedBox(height: 10),
                const Wrap(spacing: 8, runSpacing: 8, children: [
                  _MenuSocial('GitHub', 'assets/icons/tech/github.svg', PortfolioConfig.githubUrl),
                  _MenuSocial('LinkedIn', 'assets/icons/tech/linkedin.svg', PortfolioConfig.linkedinUrl),
                  _MenuSocial('X', 'assets/icons/tech/x.svg', PortfolioConfig.twitterUrl),
                  _MenuSocial('Résumé', null, PortfolioConfig.resumeUrl),
                ]),
                const SizedBox(height: 14),
                Text(PortfolioConfig.email, style: ed.mono(11, color: ed.ink2)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _MenuSocial extends StatelessWidget {
  final String label;
  final String? svg;
  final String url;
  const _MenuSocial(this.label, this.svg, this.url);
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: () => openUrl(url),
      semanticLabel: label,
      builder: (_, h) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: h ? ed.raised : ed.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ed.line),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (svg != null)
            SvgPicture.asset(svg!, width: 12, height: 12, colorFilter: ColorFilter.mode(ed.ink2, BlendMode.srcIn))
          else
            Icon(LucideIcons.fileText, size: 12, color: ed.ink2),
          const SizedBox(width: 7),
          Text(label, style: ed.sans(12, color: ed.ink, w: FontWeight.w500, h: 1)),
        ]),
      ),
    );
  }
}
