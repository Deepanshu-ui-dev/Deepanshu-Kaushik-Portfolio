import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_fade_in.dart';
import '../../../github/data/github_repository.dart';
import '../../../photography/presentation/screens/gallery_screen.dart';
import '../widgets/contribution_graph.dart';
import 'ed_music_player.dart';
import 'ed_primitives.dart';
import 'ed_projects.dart' show edRoute;
import 'ed_theme.dart';

// ════════════════════════════════════════════════════════════════════
//  HERO — banner + profile header
// ════════════════════════════════════════════════════════════════════

class OpenToWork extends StatelessWidget {
  const OpenToWork({super.key});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ed.live.withValues(alpha: 0.35)),
        color: ed.live.withValues(alpha: 0.07),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        PulseDot(color: ed.live, size: 5),
        const SizedBox(width: 5),
        Text('open to work', style: ed.mono(9, color: ed.dark ? ed.live : const Color(0xFF15803D))),
      ]),
    );
  }
}

class SearchPill extends StatelessWidget {
  final VoidCallback onTap;
  const SearchPill({super.key, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: onTap,
      semanticLabel: 'Open command menu',
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: h ? ed.raised : ed.card,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: h ? ed.line2 : ed.line),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(LucideIcons.search, size: 12, color: ed.ink2),
          const SizedBox(width: 6),
          Text('⌘K', style: ed.mono(10.5, color: ed.ink2)),
        ]),
      ),
    );
  }
}

/// Softly pulsing status dot.
class PulseDot extends StatefulWidget {
  final Color color;
  final double size;
  const PulseDot({super.key, required this.color, this.size = 6});
  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    return RepaintBoundary(child: SizedBox(
      width: s * 2.4,
      height: s * 2.4,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Stack(alignment: Alignment.center, children: [
          Container(
            width: s + s * 1.4 * _c.value,
            height: s + s * 1.4 * _c.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 0.35 * (1 - _c.value)),
            ),
          ),
          Container(
            width: s,
            height: s,
            decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color),
          ),
        ]),
      ),
    ));
  }
}

// ════════════════════════════════════════════════════════════════════
//  ABOUT
// ════════════════════════════════════════════════════════════════════

class EdAbout extends StatelessWidget {
  const EdAbout({super.key});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 600;
    return ColumnBox(
      padding: EdgeInsets.fromLTRB(edPad(context), 22, edPad(context), 28),
      child: ScrollFadeIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statement card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: ed.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ed.line),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 2.5,
                  height: narrow ? 52 : 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF02569B), Color(0xFF3DDC84)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'I build production Flutter apps and the systems behind them — from reactive UIs to multi-agent AI workflows.',
                    style: ed.sans(narrow ? 14 : 15.5, color: ed.ink, w: FontWeight.w600, h: 1.45),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            // Detail bullets
            for (int i = 0; i < PortfolioConfig.aboutBullets.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 10),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ed.ink3,
                      ),
                    ),
                  ),
                  Expanded(child: Text(PortfolioConfig.aboutBullets[i], style: ed.sans(13, color: ed.ink2, h: 1.5))),
                ]),
              ),
            const SizedBox(height: 18),
            const EdMusicPlayer(),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  CONTACT — 5 equal cells divided by hairlines
// ════════════════════════════════════════════════════════════════════

class _Social {
  final String label;
  final String? svg;
  final IconData? icon;
  final String url;
  const _Social(this.label, this.url, {this.svg, this.icon});
}

class EdContact extends StatelessWidget {
  const EdContact({super.key});

  static const _links = [
    _Social('GitHub', PortfolioConfig.githubUrl, svg: 'assets/icons/tech/github.svg'),
    _Social('LinkedIn', PortfolioConfig.linkedinUrl, svg: 'assets/icons/tech/linkedin.svg'),
    _Social('Twitter', PortfolioConfig.twitterUrl, svg: 'assets/icons/tech/x.svg'),
    _Social('Mail', 'mailto:${PortfolioConfig.email}', icon: LucideIcons.mail),
    _Social('Framer', PortfolioConfig.websiteUrl, svg: 'assets/icons/tech/framer.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intro tagline
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 14, edPad(context), 12),
          child: Row(
            children: [
              Text(
                'Find me on',
                style: ed.mono(10, color: ed.ink3, ls: 0.8),
              ),
              const SizedBox(width: 10),
              Expanded(child: Container(height: 1, color: ed.line)),
              const SizedBox(width: 10),
              Text(PortfolioConfig.email, style: ed.mono(10, color: ed.ink2)),
            ],
          ),
        ),
        // Cells
        ColumnBox(
          padding: EdgeInsets.zero,
          child: LayoutBuilder(builder: (context, c) {
            final perRow = c.maxWidth >= 560 ? 5 : (c.maxWidth >= 380 ? 3 : 2);
            final w = c.maxWidth / perRow;
            return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ed.line)),
              ),
              child: Wrap(
                children: [
                  for (int i = 0; i < _links.length; i++)
                    Container(
                      width: w,
                      decoration: BoxDecoration(
                        border: Border(
                          right: (i + 1) % perRow != 0 && i != _links.length - 1
                              ? BorderSide(color: ed.line)
                              : BorderSide.none,
                          bottom: i < _links.length - (_links.length % perRow == 0 ? perRow : _links.length % perRow)
                              ? BorderSide(color: ed.line)
                              : BorderSide.none,
                        ),
                      ),
                      child: _ContactCell(_links[i]),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ContactCell extends StatelessWidget {
  final _Social s;
  const _ContactCell(this.s);

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: () => openUrl(s.url),
      semanticLabel: s.label,
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 52,
        color: h ? ed.raised.withValues(alpha: 0.7) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: ed.card,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: h ? ed.line2 : ed.line),
              ),
              alignment: Alignment.center,
              child: s.svg != null
                  ? SvgPicture.asset(s.svg!,
                      width: 12,
                      height: 12,
                      colorFilter: ColorFilter.mode(h ? ed.ink : ed.ink2, BlendMode.srcIn))
                  : Icon(s.icon, size: 12, color: h ? ed.ink : ed.ink2),
            ),
            const SizedBox(width: 9),
            Flexible(
              child: Text(s.label,
                  style: ed.sans(12, color: h ? ed.ink : ed.ink2, w: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 6),
            AnimatedSlide(
              duration: const Duration(milliseconds: 160),
              offset: h ? const Offset(0.2, -0.2) : Offset.zero,
              child: Icon(LucideIcons.arrowUpRight, size: 11, color: h ? ed.ink : ed.ink3),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  EXPERIENCE — role headers with a phase timeline + stats
// ════════════════════════════════════════════════════════════════════

class EdExperience extends StatelessWidget {
  const EdExperience({super.key});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    const roles = PortfolioConfig.experience;
    return ColumnBox(
      padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 26),
      child: ScrollFadeIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < roles.length; i++) ...[
              if (i > 0) Container(height: 1, color: ed.line),
              _RoleBlock(roles[i], initiallyOpen: i == 0),
            ],
            const SizedBox(height: 24),
            const _StatsStrip(),
          ],
        ),
      ),
    );
  }
}

class _RoleBlock extends StatefulWidget {
  final RoleItem r;
  final bool initiallyOpen;
  const _RoleBlock(this.r, {this.initiallyOpen = false});

  @override
  State<_RoleBlock> createState() => _RoleBlockState();
}

class _RoleBlockState extends State<_RoleBlock> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final r = widget.r;
    final narrow = MediaQuery.sizeOf(context).width < 560;
    final indie = r.company.toLowerCase().contains('independent');

    final header = Hover(
      onTap: () => setState(() => _open = !_open),
      semanticLabel: '${r.role} at ${r.company}, ${_open ? 'collapse' : 'expand'}',
      builder: (_, h) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: r.isCurrent ? ed.ink : ed.raised,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: h ? ed.line2 : ed.line),
            ),
            child: indie
                ? Icon(LucideIcons.terminal, size: 17, color: r.isCurrent ? ed.paper : ed.ink)
                : Text(r.company.substring(0, 1),
                    style: ed.serif(21, color: r.isCurrent ? ed.paper : ed.ink)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.role,
                  style: ed.sans(14.5, color: ed.ink, w: FontWeight.w600, h: 1.25),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text(narrow ? '${r.company}  ·  ${r.period}' : r.company,
                  style: ed.mono(10.5, color: ed.ink3)),
            ]),
          ),
          if (!narrow) ...[
            const SizedBox(width: 12),
            Text(r.period, style: ed.mono(10, color: ed.ink3)),
          ],
          const SizedBox(width: 12),
          AnimatedRotation(
            turns: _open ? 0.5 : 0,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: Icon(LucideIcons.chevronDown, size: 16, color: h ? ed.ink : ed.ink3),
          ),
        ]),
      ),
    );

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      header,
      ClipRect(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: _open
              ? Padding(
                  padding: EdgeInsets.only(left: narrow ? 0 : 50, bottom: 20),
                  child: _details(ed, r),
                )
              : const SizedBox(width: double.infinity),
        ),
      ),
    ]);
  }

  Widget _details(Ed ed, RoleItem r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(r.summary, style: ed.sans(13)),
        const SizedBox(height: 16),
        for (int i = 0; i < r.phases.length; i++)
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              SizedBox(
                width: 16,
                child: Stack(alignment: Alignment.topCenter, children: [
                  Positioned(
                    top: i == 0 ? 6 : 0,
                    bottom: i == r.phases.length - 1 ? null : 0,
                    height: i == r.phases.length - 1 ? 6 : null,
                    child: Container(width: 1, color: ed.line2),
                  ),
                  Positioned(
                    top: 3,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == r.phases.length - 1 && r.isCurrent ? ed.ink : ed.paper,
                        border: Border.all(color: ed.ink2, width: 1.2),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: i == r.phases.length - 1 ? 0 : 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.phases[i].title, style: ed.sans(12.5, color: ed.ink, w: FontWeight.w600, h: 1.3)),
                    const SizedBox(height: 4),
                    Text(r.phases[i].body, style: ed.sans(12.5)),
                  ]),
                ),
              ),
            ]),
          ),
        if (r.tags.isNotEmpty) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Wrap(spacing: 5, runSpacing: 5, children: r.tags.map(MonoTag.new).toList()),
          ),
        ],
      ],
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip();

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    const stats = PortfolioConfig.stats;
    final narrow = MediaQuery.sizeOf(context).width < 520;
    final perRow = narrow ? 2 : stats.length;

    Widget cell(StatItem s, int i) {
      final isTextOnly = s.value == null;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            right: (i + 1) % perRow != 0 ? BorderSide(color: ed.line) : BorderSide.none,
            bottom: narrow && i < stats.length - perRow ? BorderSide(color: ed.line) : BorderSide.none,
          ),
        ),
        child: Column(children: [
          isTextOnly
              ? Text(s.suffix, style: ed.sans(19, color: ed.ink, w: FontWeight.w700, h: 1.15))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    CountUp(
                      value: s.value!,
                      suffix: '',
                      style: ed.sans(22, color: ed.ink, w: FontWeight.w700, h: 1.15),
                    ),
                    Text(s.suffix,
                        style: ed.sans(16, color: ed.ink3, w: FontWeight.w600, h: 1.15)),
                  ],
                ),
          const SizedBox(height: 5),
          Text(s.label.toUpperCase(),
              textAlign: TextAlign.center,
              style: ed.mono(8.5, color: ed.ink3, ls: 1.0)),
        ]),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ed.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: ed.dark ? 0.25 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(builder: (_, c) {
        final w = c.maxWidth / perRow;
        return Wrap(children: [
          for (int i = 0; i < stats.length; i++) SizedBox(width: w, child: cell(stats[i], i)),
        ]);
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  TECH STACK — segmented filter + brand chips
// ════════════════════════════════════════════════════════════════════

class EdTechStack extends StatefulWidget {
  const EdTechStack({super.key});
  @override
  State<EdTechStack> createState() => _EdTechStackState();
}

class _EdTechStackState extends State<EdTechStack> {
  String _active = 'All';

  static const _icons = <String, IconData>{
    'All': LucideIcons.layers,
    'Mobile': LucideIcons.smartphone,
    'Languages': LucideIcons.code,
    'Backend': LucideIcons.server,
    'Databases': LucideIcons.database,
    'AI / ML': LucideIcons.sparkles,
    'Web': LucideIcons.globe,
    'Tools': LucideIcons.wrench,
  };

  @override
  Widget build(BuildContext context) {
    final items = _active == 'All'
        ? PortfolioConfig.techStack
        : PortfolioConfig.techStack.where((t) => t.category == _active).toList();
    final tabs = [
      for (final cat in PortfolioConfig.techCategories)
        _Tab(
          label: cat,
          icon: _icons[cat] ?? LucideIcons.circle,
          active: cat == _active,
          count: cat == 'All'
              ? PortfolioConfig.techStack.length
              : PortfolioConfig.techStack.where((t) => t.category == cat).length,
          onTap: () => setState(() => _active = cat),
          expand: false,
        ),
    ];

    return Column(children: [
      ColumnBox(
        padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 18),
        child: const ScrollFadeIn(child: _FlutterToolkit()),
      ),
      ColumnBox(
        padding: EdgeInsets.fromLTRB(edPad(context), 4, edPad(context), 0),
        child: Wrap(spacing: 4, runSpacing: 4, children: tabs),
      ),
      ColumnBox(
        padding: EdgeInsets.fromLTRB(edPad(context), 14, edPad(context), 26),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: SizedBox(
              key: ValueKey(_active),
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 9,
                children: [for (final t in items) _TechChip(t)],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

/// Primary-stack summary: what I reach for inside a Flutter codebase.
class _FlutterToolkit extends StatelessWidget {
  const _FlutterToolkit();

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final flutter = PortfolioConfig.techStack.firstWhere((t) => t.label == 'Flutter');
    final dart = PortfolioConfig.techStack.firstWhere((t) => t.label == 'Dart');
    const kit = PortfolioConfig.flutterToolkit;

    return Container(
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ed.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: ed.dark ? 0.3 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top accent gradient bar
          Container(
            height: 2.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF02569B), Color(0xFF0175C2), Color(0xFF3DDC84), Color(0xFF5FA04E)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF02569B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: const Color(0xFF02569B).withValues(alpha: 0.3)),
                  ),
                  child: TechLogo(flutter, active: true, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Flutter', style: ed.sans(16, color: ed.ink, w: FontWeight.w700, h: 1.2)),
                          Text('  &  ', style: ed.sans(15, color: ed.ink3, h: 1.2)),
                          TechLogo(dart, active: true, size: 14),
                          const SizedBox(width: 5),
                          Text('Dart', style: ed.sans(16, color: ed.ink, w: FontWeight.w700, h: 1.2)),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: ed.live.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ed.live.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PulseDot(color: ed.live, size: 4.5),
                                const SizedBox(width: 4.5),
                                Text('PRIMARY FOCUS', style: ed.mono(8, color: ed.live, w: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Core specialization — production architecture, reactive state & high-performance UI',
                        style: ed.mono(10, color: ed.ink3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: ed.line),
          LayoutBuilder(builder: (_, c) {
            final per = c.maxWidth >= 600 ? 3 : 2;
            final w = c.maxWidth / per;
            final rows = (kit.length / per).ceil();
            return Wrap(children: [
              for (int i = 0; i < kit.length; i++)
                Container(
                  width: w,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    border: Border(
                      right: (i + 1) % per != 0 ? BorderSide(color: ed.line) : BorderSide.none,
                      bottom: i ~/ per < rows - 1 ? BorderSide(color: ed.line) : BorderSide.none,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(kit[i].$1.toUpperCase(), style: ed.mono(8.5, ls: 1.2, color: ed.ink3)),
                      const SizedBox(height: 4),
                      Text(
                        kit[i].$2,
                        style: ed.sans(13, color: ed.ink, w: FontWeight.w600, h: 1.3),
                      ),
                    ],
                  ),
                ),
            ]);
          }),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final int count;
  final VoidCallback onTap;
  final bool expand;
  const _Tab({
    required this.label,
    required this.icon,
    required this.active,
    required this.count,
    required this.onTap,
    required this.expand,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final fg = active ? (ed.dark ? Colors.white : ed.paper) : ed.ink2;
    final tab = Hover(
      onTap: onTap,
      semanticLabel: 'Filter $label',
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active
              ? (ed.dark ? const Color(0xFF27272A) : ed.ink)
              : (h ? ed.card : Colors.transparent),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: active
                ? (ed.dark ? ed.line2 : ed.ink)
                : (h ? ed.line : Colors.transparent),
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: ed.dark ? 0.35 : 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: active ? fg : (h ? ed.ink : fg)),
            const SizedBox(width: 6),
            Text(
              label,
              style: ed.sans(11.5, color: active ? fg : (h ? ed.ink : fg), w: active ? FontWeight.w600 : FontWeight.w500, h: 1),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: active
                    ? (ed.dark ? Colors.white.withValues(alpha: 0.15) : ed.paper.withValues(alpha: 0.2))
                    : ed.raised,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: ed.mono(9, color: active ? fg : ed.ink3, w: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
    return expand ? Expanded(child: tab) : tab;
  }
}

class _TechChip extends StatelessWidget {
  final TechItem t;
  const _TechChip(this.t);

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final brandColor = t.hex != null ? Color(t.hex!) : null;

    return Hover(
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, h ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: h
              ? (brandColor != null ? brandColor.withValues(alpha: ed.dark ? 0.15 : 0.08) : ed.card)
              : ed.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: h
                ? (brandColor != null ? brandColor.withValues(alpha: 0.6) : ed.ink3)
                : ed.line,
            width: 1,
          ),
          boxShadow: h
              ? [
                  BoxShadow(
                    color: brandColor != null
                        ? brandColor.withValues(alpha: ed.dark ? 0.25 : 0.15)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TechLogo(t, active: h, size: 13),
            const SizedBox(width: 7),
            Text(
              t.label,
              style: ed.mono(11, color: h ? ed.ink : ed.ink2, w: h ? FontWeight.w600 : FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  GITHUB — heatmap with metrics and year switcher
// ════════════════════════════════════════════════════════════════════

class EdGitHubTrailing extends StatelessWidget {
  const EdGitHubTrailing({super.key});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: () => openUrl(PortfolioConfig.githubUrl),
      semanticLabel: 'Open GitHub profile',
      builder: (_, h) => Row(mainAxisSize: MainAxisSize.min, children: [
        Text('@${PortfolioConfig.githubUsername}', style: ed.mono(10.5, color: h ? ed.ink : ed.ink2)),
        const SizedBox(width: 4),
        Icon(LucideIcons.externalLink, size: 11, color: h ? ed.ink : ed.ink2),
      ]),
    );
  }
}

class EdGitHub extends ConsumerStatefulWidget {
  const EdGitHub({super.key});
  @override
  ConsumerState<EdGitHub> createState() => _EdGitHubState();
}

class _EdGitHubState extends ConsumerState<EdGitHub> {
  late final int _thisYear = DateTime.now().year;
  late int _year = _thisYear;

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final data = ref.watch(gitHubYearProvider((PortfolioConfig.githubUsername, _year)));
    final years = [_thisYear, _thisYear - 1, _thisYear - 2];

    return ColumnBox(
      padding: EdgeInsets.fromLTRB(edPad(context), 20, edPad(context), 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header metrics row + Year selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _GitHubMetricBadge(
                      icon: LucideIcons.gitCommit,
                      label: data.maybeWhen(
                        data: (d) => '${d.$2} contributions in $_year',
                        orElse: () => 'Live contributions',
                      ),
                      color: ed.live,
                    ),
                    const _GitHubMetricBadge(
                      icon: LucideIcons.folderGit2,
                      label: '10+ Public Repos',
                    ),
                    const _GitHubMetricBadge(
                      icon: LucideIcons.flame,
                      label: 'Daily Engineering Streak',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Year pill tabs
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: ed.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ed.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final y in years)
                      Hover(
                        onTap: () => setState(() => _year = y),
                        semanticLabel: 'Show $y',
                        builder: (_, h) => AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: y == _year
                                ? (ed.dark ? const Color(0xFF27272A) : ed.ink)
                                : (h ? ed.raised : Colors.transparent),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$y',
                            style: ed.mono(
                              10,
                              color: y == _year
                                  ? (ed.dark ? Colors.white : ed.paper)
                                  : (h ? ed.ink : ed.ink2),
                              w: y == _year ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Heatmap Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ed.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ed.line),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: ed.dark ? 0.3 : 0.03),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: data.when(
                loading: () => _GraphSkeleton(key: ValueKey('l$_year')),
                error: (_, __) => SizedBox(
                  key: ValueKey('e$_year'),
                  height: 120,
                  child: Center(
                    child: Text('// could not load contributions for $_year', style: ed.mono(10.5, color: ed.ink3)),
                  ),
                ),
                data: (d) => Column(
                  key: ValueKey('d$_year'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContributionGraph(contributions: d.$1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Active activity on github.com/${PortfolioConfig.githubUsername}',
                            style: ed.mono(9.5, color: ed.ink3),
                          ),
                        ),
                        Text('Less', style: ed.mono(9, color: ed.ink3)),
                        const SizedBox(width: 5),
                        for (final c in ed.dark
                            ? const [
                                AppColors.contrib0Dark,
                                AppColors.contrib1Dark,
                                AppColors.contrib2Dark,
                                AppColors.contrib3Dark,
                                AppColors.contrib4Dark,
                              ]
                            : const [
                                AppColors.contrib0Light,
                                AppColors.contrib1Light,
                                AppColors.contrib2Light,
                                AppColors.contrib3Light,
                                AppColors.contrib4Light,
                              ])
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(left: 2.5),
                            decoration: BoxDecoration(
                              color: c,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        const SizedBox(width: 5),
                        Text('More', style: ed.mono(9, color: ed.ink3)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GitHubMetricBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _GitHubMetricBadge({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final clr = color ?? ed.ink2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ed.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: clr),
          const SizedBox(width: 5),
          Text(label, style: ed.mono(9.5, color: clr, w: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _GraphSkeleton extends StatelessWidget {
  const _GraphSkeleton({super.key});
  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return SizedBox(
      height: 120,
      child: LayoutBuilder(builder: (_, c) {
        final cols = (c.maxWidth / 12).floor().clamp(1, 53);
        return Wrap(
          direction: Axis.vertical,
          spacing: 3,
          runSpacing: 3,
          children: List.generate(cols * 7, (i) {
            return Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: ed.raised.withValues(alpha: 0.5 + (i * 37 % 5) * 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  PHOTOGRAPHY — visual storytelling preview
// ════════════════════════════════════════════════════════════════════

class EdPhotography extends StatelessWidget {
  const EdPhotography({super.key});

  static const _previewPhotos = [
    ('assets/images/mount.jpeg', 'Mountain Mist', 'Landscape'),
    ('assets/images/sunshine.jpg', 'Golden Hour', 'Atmosphere'),
    ('assets/images/cafe.jpeg', 'Coffee & Film', 'Interior'),
    ('assets/images/cat.jpeg', 'Street Companion', 'Life'),
    ('assets/images/fire.jpg', 'Campfire Glow', 'Night'),
    ('assets/images/flower.jpeg', 'Botanical Flow', 'Macro'),
  ];

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intro subtitle banner
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 16, edPad(context), 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Moments captured through the lens — visual rhythm, natural light, and quiet geometry.',
                  style: ed.sans(13, color: ed.ink2, h: 1.4),
                ),
              ),
              const SizedBox(width: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ed.card,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: ed.line),
                ),
                child: Text('[ 14 SHOTS ]', style: ed.mono(10, color: ed.ink2, w: FontWeight.w600)),
              ),
            ],
          ),
        ),
        Container(height: 1, color: ed.line),
        // Photo showcase grid
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 16, edPad(context), 20),
          child: LayoutBuilder(builder: (context, c) {
            final perRow = c.maxWidth >= 540 ? 3 : 2;
            const spacing = 12.0;
            final itemW = (c.maxWidth - spacing * (perRow - 1)) / perRow;
            final itemH = itemW * 0.82;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final photo in _previewPhotos)
                  Hover(
                    onTap: () => Navigator.of(context).push(edRoute(const GalleryScreen())),
                    semanticLabel: photo.$2,
                    builder: (_, h) => AnimatedScale(
                      scale: h ? 1.025 : 1.0,
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      child: Container(
                        width: itemW,
                        height: itemH,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: h ? ed.ink : ed.line, width: h ? 1.4 : 1),
                          boxShadow: [
                            if (h)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: ed.dark ? 0.35 : 0.08),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              photo.$1,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: ed.raised,
                                child: Icon(LucideIcons.image, size: 24, color: ed.ink3),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 48,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.65),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              bottom: 8,
                              right: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      photo.$2,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: -0.1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.22),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      photo.$3,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
        Container(height: 1, color: ed.line),
        // Bottom gallery trigger bar
        ColumnBox(
          padding: EdgeInsets.fromLTRB(edPad(context), 12, edPad(context), 16),
          child: Row(
            children: [
              Icon(LucideIcons.camera, size: 13, color: ed.ink3),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '14 original full-resolution captures in the gallery',
                  style: ed.mono(10.5, color: ed.ink3),
                ),
              ),
              PillButton(
                'View all photos',
                icon: LucideIcons.arrowUpRight,
                onTap: () => Navigator.of(context).push(edRoute(const GalleryScreen())),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  FOOTER — credit, visitor counter, live local clock, contact callout
// ════════════════════════════════════════════════════════════════════

class EdFooter extends StatefulWidget {
  final VoidCallback onTop;
  const EdFooter({super.key, required this.onTop});
  @override
  State<EdFooter> createState() => _EdFooterState();
}

class _EdFooterState extends State<EdFooter> {
  late Timer _tick;
  DateTime _now = DateTime.now().toUtc();
  int? _visits;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now().toUtc());
    });
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      final count = await supabase.rpc('increment_visits');
      if (mounted) setState(() => _visits = count as int);
    } catch (_) {}
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  String get _clock {
    final t = _now.add(const Duration(minutes: PortfolioConfig.utcOffsetMinutes));
    final h12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(h12)}:${two(t.minute)}:${two(t.second)} ${t.hour < 12 ? 'AM' : 'PM'} ${PortfolioConfig.timezoneLabel}';
  }

  String _ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    return '$n${const ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th'][n % 10]}';
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 600;

    return Column(children: [
      Container(height: 1, color: ed.line),
      ColumnBox(
        padding: EdgeInsets.fromLTRB(edPad(context), 28, edPad(context), 36),
        child: Column(
          children: [
            // Top CTA Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              decoration: BoxDecoration(
                color: ed.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ed.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: ed.dark ? 0.35 : 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: narrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Let’s build something together.', style: ed.serif(24)),
                        const SizedBox(height: 4),
                        Text(
                          'Available for full-time engineering roles, high-impact Flutter apps, and technical collaborations.',
                          style: ed.sans(12.5, color: ed.ink2, h: 1.45),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            PillButton('Say hello', icon: LucideIcons.mail, onTap: () => openUrl('mailto:${PortfolioConfig.email}')),
                            PillButton('View Resume', icon: LucideIcons.fileText, onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Let’s build something together.', style: ed.serif(26)),
                              const SizedBox(height: 4),
                              Text(
                                'Available for full-time engineering roles, high-impact Flutter apps, and technical collaborations.',
                                style: ed.sans(13, color: ed.ink2, h: 1.45),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 18),
                        PillButton('Say hello', icon: LucideIcons.mail, onTap: () => openUrl('mailto:${PortfolioConfig.email}')),
                        const SizedBox(width: 8),
                        PillButton('Resume', icon: LucideIcons.fileText, onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                      ],
                    ),
            ),
            const SizedBox(height: 28),
            // Socials and Colophon Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(PortfolioConfig.name, style: ed.sans(15, color: ed.ink, w: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PulseDot(color: ed.live, size: 5),
                          const SizedBox(width: 5),
                          Text('${PortfolioConfig.location}  ·  $_clock', style: ed.mono(10, color: ed.ink2)),
                        ],
                      ),
                    ],
                  ),
                ),
                PillButton('Back to top', onTap: widget.onTop, icon: LucideIcons.arrowUp),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: ed.line),
            const SizedBox(height: 16),
            // Bottom Meta Row
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('© ${DateTime.now().year}  ·  Built with Flutter Web', style: ed.mono(10, color: ed.ink3)),
                      if (_visits != null && _visits! > 0) ...[
                        const SizedBox(width: 8),
                        Text('·', style: ed.mono(10, color: ed.ink3)),
                        const SizedBox(width: 8),
                        Text("${_ordinal(_visits!)} visitor", style: ed.mono(10, color: ed.ink2, w: FontWeight.w500)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
