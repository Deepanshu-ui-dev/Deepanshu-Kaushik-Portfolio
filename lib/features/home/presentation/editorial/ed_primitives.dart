import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_motion.dart';
import 'ed_theme.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}

/// Inner horizontal padding of the content column.
double edPad(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 600 ? 16 : 22;

/// Hover + tap wrapper that hands its hover state to a builder.
class Hover extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final String? semanticLabel;
  const Hover({super.key, required this.builder, this.onTap, this.semanticLabel});

  @override
  State<Hover> createState() => _HoverState();
}

class _HoverState extends State<Hover> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    Widget child = MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.builder(context, _h),
      ),
    );
    if (widget.semanticLabel != null) {
      child = Semantics(button: true, label: widget.semanticLabel, child: child);
    }
    return child;
  }
}

/// A full-bleed row whose centre is the 760px paper column framed by hairlines.
class ColumnBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  /// Fade the content in on first scroll into view, like home sections.
  final bool reveal;
  const ColumnBox({super.key, required this.child, this.padding, this.reveal = false});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final framed = MediaQuery.sizeOf(context).width > Ed.column + 2;
    return Center(
      child: CustomPaint(
        foregroundPainter: framed ? DashedRulePainter(ed.ink3.withValues(alpha: 0.55), left: true, right: true) : null,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: Ed.column),
          color: ed.paper,
          padding: padding ?? EdgeInsets.symmetric(horizontal: edPad(context)),
          child: reveal ? EdReveal(child: child) : child,
        ),
      ),
    );
  }
}

/// Diagonal hatch fill used for the gutters of section bands.
class HatchPainter extends CustomPainter {
  final Color color;
  final double gap;
  const HatchPainter(this.color, {this.gap = 7});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (double x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), p);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(HatchPainter old) => old.color != color || old.gap != gap;
}

/// Dot-grid pattern used for the side backgrounds and outer gutters.
class DotGridPainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double radius;
  const DotGridPainter(this.color, {this.spacing = 22, this.radius = 1.1});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..isAntiAlias = true;

    final startX = (size.width % spacing) / 2;
    final startY = (size.height % spacing) / 2;

    for (double x = startX; x < size.width; x += spacing) {
      for (double y = startY; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, p);
      }
    }
  }

  @override
  bool shouldRepaint(DotGridPainter old) =>
      old.color != color || old.spacing != spacing || old.radius != radius;
}

/// Full-width band with hairlines top & bottom, hatched gutters and a serif
/// title inside the column — the signature divider of the layout.
class SectionBand extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final double height;
  const SectionBand(this.title, {super.key, this.trailing, this.height = 50});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final veryNarrow = MediaQuery.sizeOf(context).width < 400;
    final effectiveH = narrow ? 44.0 : height;
    final titleSize = veryNarrow ? 22.0 : (narrow ? 24.0 : 28.0);
    final rule = ed.ink3.withValues(alpha: 0.55);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dotted spacer band between sections, ruled by full-bleed dashes.
        CustomPaint(
          foregroundPainter: DashedRulePainter(rule, top: true, bottom: true),
          child: SizedBox(
            height: narrow ? 26 : 32,
            child: Stack(children: [
              Positioned.fill(child: ColoredBox(color: ed.page)),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Ed.column),
                  child: CustomPaint(
                    painter: DotGridPainter(ed.line2, spacing: 8, radius: 0.7),
                    size: const Size(double.infinity, double.infinity),
                  ),
                ),
              ),
            ]),
          ),
        ),
        // Section heading sitting on its own dashed baseline.
        CustomPaint(
          foregroundPainter: DashedRulePainter(rule, bottom: true),
          child: ColumnBox(
            child: SizedBox(
              height: effectiveH + 6,
              child: Row(
                children: [
                  Expanded(
                    child: Text(title,
                        style: ed.serif(titleSize),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sub-page hero header, styled like the home hero: back link, title +
/// badge, description and highlight pills on the paper column.
class PageHeroBand extends StatelessWidget {
  final String title;
  final String badge;
  final String description;
  final List<({String label, Color color})> highlights;
  final VoidCallback onBack;
  final Widget? extra;

  const PageHeroBand({
    super.key,
    required this.title,
    required this.badge,
    required this.description,
    required this.highlights,
    required this.onBack,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 600;

    // Same treatment as the home hero: content sits on the paper column with
    // plain page gutters (no hatch), and fades in piece by piece.
    return ColumnBox(
      padding: EdgeInsets.fromLTRB(edPad(context), narrow ? 26 : 34, edPad(context), narrow ? 24 : 30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Back breadcrumb
        EdReveal(
          child: Hover(
            onTap: onBack,
            semanticLabel: 'Back home',
            builder: (_, h) => Row(mainAxisSize: MainAxisSize.min, children: [
              AnimatedSlide(
                duration: const Duration(milliseconds: 160),
                offset: Offset(h ? -0.25 : 0, 0),
                child: Icon(LucideIcons.arrowLeft, size: 13, color: h ? ed.ink : ed.ink3),
              ),
              const SizedBox(width: 6),
              Text('~/home', style: ed.mono(10.5, color: h ? ed.ink : ed.ink3)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        // Title (letter-by-letter, like the name on home) + badge
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            SplitReveal(title, delay: const Duration(milliseconds: 80), style: ed.serif(narrow ? 38 : 50)),
            EdReveal(
              delay: const Duration(milliseconds: 400),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ed.card,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: ed.line2),
                ),
                child: Text(
                  badge,
                  style: ed.mono(10, color: ed.ink2, w: FontWeight.w600, ls: 0.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        EdReveal(
          delay: const Duration(milliseconds: 240),
          child: Text(description, style: ed.sans(narrow ? 13.5 : 14.5, color: ed.ink2, h: 1.55)),
        ),
        const SizedBox(height: 16),
        EdReveal(
          delay: const Duration(milliseconds: 360),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final h in highlights) _HeroPill(label: h.label, color: h.color),
            ],
          ),
        ),
        if (extra != null) ...[
          const SizedBox(height: 4),
          EdReveal(delay: const Duration(milliseconds: 440), child: extra!),
        ],
      ]),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label;
  final Color color;
  const _HeroPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ed.line),
      ),
      child: Text(label, style: ed.mono(11, color: ed.ink2, w: FontWeight.w500)),
    );
  }
}


/// Small bordered monospace tag.
class MonoTag extends StatelessWidget {
  final String text;
  const MonoTag(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: ed.raised.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: ed.line),
      ),
      child: Text(text, style: ed.mono(10, color: ed.ink2)),
    );
  }
}

/// Square outline icon button (search, theme, star…).
class EdIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;
  final bool round;
  const EdIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.size = 30,
    this.round = true,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 500),
      child: Hover(
        onTap: onTap,
        semanticLabel: tooltip,
        builder: (_, h) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: h ? ed.raised : Colors.transparent,
            shape: round ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: round ? null : BorderRadius.circular(7),
            border: Border.all(color: h ? ed.line2 : ed.line),
          ),
          child: Icon(icon, size: size * 0.45, color: h ? ed.ink : ed.ink2),
        ),
      ),
    );
  }
}

/// Mono pill button with chevron, e.g. "View All Projects >".
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData icon;
  final bool filled;
  const PillButton(this.label,
      {super.key,
      required this.onTap,
      this.icon = LucideIcons.chevronRight,
      this.filled = false});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: onTap,
      semanticLabel: label,
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: filled
              ? (h ? ed.ink.withValues(alpha: 0.88) : ed.ink)
              : (h ? ed.raised : ed.card),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: filled ? ed.ink : (h ? ed.line2 : ed.line)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: ed.mono(10.5,
                  color: filled ? ed.paper : (h ? ed.ink : ed.ink2))),
          const SizedBox(width: 4),
          AnimatedSlide(
            duration: const Duration(milliseconds: 150),
            offset: Offset(h ? 0.25 : 0, 0),
            child: Icon(icon,
                size: 12, color: filled ? ed.paper : (h ? ed.ink : ed.ink2)),
          ),
        ]),
      ),
    );
  }
}

/// Brand logo for a tech item: monochrome at rest, brand colour on hover.
class TechLogo extends StatelessWidget {
  final TechItem item;
  final bool active;
  final double size;
  const TechLogo(this.item, {super.key, required this.active, this.size = 13});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final on = item.hex != null ? Color(item.hex!) : ed.ink;
    final rest = item.hex != null ? Color(item.hex!).withValues(alpha: 0.88) : ed.ink;
    if (item.icon == null) {
      const glyphs = [
        LucideIcons.waves, // Riverpod
        LucideIcons.hexagon, // Hive
        LucideIcons.network, // REST
        LucideIcons.zap, // Groq
        LucideIcons.databaseZap, // ChromaDB
        LucideIcons.table2, // SQL
      ];
      final g = item.glyph != null && item.glyph! < glyphs.length ? glyphs[item.glyph!] : LucideIcons.box;
      return Icon(g, size: size, color: on);
    }
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: active ? on : rest),
      duration: const Duration(milliseconds: 220),
      builder: (_, c, __) => SvgPicture.asset(
        'assets/icons/tech/${item.icon}.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(c ?? on, BlendMode.srcIn),
      ),
    );
  }
}

/// Integer that counts up from zero the first time it scrolls into view.
class CountUp extends StatefulWidget {
  final int value;
  final String suffix;
  final TextStyle style;
  const CountUp({super.key, required this.value, required this.suffix, required this.style});

  @override
  State<CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<CountUp> {
  final _key = UniqueKey();
  bool _seen = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (!_seen && info.visibleFraction > 0.4 && mounted) {
          setState(() => _seen = true);
        }
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _seen ? widget.value.toDouble() : 0),
        duration: const Duration(milliseconds: 1400),
        curve: Curves.easeOutExpo,
        builder: (_, v, __) => Text('${v.round()}${widget.suffix}', style: widget.style),
      ),
    );
  }
}
