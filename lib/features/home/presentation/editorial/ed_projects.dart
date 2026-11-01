import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/scroll_fade_in.dart';
import '../../../../core/widgets/smooth_scroll.dart';
import 'ed_nav.dart';
import 'ed_pages.dart';
import 'ed_primitives.dart';
import 'ed_sections.dart' show PulseDot;
import 'ed_theme.dart';

// ════════════════════════════════════════════════════════════════════
//  Routing helpers
// ════════════════════════════════════════════════════════════════════

Route<T> edRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, a, __, child) {
        final c = CurvedAnimation(parent: a, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
        return FadeTransition(
          opacity: c,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.015), end: Offset.zero).animate(c),
            child: child,
          ),
        );
      },
    );

void openProject(BuildContext context, ProjectItem p, String heroPrefix) {
  Navigator.of(context).push(edRoute(ProjectDetailPage(project: p, heroPrefix: heroPrefix)));
}

void openProjectsPage(BuildContext context) {
  Navigator.of(context).push(edRoute(const ProjectsPage()));
}

/// From a sub-page: return to the home page and scroll to [section]
/// (or to the top when null).
void goHome(BuildContext context, [EdSection? section]) {
  Navigator.of(context).popUntil((r) => r.isFirst);
  if (section == null) {
    edTopRequest.value++;
  } else {
    edSectionRequest.value = null;
    edSectionRequest.value = section;
  }
}


// ════════════════════════════════════════════════════════════════════
//  Cover — browser-window chrome around a screenshot or an
//  auto-generated architecture diagram
// ════════════════════════════════════════════════════════════════════

class ProjectCover extends StatelessWidget {
  final ProjectItem p;
  final bool hovered;
  final double height;
  final String? heroTag;
  final bool colour;
  const ProjectCover(this.p,
      {super.key, this.hovered = false, this.height = 180, this.heroTag, this.colour = true});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final hasImg = p.imageAsset != null;

    final Widget body;
    if (hasImg) {
      body = AnimatedScale(
        scale: hovered ? 1.04 : 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        child: Image.asset(
          p.imageAsset!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          errorBuilder: (_, __, ___) => Container(
            color: ed.raised,
            alignment: Alignment.center,
            child: Icon(LucideIcons.folderGit2, size: 30, color: ed.ink3),
          ),
        ),
      );
    } else {
      body = ArchDiagram(p, hovered: hovered);
    }

    // Determine domain or repository URL for browser pill
    final String urlText;
    if (p.liveUrl != null) {
      urlText = p.liveUrl!.replaceFirst(RegExp(r'^https?://'), '').replaceAll(RegExp(r'/$'), '');
    } else if (p.githubUrl != null) {
      urlText = p.githubUrl!.replaceFirst(RegExp(r'^https?://'), '').replaceAll(RegExp(r'/$'), '');
    } else if (p.figmaUrl != null) {
      urlText = 'figma.com/design/${p.name.toLowerCase()}';
    } else {
      urlText = '${p.name.toLowerCase()}.internal';
    }

    Widget cover = Container(
      height: height,
      decoration: BoxDecoration(
        color: ed.canvas,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: hovered ? ed.line2 : ed.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Browser window chrome header
          Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: ed.card,
              border: Border(bottom: BorderSide(color: ed.line, width: 0.8)),
            ),
            child: Row(
              children: [
                // 3 traffic dots
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _trafficDot(hovered ? const Color(0xFFFF5F56) : ed.ink3.withValues(alpha: 0.35)),
                    const SizedBox(width: 5),
                    _trafficDot(hovered ? const Color(0xFFFFBD2E) : ed.ink3.withValues(alpha: 0.35)),
                    const SizedBox(width: 5),
                    _trafficDot(hovered ? const Color(0xFF27C93F) : ed.ink3.withValues(alpha: 0.35)),
                  ],
                ),
                const SizedBox(width: 10),
                // URL bar capsule
                Expanded(
                  child: Container(
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: ed.raised.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ed.line.withValues(alpha: 0.5), width: 0.8),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          p.liveUrl != null ? LucideIcons.globe : (p.githubUrl != null ? LucideIcons.gitBranch : LucideIcons.lock),
                          size: 9.5,
                          color: ed.ink3,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            urlText,
                            style: ed.mono(8.5, color: ed.ink2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (p.badge == 'Live' || p.liveUrl != null) ...[
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PulseDot(color: ed.live, size: 4.5),
                      const SizedBox(width: 4),
                      Text('live', style: ed.mono(8.5, color: ed.live, w: FontWeight.w600)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Window body
          Expanded(
            child: ClipRect(
              child: body,
            ),
          ),
        ],
      ),
    );

    if (heroTag != null) {
      cover = Hero(
        tag: heroTag!,
        flightShuttleBuilder: (_, __, ___, ____, to) => Material(type: MaterialType.transparency, child: to.widget),
        child: Material(type: MaterialType.transparency, child: cover),
      );
    }
    return cover;
  }

  static Widget _trafficDot(Color c) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

}

/// Auto-generated system diagram from [ProjectItem.architecture]:
/// client → service → fan-out to data / infra nodes.
class ArchDiagram extends StatelessWidget {
  final ProjectItem p;
  final bool hovered;
  final double scale;
  const ArchDiagram(this.p, {super.key, this.hovered = false, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    if (p.architecture.isEmpty) return _DesignCover(p, hovered: hovered);
    final nodes = p.architecture;
    final first = nodes.first;
    final second = nodes.length > 2 ? nodes[1] : null;
    final rest = nodes.length > 2 ? nodes.sublist(2) : nodes.sublist(1);

    Widget node(String label, {bool primary = false}) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: primary ? ed.ink : ed.paper,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: primary ? ed.ink : (hovered ? ed.ink3 : ed.line2)),
          ),
          child: Text(label, style: ed.mono(8.5, color: primary ? ed.paper : ed.ink)),
        );

    final diagram = Row(mainAxisSize: MainAxisSize.min, children: [
      node(first, primary: true),
      if (second != null) ...[
        _Arrow(color: hovered ? ed.ink2 : ed.ink3, active: hovered),
        node(second),
      ],
      if (rest.isNotEmpty) ...[
        _Fork(count: rest.length, color: hovered ? ed.ink2 : ed.ink3, active: hovered),
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (int i = 0; i < rest.length; i++) ...[
            node(rest[i]),
            if (i < rest.length - 1) const SizedBox(height: 6),
          ],
        ]),
      ],
    ]);

    return Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _GridPainter(ed.line))),
      Positioned(
        left: 10,
        top: 8,
        child: Text('SYSTEM · ${p.name.toUpperCase()}', style: ed.mono(7.5, ls: 1.2)),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 22, 14, 10),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Transform.scale(scale: scale, child: diagram),
          ),
        ),
      ),
    ]);
  }
}

/// Cover for design-only work: three screen frames on a canvas, the middle
/// one selected.
class _DesignCover extends StatelessWidget {
  final ProjectItem p;
  final bool hovered;
  const _DesignCover(this.p, {required this.hovered});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    Widget frame(double w, double h, {bool selected = false}) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: w,
          height: h,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: ed.paper,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: selected ? ed.select : ed.line2, width: selected ? 1.2 : 1),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(height: 4, width: w * 0.45, color: ed.ink.withValues(alpha: 0.7)),
            const SizedBox(height: 4),
            Container(height: 3, width: w * 0.6, color: ed.line2),
            const SizedBox(height: 6),
            Expanded(child: Container(decoration: BoxDecoration(color: ed.raised, borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 5),
            Container(height: 7, decoration: BoxDecoration(color: ed.ink.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(2))),
          ]),
        );
    return Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _GridPainter(ed.line))),
      Positioned(left: 10, top: 8, child: Text('FIGMA · ${p.name.toUpperCase()}', style: ed.mono(7.5, ls: 1.2))),
      Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 22, 10, 10),
            child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
              AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: Offset(hovered ? -0.08 : 0, 0),
                child: frame(52, 96),
              ),
              const SizedBox(width: 10),
              frame(62, 114, selected: true),
              const SizedBox(width: 10),
              AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: Offset(hovered ? 0.08 : 0, 0),
                child: frame(52, 96),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}

class _Arrow extends StatelessWidget {
  final Color color;
  final bool active;
  const _Arrow({required this.color, required this.active});
  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(24, 10), painter: _ArrowPainter(color));
}

class _ArrowPainter extends CustomPainter {
  final Color c;
  const _ArrowPainter(this.c);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..strokeWidth = 1;
    final y = s.height / 2;
    canvas.drawLine(Offset(3, y), Offset(s.width - 3, y), p);
    canvas.drawLine(Offset(s.width - 7, y - 3), Offset(s.width - 3, y), p);
    canvas.drawLine(Offset(s.width - 7, y + 3), Offset(s.width - 3, y), p);
  }

  @override
  bool shouldRepaint(_ArrowPainter o) => o.c != c;
}

class _Fork extends StatelessWidget {
  final int count;
  final Color color;
  final bool active;
  const _Fork({required this.count, required this.color, required this.active});
  @override
  Widget build(BuildContext context) {
    final h = count * 24.0 + (count - 1) * 6;
    return CustomPaint(size: Size(28, h), painter: _ForkPainter(count, color));
  }
}

class _ForkPainter extends CustomPainter {
  final int n;
  final Color c;
  const _ForkPainter(this.n, this.c);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = c
      ..strokeWidth = 1;
    final mid = s.height / 2;
    const x = 12.0;
    canvas.drawLine(Offset(3, mid), Offset(x, mid), p);
    final ys = [for (int i = 0; i < n; i++) 12.0 + i * 30];
    canvas.drawLine(Offset(x, ys.first), Offset(x, ys.last), p);
    for (final y in ys) {
      canvas.drawLine(Offset(x, y), Offset(s.width - 3, y), p);
      canvas.drawLine(Offset(s.width - 7, y - 3), Offset(s.width - 3, y), p);
      canvas.drawLine(Offset(s.width - 7, y + 3), Offset(s.width - 3, y), p);
    }
  }

  @override
  bool shouldRepaint(_ForkPainter o) => o.n != n || o.c != c;
}

class _GridPainter extends CustomPainter {
  final Color c;
  const _GridPainter(this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = c.withValues(alpha: 0.6)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 18) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter o) => o.c != c;
}

// ════════════════════════════════════════════════════════════════════
//  Card (home grid)
// ════════════════════════════════════════════════════════════════════

class ProjectCard extends StatelessWidget {
  final ProjectItem p;
  final bool fill;
  final String heroPrefix;
  const ProjectCard(this.p, {super.key, this.fill = false, this.heroPrefix = 'home'});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final extra = p.tags.length > 3 ? p.tags.length - 3 : 0;
    return Hover(
      onTap: () => openProject(context, p, heroPrefix),
      semanticLabel: 'Open ${p.name}',
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, h ? -4 : 0, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ed.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: h ? ed.ink3.withValues(alpha: 0.5) : ed.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: h ? (ed.dark ? 0.45 : 0.08) : (ed.dark ? 0.18 : 0.02)),
              blurRadius: h ? 24 : 8,
              offset: Offset(0, h ? 10 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProjectCover(p, hovered: h, height: 185, heroTag: '$heroPrefix-${p.name}'),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          style: ed.sans(17.5, color: ed.ink, w: FontWeight.w700, h: 1.2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 180),
                        offset: Offset(h ? 0.15 : 0, h ? -0.15 : 0),
                        child: Icon(
                          LucideIcons.arrowUpRight,
                          size: 16.5,
                          color: h ? ed.ink : ed.ink3,
                        ),
                      ),
                    ],
                  ),
                  if (p.tagline != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      p.tagline!,
                      style: ed.mono(11, color: ed.ink3, ls: 0.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: ed.sans(13, color: ed.ink2, h: 1.45),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (fill) const Spacer(),
            const SizedBox(height: 14),
            Container(height: 1, color: ed.line),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      ...p.tags.take(3).map(MonoTag.new),
                      if (extra > 0) MonoTag('+$extra'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ..._linkGlyphs(p),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _linkGlyphs(ProjectItem p) => [
      if (p.liveUrl != null) LinkGlyph(LucideIcons.globe, 'Live site', p.liveUrl!),
      if (p.githubUrl != null) LinkGlyph(LucideIcons.gitBranch, 'Source code', p.githubUrl!),
      if (p.installUrl != null) LinkGlyph(LucideIcons.download, 'Download build', p.installUrl!),
      if (p.figmaUrl != null) LinkGlyph(LucideIcons.penTool, 'Figma file', p.figmaUrl!),
    ];

class LinkGlyph extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const LinkGlyph(this.icon, this.label, this.url, {super.key});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 400),
      child: Hover(
        onTap: () => openUrl(url),
        semanticLabel: label,
        builder: (_, h) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: h ? ed.raised : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: h ? ed.line2 : Colors.transparent),
          ),
          child: Icon(icon, size: 14, color: h ? ed.ink : ed.ink3),
        ),
      ),
    );
  }
}

/// Home-page project grid — features Codexa and Meridian with navigation to full catalog.
/// Home projects view mode, shared between the band toggle and the section.
final edProjectsList = ValueNotifier<bool>(false);

/// Grid / list switch shown in the Projects band.
class ProjectsViewToggle extends StatelessWidget {
  const ProjectsViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    Widget seg(bool list, IconData icon, String label, bool active) => Tooltip(
          message: label,
          waitDuration: const Duration(milliseconds: 500),
          child: Hover(
            onTap: () => edProjectsList.value = list,
            semanticLabel: label,
            builder: (_, h) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 28,
              height: 22,
              decoration: BoxDecoration(
                color: active ? ed.ink : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(icon, size: 12, color: active ? ed.paper : (h ? ed.ink : ed.ink3)),
            ),
          ),
        );
    return ValueListenableBuilder<bool>(
      valueListenable: edProjectsList,
      builder: (_, list, __) => Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: ed.card,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: ed.line),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          seg(false, LucideIcons.layoutGrid, 'Grid view', !list),
          seg(true, LucideIcons.list, 'List view', list),
        ]),
      ),
    );
  }
}

class EdProjects extends StatelessWidget {
  final int count;
  const EdProjects({super.key, this.count = 2});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    const all = PortfolioConfig.projects;
    // Featured on the landing page: Codexa and Meridian lead the grid.
    final codexa = all.firstWhere((p) => p.name.toLowerCase() == 'codexa', orElse: () => all[0]);
    final meridian = all.firstWhere(
      (p) => p.name.toLowerCase() == 'meridian',
      orElse: () => all.length > 2 ? all[2] : all[1],
    );
    final featured = [codexa, meridian];
    // The list view is a denser index of the engineering work.
    final listed = [
      ...featured,
      ...all.where((p) => !featured.contains(p) && !p.categories.contains('Design')),
    ].take(5).toList();

    final twoUp = MediaQuery.sizeOf(context).width >= 640;
    final total = all.length;

    Widget grid() => twoUp
        ? IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(child: ProjectCard(featured[0], fill: true)),
              const SizedBox(width: 14),
              Expanded(child: ProjectCard(featured[1], fill: true)),
            ]),
          )
        : Column(children: [
            ProjectCard(featured[0]),
            const SizedBox(height: 14),
            ProjectCard(featured[1]),
          ]);

    Widget list() => Container(
          decoration: BoxDecoration(
            color: ed.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ed.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: [
            for (int i = 0; i < listed.length; i++) ...[
              if (i > 0) Container(height: 1, color: ed.line),
              _ProjectListRow(listed[i]),
            ],
          ]),
        );

    return ColumnBox(
      padding: EdgeInsets.fromLTRB(edPad(context), 22, edPad(context), 24),
      child: ScrollFadeIn(
        child: Column(children: [
          ValueListenableBuilder<bool>(
            valueListenable: edProjectsList,
            builder: (_, isList, __) => AnimatedSize(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(a),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(key: ValueKey(isList), child: isList ? list() : grid()),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Hover(
            onTap: () => openProjectsPage(context),
            semanticLabel: 'View all projects',
            builder: (_, h) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 44,
              decoration: BoxDecoration(
                color: h ? ed.raised : ed.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: h ? ed.ink3 : ed.line),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'View all $total projects',
                  style: ed.sans(13, color: ed.ink, w: FontWeight.w600, h: 1),
                ),
                const SizedBox(width: 8),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  offset: Offset(h ? 0.35 : 0, 0),
                  child: Icon(LucideIcons.arrowRight, size: 15, color: ed.ink),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Compact project row: thumbnail, name + tagline, stack, arrow.
class _ProjectListRow extends StatelessWidget {
  final ProjectItem p;
  const _ProjectListRow(this.p);

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 560;
    return Hover(
      onTap: () => openProject(context, p, 'homelist'),
      semanticLabel: p.name,
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        color: h ? ed.raised.withValues(alpha: 0.6) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Container(
            width: narrow ? 56 : 72,
            height: narrow ? 40 : 48,
            decoration: BoxDecoration(
              color: ed.raised,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: h ? ed.line2 : ed.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: p.imageAsset != null
                ? AnimatedScale(
                    scale: h ? 1.08 : 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(p.imageAsset!,
                        fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
                  )
                : Center(child: Text(p.name.substring(0, 1), style: ed.serif(22, color: ed.ink2))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                  child: Text(p.name,
                      style: ed.sans(14, color: ed.ink, w: FontWeight.w600, h: 1.2),
                      overflow: TextOverflow.ellipsis),
                ),
                if (p.liveUrl != null) ...[
                  const SizedBox(width: 8),
                  PulseDot(color: ed.live, size: 4.5),
                ],
              ]),
              const SizedBox(height: 4),
              Text(
                p.tagline ?? p.description,
                style: ed.mono(10.5, color: ed.ink3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
          if (!narrow) ...[
            const SizedBox(width: 12),
            Text(p.tags.take(2).join(' · '), style: ed.mono(10, color: ed.ink3)),
          ],
          const SizedBox(width: 14),
          AnimatedSlide(
            duration: const Duration(milliseconds: 180),
            offset: h ? const Offset(0.15, -0.15) : Offset.zero,
            child: Icon(LucideIcons.arrowUpRight, size: 14, color: h ? ed.ink : ed.ink3),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Shared sub-page scaffold (full-width section nav + framed column)
// ════════════════════════════════════════════════════════════════════

class EdSubScaffold extends ConsumerStatefulWidget {
  final String trail;
  final int activeIndex;
  final Widget Function(BuildContext context, ScrollController scroll) builder;
  final VoidCallback? onSearch;
  const EdSubScaffold({
    super.key,
    required this.trail,
    required this.builder,
    this.activeIndex = 2,
    this.onSearch,
  });

  @override
  ConsumerState<EdSubScaffold> createState() => _EdSubScaffoldState();
}

typedef _SubScaffold = EdSubScaffold;

class _EdSubScaffoldState extends ConsumerState<EdSubScaffold> {
  final _scroll = ScrollController();
  final _floating = ValueNotifier(false);
  final _progress = ValueNotifier(0.0);
  late final _active = ValueNotifier(widget.activeIndex);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      final pos = _scroll.position;
      _floating.value = pos.pixels > 24;
      _progress.value = pos.maxScrollExtent <= 0 ? 0 : (pos.pixels / pos.maxScrollExtent).clamp(0, 1);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _floating.dispose();
    _progress.dispose();
    _active.dispose();
    super.dispose();
  }

  void _select(int i) {
    switch (i) {
      case 0:
        goHome(context);
        break;
      case 1:
        if (widget.trail == '/ about') {
          _scroll.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
          return;
        }
        openAboutPage(context);
        break;
      case 2:
        if (widget.trail == '/ projects') {
          _scroll.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
          return;
        }
        openProjectsPage(context);
        break;
      case 3:
        if (widget.trail == '/ skills') {
          _scroll.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
          return;
        }
        openSkillsPage(context);
        break;
      case 4:
        if (widget.trail == '/ contact') {
          _scroll.animateTo(0, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
          return;
        }
        openContactPage(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () => Navigator.of(context).maybePop(),
        const SingleActivator(LogicalKeyboardKey.keyT): () => ref.read(themeModeProvider.notifier).toggle(),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: ed.page,
          body: Stack(children: [
            // Dot-grid background in the side black backgrounds
            Positioned.fill(
              child: CustomPaint(
                painter: DotGridPainter(
                  ed.dark ? const Color(0xFF2B2B30) : const Color(0xFFE2E2E6),
                  spacing: 22,
                  radius: 1.1,
                ),
              ),
            ),
            SmoothScroll(
              controller: _scroll,
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const SizedBox(height: Ed.headerH),
                  widget.builder(context, _scroll),
                  const ColumnBox(child: SizedBox(height: 60)),
                ]),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: EdNavBar(
                floating: _floating,
                progress: _progress,
                activeIndex: _active,
                trail: widget.trail,
                onSelect: _select,
                onBrand: () => goHome(context),
                onSearch: widget.onSearch ?? () => Navigator.of(context).maybePop(),
                onToggleTheme: () => ref.read(themeModeProvider.notifier).toggle(),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  PROJECTS PAGE — search, filters, numbered rows
// ════════════════════════════════════════════════════════════════════

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _query = TextEditingController();
  final _searchFocus = FocusNode();
  String _filter = 'All';
  bool _isGrid = true;

  static const _filters = ['All', 'Flutter', 'Full-stack', 'AI / ML', 'Systems', 'Design'];

  List<ProjectItem> get _results {
    final q = _query.text.trim().toLowerCase();
    return PortfolioConfig.projects.where((p) {
      final inFilter = _filter == 'All' || p.categories.contains(_filter);
      final inQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          (p.tagline ?? '').toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
      return inFilter && inQuery;
    }).toList();
  }

  int _count(String f) =>
      f == 'All' ? PortfolioConfig.projects.length : PortfolioConfig.projects.where((p) => p.categories.contains(f)).length;

  @override
  void dispose() {
    _query.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final results = _results;
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 600;
    final twoUp = width >= 640;

    final gridRows = <Widget>[];
    if (twoUp) {
      for (int i = 0; i < results.length; i += 2) {
        gridRows.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Staggered(
                  index: i,
                  child: ProjectCard(results[i], fill: true, heroPrefix: 'grid'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: i + 1 < results.length
                    ? _Staggered(
                        index: i + 1,
                        child: ProjectCard(results[i + 1], fill: true, heroPrefix: 'grid'),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ));
        if (i + 2 < results.length) gridRows.add(const SizedBox(height: 14));
      }
    } else {
      for (int i = 0; i < results.length; i++) {
        gridRows.add(_Staggered(
          index: i,
          child: ProjectCard(results[i], heroPrefix: 'grid'),
        ));
        if (i < results.length - 1) gridRows.add(const SizedBox(height: 14));
      }
    }

    return _SubScaffold(
      trail: '/ projects',
      onSearch: () => _searchFocus.requestFocus(),
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Hero band — full-bleed with hatched gutters like home page sections
        PageHeroBand(
          title: 'Projects',
          badge: '[ 0${PortfolioConfig.projects.length} ]',
          description:
              'Production Flutter applications, distributed backend services, and AI systems — engineered with modern architectures, clean state management, and real-time data.',
          highlights: [
            (label: '✦ 4 Live Applications', color: ed.live),
            (label: '⚡ 10+ Projects Built', color: ed.ink2),
            (label: '⚙️ Full-Stack & AI Systems', color: ed.ink2),
          ],
          onBack: () => goHome(context),
          extra: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Search bar
            Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: ed.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ed.line),
              ),
              child: Row(children: [
                Icon(LucideIcons.search, size: 14.5, color: ed.ink3),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _query,
                    focusNode: _searchFocus,
                    onChanged: (_) => setState(() {}),
                    cursorColor: ed.ink,
                    cursorWidth: 1.2,
                    style: ed.mono(12, color: ed.ink),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search by name or tech — e.g. flutter, redis, langgraph, firebase...',
                      hintStyle: ed.mono(12, color: ed.ink3),
                    ),
                  ),
                ),
                if (_query.text.isNotEmpty)
                  Hover(
                    onTap: () => setState(_query.clear),
                    semanticLabel: 'Clear search',
                    builder: (_, h) => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: h ? ed.raised : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.x, size: 13, color: h ? ed.ink : ed.ink3),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 12),
            // Filter chips and view toggle
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      for (final f in _filters)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Hover(
                            onTap: () => setState(() => _filter = f),
                            semanticLabel: 'Filter $f',
                            builder: (_, h) => AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6.5),
                              decoration: BoxDecoration(
                                color: f == _filter ? ed.ink : (h ? ed.raised : ed.card),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: f == _filter ? ed.ink : ed.line),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(
                                  f,
                                  style: ed.sans(
                                    12,
                                    color: f == _filter ? ed.paper : ed.ink2,
                                    w: FontWeight.w500,
                                    h: 1,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${_count(f)}',
                                  style: ed.mono(
                                    9.5,
                                    color: f == _filter ? ed.paper.withValues(alpha: 0.6) : ed.ink3,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                // Grid / List View Toggle
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: ed.card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ed.line),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ViewToggleBtn(
                        icon: LucideIcons.layoutGrid,
                        label: 'Grid view',
                        active: _isGrid,
                        onTap: () => setState(() => _isGrid = true),
                      ),
                      Container(width: 1, height: 16, color: ed.line),
                      _ViewToggleBtn(
                        icon: LucideIcons.list,
                        label: 'List view',
                        active: !_isGrid,
                        onTap: () => setState(() => _isGrid = false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
        ),
        // Section band divider before project grid
        SectionBand('[ 01 ] ALL PROJECTS'),
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 16, edPad(context), 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            child: results.isEmpty
                ? Padding(
                    key: const ValueKey('empty'),
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Column(children: [
                      Icon(LucideIcons.searchX, size: 24, color: ed.ink3),
                      const SizedBox(height: 12),
                      Text('No projects match “${_query.text}”', style: ed.mono(12, color: ed.ink2)),
                      const SizedBox(height: 14),
                      PillButton('Clear filters', icon: LucideIcons.rotateCcw, onTap: () {
                        setState(() {
                          _query.clear();
                          _filter = 'All';
                        });
                      }),
                    ]),
                  )
                : Column(
                    key: ValueKey('$_isGrid|$_filter|${_query.text}'),
                    children: [
                      if (_isGrid)
                        ...gridRows
                      else
                        for (int i = 0; i < results.length; i++)
                          _Staggered(index: i, child: _ProjectRow(results[i], index: i)),
                    ],
                  ),
          ),
        ),
        // GitHub footer band
        SectionBand('[ 02 ] MORE ON GITHUB'),
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 22, edPad(context), 28),
          child: Row(children: [
            Expanded(
              child: Text(
                'Explore more experiments, scripts, and open-source contributions on GitHub.',
                style: ed.sans(12.5, color: ed.ink2),
              ),
            ),
            PillButton('github.com/${PortfolioConfig.githubUsername}',
                icon: LucideIcons.arrowUpRight, onTap: () => openUrl(PortfolioConfig.githubUrl)),
          ]),
        ),
      ]),
    );
  }
}

class _HighlightBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _HighlightBadge(this.text, this.color);
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ed.line),
      ),
      child: Text(text, style: ed.mono(9.5, color: color)),
    );
  }
}

class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ViewToggleBtn({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: label,
      child: Hover(
        onTap: onTap,
        semanticLabel: label,
        builder: (_, h) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? ed.ink : (h ? ed.raised : Colors.transparent),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            size: 14,
            color: active ? ed.paper : (h ? ed.ink : ed.ink3),
          ),
        ),
      ),
    );
  }
}

class _Staggered extends StatelessWidget {
  final int index;
  final Widget child;
  const _Staggered({required this.index, required this.child});
  @override
  Widget build(BuildContext context) {
    final delay = (index * 70).clamp(0, 420);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delay),
      curve: Interval(delay / (420 + delay), 1, curve: Curves.easeOutCubic),
      builder: (_, t, c) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 14 * (1 - t)), child: c),
      ),
      child: child,
    );
  }
}

class _ProjectRow extends StatelessWidget {
  final ProjectItem p;
  final int index;
  const _ProjectRow(this.p, {required this.index});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 680;

    return Hover(
      onTap: () => openProject(context, p, 'list'),
      semanticLabel: 'Open ${p.name}',
      builder: (_, h) {
        final info = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text((index + 1).toString().padLeft(2, '0'), style: ed.mono(10, color: ed.ink3)),
            const SizedBox(width: 10),
            for (final c in p.categories)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(c.toUpperCase(), style: ed.mono(8.5, ls: 1.2, color: ed.ink3)),
              ),
            const Spacer(),
            if (p.year != null) Text(p.year!, style: ed.mono(10)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Flexible(
              child: Text(
                p.name,
                style: ed.serif(28, italic: h),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: h ? 1 : 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                offset: Offset(h ? 0 : -0.4, 0),
                child: Icon(LucideIcons.arrowRight, size: 18, color: ed.ink),
              ),
            ),
          ]),
          if (p.tagline != null) Text(p.tagline!, style: ed.mono(10.5, color: ed.ink2)),
          const SizedBox(height: 8),
          Text(p.description, style: ed.sans(12.5), maxLines: 3, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Wrap(spacing: 5, runSpacing: 5, children: [
                for (final t in p.tags.take(6)) _TechTag(t),
              ]),
            ),
            ..._linkGlyphs(p),
          ]),
        ]);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: h ? ed.card : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: h ? ed.line2 : Colors.transparent),
          ),
          child: wide
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: 260, child: ProjectCover(p, hovered: h, height: 168, heroTag: 'list-${p.name}')),
                  const SizedBox(width: 20),
                  Expanded(child: info),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ProjectCover(p, hovered: h, height: 170, heroTag: 'list-${p.name}'),
                  const SizedBox(height: 14),
                  info,
                ]),
        );
      },
    );
  }
}

/// Tag with the matching brand logo when one exists in the tech stack.
class _TechTag extends StatelessWidget {
  final String label;
  const _TechTag(this.label);
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final match = PortfolioConfig.techStack.where((t) => t.label.toLowerCase() == label.toLowerCase());
    if (match.isEmpty) return MonoTag(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      decoration: BoxDecoration(
        color: ed.raised.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: ed.line),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        TechLogo(match.first, active: true, size: 10),
        const SizedBox(width: 5),
        Text(label, style: ed.mono(10, color: ed.ink2)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  PROJECT DETAIL
// ════════════════════════════════════════════════════════════════════

class ProjectDetailPage extends StatelessWidget {
  final ProjectItem project;
  final String heroPrefix;
  const ProjectDetailPage({super.key, required this.project, required this.heroPrefix});

  @override
  Widget build(BuildContext context) {
    final p = project;
    final ed = Ed.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 600;
    const all = PortfolioConfig.projects;
    final next = all[(all.indexOf(p) + 1) % all.length];

    final status = p.liveUrl != null
        ? 'Live'
        : p.githubUrl != null
            ? 'Open source'
            : p.figmaUrl != null
                ? 'Design file'
                : '—';

    return _SubScaffold(
      trail: '/ projects / ${p.name.toLowerCase()}',
      onSearch: () => Navigator.of(context).maybePop(),
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 30, edPad(context), 22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Hover(
              onTap: () => Navigator.of(context).maybePop(),
              semanticLabel: 'Back',
              builder: (_, h) => Row(mainAxisSize: MainAxisSize.min, children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 160),
                  offset: Offset(h ? -0.25 : 0, 0),
                  child: Icon(LucideIcons.arrowLeft, size: 13, color: h ? ed.ink : ed.ink3),
                ),
                const SizedBox(width: 6),
                Text('back', style: ed.mono(10.5, color: h ? ed.ink : ed.ink3)),
              ]),
            ),
            const SizedBox(height: 18),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final c in p.categories) MonoTag(c),
              if (p.badge == 'Live')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: ed.live.withValues(alpha: 0.4)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    PulseDot(color: ed.live, size: 4),
                    Text('live', style: ed.mono(10, color: ed.live)),
                  ]),
                ),
            ]),
            const SizedBox(height: 12),
            Text(p.name, style: ed.serif(narrow ? 42 : 56)),
            if (p.tagline != null) Text(p.tagline!, style: ed.serif(narrow ? 20 : 24, italic: true, color: ed.ink2)),
            const SizedBox(height: 22),
            // Diagram-only projects show their system in the Architecture
            // section instead, so the header cover isn't a duplicate.
            if (p.imageAsset != null || p.architecture.isEmpty) ...[
              ProjectCover(p, height: narrow ? 220 : 340, heroTag: '$heroPrefix-${p.name}', colour: true),
              const SizedBox(height: 18),
            ],
            _MetaStrip(items: [
              if (p.year != null) ('Year', p.year!),
              ('Type', p.categories.join(' · ')),
              ('Stack', '${p.tags.length} technologies'),
              ('Status', status),
            ]),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (p.liveUrl != null) _Action('Visit live site', LucideIcons.arrowUpRight, p.liveUrl!, filled: true),
              if (p.githubUrl != null)
                _Action('Source code', LucideIcons.gitBranch, p.githubUrl!, filled: p.liveUrl == null),
              if (p.installUrl != null) _Action('Download build', LucideIcons.download, p.installUrl!),
              if (p.figmaUrl != null) _Action('Open in Figma', LucideIcons.penTool, p.figmaUrl!, filled: true),
            ]),
          ]),
        ),
        const SectionBand('Overview'),
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 24),
          child: Text(p.description, style: ed.sans(15, color: ed.ink, h: 1.65)),
        ),
        if (p.features.isNotEmpty) ...[
          const SectionBand('Features'),
          ColumnBox(
            padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 24),
            child: LayoutBuilder(builder: (_, c) {
              final cols = c.maxWidth >= 560 ? 2 : 1;
              final w = (c.maxWidth - 10 * (cols - 1)) / cols;
              return Wrap(spacing: 10, runSpacing: 10, children: [
                for (int i = 0; i < p.features.length; i++)
                  SizedBox(
                    width: w,
                    child: ScrollFadeIn(
                      delay: Duration(milliseconds: 60 * i),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: ed.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ed.line),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text((i + 1).toString().padLeft(2, '0'), style: ed.mono(10, color: ed.ink3)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(p.features[i], style: ed.sans(13, color: ed.ink, w: FontWeight.w500, h: 1.4))),
                        ]),
                      ),
                    ),
                  ),
              ]);
            }),
          ),
        ],
        if (p.architecture.isNotEmpty) ...[
          const SectionBand('Architecture'),
          ColumnBox(
            padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: narrow ? 200 : 240,
                decoration: BoxDecoration(
                  color: ed.canvas,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ed.line),
                ),
                clipBehavior: Clip.antiAlias,
                child: ArchDiagram(p, hovered: true, scale: narrow ? 1 : 1.25),
              ),
              const SizedBox(height: 8),
              Text('High-level data flow: ${p.architecture.join('  →  ')}', style: ed.mono(10)),
            ]),
          ),
        ],
        const SectionBand('Tech Stack'),
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 26),
          child: Wrap(spacing: 8, runSpacing: 8, children: [for (final t in p.tags) _TechTag(t)]),
        ),
        Container(height: 1, color: ed.line),
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 10),
          child: Hover(
            onTap: () => Navigator.of(context).pushReplacement(edRoute(ProjectDetailPage(project: next, heroPrefix: 'next'))),
            semanticLabel: 'Next project ${next.name}',
            builder: (_, h) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: h ? ed.card : ed.raised.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: h ? ed.line2 : ed.line),
              ),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('NEXT PROJECT', style: ed.mono(9, ls: 1.6)),
                    const SizedBox(height: 6),
                    Text(next.name, style: ed.serif(30, italic: h)),
                    if (next.tagline != null) Text(next.tagline!, style: ed.mono(10.5, color: ed.ink2)),
                  ]),
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 200),
                  offset: Offset(h ? 0.2 : 0, 0),
                  child: Icon(LucideIcons.arrowRight, size: 22, color: ed.ink),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _MetaStrip extends StatelessWidget {
  final List<(String, String)> items;
  const _MetaStrip({required this.items});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Container(
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ed.line),
      ),
      child: LayoutBuilder(builder: (_, c) {
        final per = c.maxWidth >= 560 ? items.length : 2;
        final w = c.maxWidth / per;
        return Wrap(children: [
          for (int i = 0; i < items.length; i++)
            Container(
              width: w,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                border: Border(
                  right: (i + 1) % per != 0 ? BorderSide(color: ed.line) : BorderSide.none,
                  bottom: per == 2 && i < 2 ? BorderSide(color: ed.line) : BorderSide.none,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(items[i].$1.toUpperCase(), style: ed.mono(8.5, ls: 1.3)),
                const SizedBox(height: 4),
                Text(items[i].$2,
                    style: ed.sans(12.5, color: ed.ink, w: FontWeight.w500, h: 1.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ]),
            ),
        ]);
      }),
    );
  }
}

class _Action extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;
  final bool filled;
  const _Action(this.label, this.icon, this.url, {this.filled = false});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: () => openUrl(url),
      semanticLabel: label,
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        transform: Matrix4.translationValues(0, h ? -1 : 0, 0),
        decoration: BoxDecoration(
          color: filled ? (h ? ed.ink.withValues(alpha: 0.88) : ed.ink) : (h ? ed.raised : ed.card),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: filled ? ed.ink : (h ? ed.line2 : ed.line)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: filled ? ed.paper : ed.ink2),
          const SizedBox(width: 8),
          Text(label, style: ed.sans(12.5, color: filled ? ed.paper : ed.ink, w: FontWeight.w500, h: 1)),
        ]),
      ),
    );
  }
}
