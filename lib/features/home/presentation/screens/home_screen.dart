import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/scroll_fade_in.dart';
import '../../../github/data/github_repository.dart';
import '../widgets/contribution_graph.dart';

// ------------------------------------------------------------------
//  HOME SCREEN  (single-page scrollable portfolio)
// ------------------------------------------------------------------

class HomeScreen extends ConsumerStatefulWidget {
  final ScrollController? scrollController;
  const HomeScreen({super.key, this.scrollController});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hPad = AppSpacing.horizontalPadding(context);
    final bottomClear = MediaQuery.of(context).padding.bottom + 40.0;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const SliverToBoxAdapter(child: _BannerImage()),
            SliverPadding(
              padding: EdgeInsets.only(
                left: hPad,
                right: hPad,
                bottom: bottomClear,
              ),
              sliver: SliverList.list(
                children: const [
                  _ProfileHeader(),
                  SizedBox(height: 28),
                  _HomeDivider(),
                  SizedBox(height: 28),
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 60),
                    child: _AboutSection(),
                  ),
                  SizedBox(height: 28),
                  _HomeDivider(),
                  SizedBox(height: 28),
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 80),
                    child: _ContactSection(),
                  ),
                  SizedBox(height: 28),
                  _HomeDivider(),
                  SizedBox(height: 28),
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 100),
                    child: _HomeProjectsSection(),
                  ),
                  SizedBox(height: 28),
                  _HomeDivider(),
                  SizedBox(height: 28),
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 120),
                    child: _ExperienceSection(),
                  ),
                  SizedBox(height: 28),
                  _HomeDivider(),
                  SizedBox(height: 28),
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 140),
                    child: _TechStackSection(),
                  ),
                  SizedBox(height: 28),
                  _HomeDivider(),
                  SizedBox(height: 28),
                  ScrollFadeIn(
                    delay: Duration(milliseconds: 160),
                    child: _GitHubActivitySection(),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
//  BANNER
// ------------------------------------------------------------------

class _BannerImage extends StatelessWidget {
  const _BannerImage();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Image.asset(
        'assets/images/profile_banner.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            color: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------------
//  PROFILE HEADER
// ------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/profile.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
                child: Icon(LucideIcons.user, size: 24, color: textSec),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PortfolioConfig.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: -0.4,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  PortfolioConfig.role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textSec, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(LucideIcons.mapPin, size: 11, color: textSec),
                  const SizedBox(width: 4),
                  Text(
                    PortfolioConfig.location,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, fontSize: 10.5),
                  ),
                ]),
              ],
            ),
          ),
          _SmallIconBtn(
            icon: LucideIcons.fileText,
            tooltip: 'Resume',
            onTap: () => launchUrl(Uri.parse(PortfolioConfig.resumeUrl)),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
//  ABOUT
// ------------------------------------------------------------------

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  static const _bullets = [
    'UI/UX Designer & Flutter Developer crafting pixel-perfect, high-performance digital products with clean code and bold design.',
    'Currently working as Founding Designer at BarterNow and freelancing for web & mobile clients worldwide.',
    'Pursuing B.Tech in Data Science at ABES Engineering College (2023-2027) — blending engineering rigour with creative design thinking.',
    'Open to collaborating on ambitious design systems, Flutter apps, and product interfaces.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('About'),
        const SizedBox(height: 14),
        ..._bullets.map((b) => _BulletRow(text: b)),
      ],
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String text;
  const _BulletRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 10),
            child: Container(
              width: 5, height: 5,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
          ),
          Expanded(
            child: Text(text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSec, height: 1.65, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
//  CONTACT
// ------------------------------------------------------------------

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    const links = [
      _SocialLink('GitHub',   LucideIcons.gitFork,       PortfolioConfig.githubUrl),
      _SocialLink('LinkedIn', LucideIcons.briefcase,     PortfolioConfig.linkedinUrl),
      _SocialLink('Twitter',  LucideIcons.messageSquare, PortfolioConfig.twitterUrl),
      _SocialLink('Mail',     LucideIcons.mail,          'mailto:imdeepanshu4work@gmail.com'),
      _SocialLink('Framer',   LucideIcons.externalLink,  PortfolioConfig.websiteUrl),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Contact'),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: links.map((l) => _SocialChip(link: l)).toList(),
        ),
      ],
    );
  }
}

class _SocialLink {
  final String label;
  final IconData icon;
  final String url;
  const _SocialLink(this.label, this.icon, this.url);
}

class _SocialChip extends StatefulWidget {
  final _SocialLink link;
  const _SocialChip({required this.link});
  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hover = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.link.url);
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: _hovered ? hover : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: _hovered ? border2 : border, width: 0.7),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(widget.link.icon, size: 13, color: _hovered ? textPri : textSec),
            const SizedBox(width: 7),
            Text(widget.link.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _hovered ? textPri : textSec,
                      fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            Icon(LucideIcons.arrowUpRight, size: 11, color: _hovered ? textPri : textSec),
          ]),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
//  PROJECTS (home preview — 2 featured cards)
// ------------------------------------------------------------------

class _HomeProjectsSection extends StatelessWidget {
  const _HomeProjectsSection();

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioConfig.projects.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Expanded(child: _SectionTitle('Projects')),
          _ViewAllBtn(label: 'View All Projects'),
        ]),
        const SizedBox(height: 14),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > AppSpacing.mobileMax) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: _HomeProjectCard(project: projects[0])
                          .animate()
                          .fade(duration: 400.ms, delay: 60.ms)
                          .slideY(begin: 0.04, end: 0, duration: 400.ms, delay: 60.ms)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _HomeProjectCard(project: projects[1])
                          .animate()
                          .fade(duration: 400.ms, delay: 120.ms)
                          .slideY(begin: 0.04, end: 0, duration: 400.ms, delay: 120.ms)),
                ],
              ),
            );
          }
          return Column(
            children: projects
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HomeProjectCard(project: p)))
                .toList(),
          );
        }),
      ],
    );
  }
}

class _HomeProjectCard extends StatefulWidget {
  final ProjectItem project;
  const _HomeProjectCard({required this.project});
  @override
  State<_HomeProjectCard> createState() => _HomeProjectCardState();
}

class _HomeProjectCardState extends State<_HomeProjectCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final surface = isDark ? AppColors.surfaceElevDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _hovered ? border2 : border, width: _hovered ? 1.0 : 0.5),
          boxShadow: _hovered
              ? [BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.10),
                  blurRadius: 20, offset: const Offset(0, 6))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: SizedBox(
                height: 155, width: double.infinity,
                child: widget.project.imageAsset != null
                    ? Stack(fit: StackFit.expand, children: [
                        Image.asset(widget.project.imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                                color: isDark ? AppColors.surfaceDark : AppColors.surfaceElevLight)),
                      ])
                    : Container(color: isDark ? AppColors.surfaceDark : AppColors.surfaceElevLight),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Text(widget.project.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700, color: textPri,
                                fontSize: 15, letterSpacing: -0.3),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    if (widget.project.year != null) ...[
                      const SizedBox(width: 8),
                      Text(widget.project.year!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: textSec, fontSize: 11.5)),
                    ],
                  ]),
                  const SizedBox(height: 7),
                  Text(widget.project.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textSec, height: 1.6, fontSize: 12),
                      maxLines: 4, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  if (widget.project.tags.isNotEmpty)
                    Wrap(
                      spacing: 5, runSpacing: 5,
                      children: widget.project.tags.map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: isDark ? AppColors.border2Dark : AppColors.borderLight,
                                width: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(t,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: textSec, fontSize: 10)),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.project.liveUrl != null)
                        _CardIconBtn(icon: LucideIcons.globe, url: widget.project.liveUrl!, isDark: isDark),
                      if (widget.project.figmaUrl != null)
                        _CardIconBtn(icon: LucideIcons.palette, url: widget.project.figmaUrl!, isDark: isDark),
                      if (widget.project.installUrl != null)
                        _CardIconBtn(icon: LucideIcons.download, url: widget.project.installUrl!, isDark: isDark),
                      if (widget.project.githubUrl != null)
                        _CardIconBtn(icon: LucideIcons.gitFork, url: widget.project.githubUrl!, isDark: isDark),
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

class _CardIconBtn extends StatefulWidget {
  final IconData icon;
  final String url;
  final bool isDark;
  const _CardIconBtn({required this.icon, required this.url, required this.isDark});
  @override
  State<_CardIconBtn> createState() => _CardIconBtnState();
}

class _CardIconBtnState extends State<_CardIconBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final border = widget.isDark ? AppColors.borderDark : AppColors.borderLight;
    final iconColor = widget.isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final hoverBg = widget.isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28, height: 28,
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered ? hoverBg : Colors.transparent,
            border: Border.all(color: border, width: 0.6),
          ),
          child: Icon(widget.icon, size: 13,
              color: _hovered
                  ? (widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                  : iconColor),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
//  EXPERIENCE
// ------------------------------------------------------------------

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Experience'),
        const SizedBox(height: 16),
        const _ExpCard(
          role: 'Founding Designer',
          company: 'BarterNow',
          period: 'Jan 2026 — Present',
          summary: 'Designing the core product interface and visual identity as the founding designer for an early-stage startup focused on sponsorship matching.',
          bullets: [
            'Built a scalable design system in Figma ensuring UI consistency across all product screens.',
            'Collaborated with engineers to translate high-fidelity prototypes into pixel-perfect production interfaces.',
            'Established brand guidelines, typography, colour tokens, and icon system from scratch.',
          ],
          tags: ['Figma', 'Framer', 'Design Systems', 'Prototyping'],
        ),
        const SizedBox(height: 14),
        const _ExpCard(
          role: 'Freelance UI/UX Designer',
          company: 'Self-Employed',
          period: 'May 2025 — Present',
          summary: 'Delivering end-to-end design solutions for web and mobile apps across multiple client projects worldwide.',
          bullets: [
            'Designed responsive dashboards and product interfaces focused on usability and clean visual hierarchy.',
            'Created reusable design systems and component libraries using Figma and Framer.',
            'Collaborated with developers to translate design concepts into functional cross-platform interfaces.',
          ],
          tags: ['Figma', 'Framer', 'Flutter', 'Dart', 'Tailwind CSS'],
        ),
        const SizedBox(height: 24),
        _StatsRow(),
      ],
    );
  }
}

class _ExpCard extends StatelessWidget {
  final String role;
  final String company;
  final String period;
  final String summary;
  final List<String> bullets;
  final List<String> tags;
  const _ExpCard({
    required this.role, required this.company, required this.period,
    required this.summary, required this.bullets, required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surface = isDark ? AppColors.surfaceElevDark : AppColors.surfaceLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: role,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700, color: textPri, fontSize: 14),
                  ),
                  TextSpan(
                    text: '  ·  $company',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textSec, fontSize: 12.5),
                  ),
                ]),
              ),
            ),
            const SizedBox(width: 8),
            Text(period,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: textSec, fontSize: 10.5)),
          ]),
          const SizedBox(height: 8),
          Text(summary,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textSec, height: 1.6, fontSize: 12.5)),
          const SizedBox(height: 10),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Container(
                        width: 4, height: 4,
                        decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
                  ),
                  Expanded(
                      child: Text(b,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: textSec, height: 1.6, fontSize: 12))),
                ]),
              )),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5, runSpacing: 5,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                border: Border.all(color: isDark ? border2 : border, width: 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(t,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: textSec, fontSize: 10)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;

    const stats = [
      ('8+', 'Projects\nShipped'),
      ('3+', 'Client\nProjects'),
      ('Figma\n& Flutter', 'Core\nSkills'),
      ('450+', 'LeetCode\nSolved'),
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: border, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  right: i < stats.length - 1
                      ? BorderSide(color: border, width: 0.5)
                      : BorderSide.none,
                ),
              ),
              child: Column(children: [
                Text(stat.$1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800, color: textPri,
                          fontSize: 15, fontFamily: 'Inter')),
                const SizedBox(height: 3),
                Text(stat.$2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, fontSize: 9, height: 1.4, letterSpacing: 0.3)),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ------------------------------------------------------------------
//  TECH STACK
// ------------------------------------------------------------------

class _TechStackSection extends StatefulWidget {
  const _TechStackSection();
  @override
  State<_TechStackSection> createState() => _TechStackSectionState();
}

class _TechStackSectionState extends State<_TechStackSection> {
  String _active = 'All';

  static const _categories = ['All', 'Design', 'Languages', 'Frameworks', 'Tools'];

  static const _techItems = [
    _TechItem('Figma',        LucideIcons.penTool,    'Design'),
    _TechItem('Framer',       LucideIcons.layers,     'Design'),
    _TechItem('Adobe XD',     LucideIcons.pencil,     'Design'),
    _TechItem('Photoshop',    LucideIcons.image,      'Design'),
    _TechItem('Dart',         LucideIcons.code2,      'Languages'),
    _TechItem('C++',          LucideIcons.terminal,   'Languages'),
    _TechItem('HTML5',        LucideIcons.globe,      'Languages'),
    _TechItem('CSS3',         LucideIcons.palette,    'Languages'),
    _TechItem('JavaScript',   LucideIcons.zap,        'Languages'),
    _TechItem('Python',       LucideIcons.terminal,   'Languages'),
    _TechItem('Flutter',      LucideIcons.smartphone, 'Frameworks'),
    _TechItem('Riverpod',     LucideIcons.layers,     'Frameworks'),
    _TechItem('Tailwind CSS', LucideIcons.wind,       'Frameworks'),
    _TechItem('React',        LucideIcons.atom,       'Frameworks'),
    _TechItem('Git',          LucideIcons.gitBranch,  'Tools'),
    _TechItem('GitHub',       LucideIcons.gitFork,    'Tools'),
    _TechItem('Supabase',     LucideIcons.database,   'Tools'),
    _TechItem('Firebase',     LucideIcons.flame,      'Tools'),
    _TechItem('VS Code',      LucideIcons.code,       'Tools'),
    _TechItem('Hive',         LucideIcons.hexagon,    'Tools'),
  ];

  List<_TechItem> get _filtered => _active == 'All'
      ? _techItems
      : _techItems.where((t) => t.category == _active).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Expanded(child: _SectionTitle('Tech Stack')),
          Text('{ select tab to filter }',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec, fontSize: 9.5, fontFamily: 'Inter')),
        ]),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isActive = cat == _active;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _active = cat),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: isActive ? accent : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: 0.7,
                        ),
                      ),
                      child: Text(cat,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isActive ? (isDark ? AppColors.bgDark : Colors.white) : textSec,
                                fontSize: 11,
                                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 7, runSpacing: 7,
          children: _filtered.map((t) => _TechChip(item: t)).toList(),
        ),
      ],
    );
  }
}

class _TechItem {
  final String label;
  final IconData icon;
  final String category;
  const _TechItem(this.label, this.icon, this.category);
}

class _TechChip extends StatefulWidget {
  final _TechItem item;
  const _TechChip({required this.item});
  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hover = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: _hovered ? hover : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: _hovered ? border2 : border, width: 0.6),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(widget.item.icon, size: 12, color: _hovered ? textPri : textSec),
          const SizedBox(width: 6),
          Text(widget.item.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _hovered ? textPri : textSec,
                    fontSize: 11.5, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

// ------------------------------------------------------------------
//  GITHUB ACTIVITY
// ------------------------------------------------------------------

class _GitHubActivitySection extends ConsumerWidget {
  const _GitHubActivitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final stats = ref.watch(gitHubStatsProvider(PortfolioConfig.githubUsername));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Expanded(child: _SectionTitle('GitHub Activity')),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => launchUrl(Uri.parse(PortfolioConfig.githubUrl)),
              child: Row(children: [
                Text('@${PortfolioConfig.githubUsername}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textSec, fontSize: 11, fontFamily: 'Inter')),
                const SizedBox(width: 4),
                Icon(LucideIcons.externalLink, size: 11, color: textSec),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        stats.when(
          loading: () => Wrap(
            spacing: 2, runSpacing: 2,
            children: List.generate(48, (i) => Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight)
                    .withValues(alpha: 0.3 + (i % 3) * 0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            )),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text('// error: could not fetch GitHub activity',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textSec, fontFamily: 'Inter', fontSize: 11)),
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContributionGraph(contributions: data.contributions),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${data.totalContributions} contributions in the last year',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: textSec, fontSize: 10.5)),
                  Row(children: [
                    Text('Less',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: textSec, fontSize: 9.5)),
                    const SizedBox(width: 4),
                    for (final c in [
                      AppColors.contrib0Dark,
                      AppColors.contrib2Dark,
                      AppColors.contrib3Dark,
                      AppColors.contrib4Dark,
                      AppColors.contrib5Dark,
                    ])
                      Container(
                        width: 9, height: 9,
                        margin: const EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(
                          color: c, borderRadius: BorderRadius.circular(2)),
                      ),
                    const SizedBox(width: 4),
                    Text('More',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: textSec, fontSize: 9.5)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------
//  SHARED WIDGETS
// ------------------------------------------------------------------

/// Warm gold section title — matches the reference design
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFD4AF37),
              letterSpacing: -0.5,
              fontFamily: 'Inter',
            ));
  }
}

class _HomeDivider extends StatelessWidget {
  const _HomeDivider();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1, thickness: 0.4,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}

class _SmallIconBtn extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.tooltip, required this.onTap});
  @override
  State<_SmallIconBtn> createState() => _SmallIconBtnState();
}

class _SmallIconBtnState extends State<_SmallIconBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final hover = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: _hovered ? hover : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: border, width: 0.7),
            ),
            child: Icon(widget.icon, size: 15, color: textSec),
          ),
        ),
      ),
    );
  }
}

class _ViewAllBtn extends StatefulWidget {
  final String label;
  const _ViewAllBtn({required this.label});
  @override
  State<_ViewAllBtn> createState() => _ViewAllBtnState();
}

class _ViewAllBtnState extends State<_ViewAllBtn> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final hover = isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _hovered ? hover : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _hovered ? border2 : border, width: 0.7),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _hovered ? textPri : textSec,
                    fontSize: 11.5, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          Icon(LucideIcons.chevronRight, size: 13, color: _hovered ? textPri : textSec),
        ]),
      ),
    );
  }
}
