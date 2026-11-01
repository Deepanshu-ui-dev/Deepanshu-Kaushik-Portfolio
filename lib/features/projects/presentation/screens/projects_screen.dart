import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_fade_in.dart';
import '../../../../core/widgets/shared_widgets.dart';





class ProjectsScreen extends StatefulWidget {
  final ScrollController? scrollController;
  const ProjectsScreen({super.key, this.scrollController});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  String? _activeFilter;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  static const _filterTags = ['UI/UX', 'Flutter', 'CLI', 'Web', 'Open Source'];

  List<ProjectItem> get _filtered {
    const all = PortfolioConfig.projects;
    if (_activeFilter == null) return all;
    return all
        .where((p) =>
            p.tags.any((t) => t.toLowerCase() == _activeFilter!.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = AppSpacing.horizontalPadding(context);
    final filtered = _filtered;
    final bottomClear = MediaQuery.of(context).padding.bottom + 96.0;

    return FadeTransition(
      opacity: _fade,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                  left: pad,
                  right: pad,
                  top: AppSpacing.base,
                  bottom: bottomClear),
              sliver: SliverList.list(
                children: [
                  
                  ScrollFadeIn(
                    child: _ProjectsHero(count: filtered.length),
                  ),

                   
                  ScrollFadeIn(
                    delay: const Duration(milliseconds: 100),
                    child: _FilterSection(
                      tags: _filterTags,
                      active: _activeFilter,
                      onSelect: (t) => setState(
                          () => _activeFilter = _activeFilter == t ? null : t),
                    ),
                  ),

                  const SizedBox(height: 48),

                  
                  if (filtered.isEmpty)
                    const _EmptyState()
                  else
                    _ProjectGrid(projects: filtered),

                  const SizedBox(height: 64),
                  
                  
                  const ScrollFadeIn(
                    delay: Duration(milliseconds: 200),
                    child: _OpenSourceSection(),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}







class _ProjectsHero extends StatelessWidget {
  final int count;
  const _ProjectsHero({required this.count});

  @override
  Widget build(BuildContext context) {
    final textSec = AppColors.textSecondary;
    final accent = AppColors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(children: [
          Text(
            '[ 02 ]',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: accent, letterSpacing: 1.5),
          ),
          const SizedBox(width: 10),
          Text(
            'PROJECTS',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: textSec, letterSpacing: 2),
          ),
        ]),
        const SizedBox(height: 14),

        Text(
          "Selected Projects.",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: AppSpacing.headlineSize(
                  context,
                  mobile: 30,
                  tablet: 38,
                  laptop: 44,
                ),
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
                height: 1.0,
              ),
        ),
        const SizedBox(height: 16),

        
        Row(children: [
          Expanded(
            child: Text(
              'Open source experiments & production software. Built with intent. Shipped with care.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textSec, height: 1.65),
            ),
          ),
        ]),
      ],
    );
  }
}





class _FilterSection extends StatelessWidget {
  final List<String> tags;
  final String? active;
  final ValueChanged<String> onSelect;

  const _FilterSection({
    required this.tags,
    required this.active,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final textSec = AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 18, height: 1, color: textSec),
            const SizedBox(width: 8),
            Text(
              'FILTER BY TYPE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec, letterSpacing: 3, fontSize: 9),
            ),
          ]),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _FilterChip(
                label: 'All',
                isActive: active == null,
                onTap: () => onSelect('__all__'),
              ),
              ...tags.map((t) => _FilterChip(
                    label: t,
                    isActive: active == t,
                    onTap: () => onSelect(t),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent;
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final textSec  = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final surface  = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isActive
                ? accent
                : _hov
                    ? textSec
                    : surface,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  letterSpacing: 1.5,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive
                      ? (isDark ? AppColors.bgDark : Colors.white)
                      : _hov
                          ? (isDark ? AppColors.bgDark : Colors.white)
                          : textSec,
                ),
          ),
        ),
      ),
    );
  }
}





class _ProjectGrid extends StatelessWidget {
  final List<ProjectItem> projects;
  const _ProjectGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = 12.0;
      final isWide = constraints.maxWidth > AppSpacing.mobileMax;

      final List<Widget> children = [];
      for (int i = 0; i < projects.length; i++) {
        final child = _ProjectCard(project: projects[i])
            .animate()
            .fade(
              duration: 400.ms,
              delay: Duration(milliseconds: 100 + i * 60),
            )
            .slideY(
              begin: 0.05,
              end: 0,
              duration: 400.ms,
              delay: Duration(milliseconds: 100 + i * 60),
              curve: Curves.easeOut,
            );

        if (isWide) {
          if (i + 1 < projects.length) {
            final nextChild = _ProjectCard(project: projects[i + 1])
                .animate()
                .fade(
                  duration: 400.ms,
                  delay: Duration(milliseconds: 120 + (i + 1) * 70),
                )
                .slideY(
                  begin: 0.05,
                  end: 0,
                  duration: 400.ms,
                  delay: Duration(milliseconds: 120 + (i + 1) * 70),
                  curve: Curves.easeOut,
                );
            children.add(
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: child),
                    const SizedBox(width: spacing),
                    Expanded(child: nextChild),
                  ],
                ),
              ),
            );
            i++; 
          } else {
            children.add(
              Row(
                children: [
                  Expanded(child: child),
                  const SizedBox(width: spacing),
                  const Spacer(),
                ],
              ),
            );
          }
          if (i < projects.length - 1) {
            children.add(const SizedBox(height: spacing));
          }
        } else {
          children.add(child);
          if (i < projects.length - 1) {
            children.add(const SizedBox(height: spacing));
          }
        }
      }
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
    });
  }
}





class _ProjectCard extends StatefulWidget {
  final ProjectItem project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark     : AppColors.textSecLight;
    final surface = isDark ? AppColors.surfaceElevDark : AppColors.surfaceLight;
    final border  = isDark ? AppColors.borderDark      : AppColors.borderLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? (isDark ? AppColors.border2Dark : AppColors.border2Light)
                : border,
            width: _hovered ? 1.0 : 0.5,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Project image header ──
            _ProjectImageHeader(imageAsset: widget.project.imageAsset),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Year
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.project.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: textPri,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.project.year != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.project.year!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textSec,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    widget.project.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSec,
                      height: 1.65,
                      fontSize: 12.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Tech chips
                  if (widget.project.tags.isNotEmpty)
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: widget.project.tags.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? AppColors.border2Dark
                                  : AppColors.borderLight,
                              width: 0.6,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: textSec,
                                  fontSize: 10,
                                  letterSpacing: 0.1,
                                ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 14),

                  // Link icons — right aligned
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.project.liveUrl != null)
                        _IconLinkBtn(
                          icon: LucideIcons.globe,
                          url: widget.project.liveUrl!,
                          isDark: isDark,
                        ),
                      if (widget.project.figmaUrl != null)
                        _IconLinkBtn(
                          icon: LucideIcons.palette,
                          url: widget.project.figmaUrl!,
                          isDark: isDark,
                        ),
                      if (widget.project.installUrl != null)
                        _IconLinkBtn(
                          icon: LucideIcons.download,
                          url: widget.project.installUrl!,
                          isDark: isDark,
                        ),
                      if (widget.project.githubUrl != null)
                        _IconLinkBtn(
                          icon: LucideIcons.gitFork,
                          url: widget.project.githubUrl!,
                          isDark: isDark,
                        ),
                    ],
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





/// Full-width project image header with a subtle dark scrim
class _ProjectImageHeader extends StatelessWidget {
  final String? imageAsset;
  const _ProjectImageHeader({this.imageAsset});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fallbackColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceElevLight;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: SizedBox(
        height: 165,
        width: double.infinity,
        child: imageAsset != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: fallbackColor),
                  ),
                ],
              )
            : Container(color: fallbackColor),
      ),
    );
  }
}





/// Small circular icon button for live / github links
class _IconLinkBtn extends StatefulWidget {
  final IconData icon;
  final String url;
  final bool isDark;

  const _IconLinkBtn({
    required this.icon,
    required this.url,
    required this.isDark,
  });

  @override
  State<_IconLinkBtn> createState() => _IconLinkBtnState();
}

class _IconLinkBtnState extends State<_IconLinkBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final border = widget.isDark ? AppColors.borderDark : AppColors.borderLight;
    final iconColor = widget.isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final hoverBg = widget.isDark
        ? AppColors.surfaceElevDark
        : AppColors.surfaceElevLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered ? hoverBg : Colors.transparent,
            border: Border.all(
              color: _hovered
                  ? (widget.isDark ? AppColors.border2Dark : AppColors.borderLight)
                  : border,
              width: 0.6,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 14,
            color: _hovered
                ? (widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                : iconColor,
          ),
        ),
      ),
    );
  }
}





class _OpenSourceSection extends StatelessWidget {
  const _OpenSourceSection();

  static const _items = [
    _OSItem(
        number: '01',
        text:
            'All projects are open source — fork, star, and contribute on GitHub.'),
    _OSItem(
        number: '02',
        text:
            'Each ships with a detailed README, clear architecture, and production-ready structure.'),
    _OSItem(
        number: '03',
        text:
            'Built in public — commits, issues, and pull requests are all visible and documented.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader('Open Source Contributions', index: '03'),
        ..._items.map((item) => _OSRow(item: item)),
      ],
    );
  }
}

class _OSItem {
  final String number;
  final String text;
  const _OSItem({required this.number, required this.text});
}

class _OSRow extends StatefulWidget {
  final _OSItem item;
  const _OSRow({required this.item});

  @override
  State<_OSRow> createState() => _OSRowState();
}

class _OSRowState extends State<_OSRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _hovered ? accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(_hovered ? 10 : 0, 13, 14, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: (Theme.of(context).textTheme.labelMedium ?? const TextStyle())
                    .copyWith(color: _hovered ? accent : accent),
                child: Text(widget.item.number),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.item.text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final border = AppColors.border;
    final textSec = AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 56),
      decoration: BoxDecoration(border: Border.all(color: border)),
      child: Column(children: [
        Icon(Icons.folder_off_outlined, size: 24, color: border),
        const SizedBox(height: 10),
        Text(
          'NO MATCHING PROJECTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: textSec, letterSpacing: 2),
        ),
      ]),
    );
  }
}