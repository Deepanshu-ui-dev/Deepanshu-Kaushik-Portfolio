import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../../core/widgets/scroll_fade_in.dart';

// ─────────────────────────────────────────────
// HERO SECTION — spring-driven entry
// ─────────────────────────────────────────────

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // Unbounded for spring — prevents clamp eating overshoot
    _ctrl = AnimationController.unbounded(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ctrl.animateWith(SpringSimulation(
        const SpringDescription(mass: 0.6, stiffness: 180, damping: 20),
        0.0, 1.0, 0.0,
      ));
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: Curves.easeOut.transform(t),
          child: child,
        );
      },
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RepaintBoundary(child: _IdentityBlock()),
          SizedBox(height: AppSpacing.xxl),
          RepaintBoundary(child: _AboutBlock()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// IDENTITY BLOCK
// ─────────────────────────────────────────────

class _IdentityBlock extends StatelessWidget {
  const _IdentityBlock();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Version / date badge row ──────────────────────────
        Row(
          children: [
            Text(
              'FIG.01 // IDENTITY',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textSec,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        LayoutBuilder(builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;

          final avatar = Magnet(
            displacement: isMobile ? 0.0 : 0.1,
            child: MonofolioCornersBox(
              padding: const EdgeInsets.all(4),
              child: Container(
                width: isMobile ? double.infinity : 160,
                height: isMobile ? 240 : 200,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
                  border: Border.all(color: border),
                  borderRadius: AppRadius.subtle,
                ),
                child: RepaintBoundary(
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.33, 0.33, 0.33, 0, 0,
                      0.33, 0.33, 0.33, 0, 0,
                      0.33, 0.33, 0.33, 0, 0,
                      0,    0,    0,    1, 0,
                    ]),
                    child: _LazyProfileImage(
                      skeletonColor: isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight,
                      errorIconColor: textSec.withValues(alpha: 0.5),
                      isMobile: isMobile,
                    ),
                  ),
                ),
              ),
            ),
          );

          final detailRows = [
            const _DetailRow(index: '00', label: 'NAME', value: PortfolioConfig.name),
            const _DetailRow(index: '01', label: 'BASED', value: PortfolioConfig.location),
            const _DetailRow(index: '02', label: 'ROLE', value: 'UI/UX & Flutter Dev', isImportant: true),
            const _DetailRow(index: '03', label: 'STATUS', value: 'Open to Work', isStatus: true),
          ];

          Widget details = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < detailRows.length; i++) ...[
                const DashedDivider(),
                ScrollFadeIn(
                  delay: Duration(milliseconds: i * 55),
                  child: detailRows[i],
                ),
              ],
              const DashedDivider(),
            ],
          );

          if (isMobile) {
            return Column(children: [
              avatar,
              const SizedBox(height: AppSpacing.lg),
              details,
            ]);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (constraints.maxWidth * 0.35).clamp(120.0, 160.0),
                child: avatar,
              ),
              const SizedBox(width: AppSpacing.xxl),
              Expanded(child: details),
            ],
          );
        }),
      ],
    );
  }
}


class _DetailRow extends StatelessWidget {
  final String index;
  final String label;
  final String value;
  final bool isStatus;
  final bool isImportant;

  const _DetailRow({
    required this.index,
    required this.label,
    required this.value,
    this.isStatus = false,
    this.isImportant = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = AppSpacing.isMobile(context);
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(index,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textSec)),
          ),
          SizedBox(
            width: isMobile ? 60 : 80,
            child: Text(label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: textSec,
                      letterSpacing: 2.0,
                      fontSize: isMobile ? 10 : 11,
                    )),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isStatus) ...[
                  Container(width: 7, height: 7, color: accent),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13.5,
                      height: 1.65,
                      color: textPri,
                      fontWeight: (isStatus || isImportant ||
                              label == 'NAME' || label == 'BASED')
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LazyProfileImage extends StatefulWidget {
  final Color skeletonColor;
  final Color errorIconColor;
  final bool isMobile;

  const _LazyProfileImage({
    required this.skeletonColor,
    required this.errorIconColor,
    required this.isMobile,
  });

  @override
  State<_LazyProfileImage> createState() => _LazyProfileImageState();
}

class _LazyProfileImageState extends State<_LazyProfileImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _shimmer = Tween<double>(begin: 0.25, end: 0.65)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (!_loaded)
          FadeTransition(
            opacity: _shimmer,
            child: Container(color: widget.skeletonColor),
          ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _loaded ? 1 : 0,
          child: Image.asset(
            'assets/images/profile.png',
            fit: BoxFit.cover,
            width: widget.isMobile ? double.infinity : null,
            cacheWidth: 800,
            frameBuilder: (ctx, child, frame, syncLoaded) {
              if ((syncLoaded || frame != null) && !_loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _loaded = true);
                });
              }
              return child;
            },
            errorBuilder: (_, __, ___) => Center(
              child: Icon(Icons.person_outline,
                  size: 48, color: widget.errorIconColor),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ABOUT BLOCK
// ─────────────────────────────────────────────

class _AboutBlock extends StatelessWidget {
  const _AboutBlock();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final pad = AppSpacing.isMobile(context) ? 16.0 : 24.0;

    return MonofolioCornersBox(
      padding: EdgeInsets.all(pad),
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Headline row ──────────────────────────────────
            if (isMobile) ...[
              const _HeroHeadline(),
              const SizedBox(height: 10),
              const _ResumePulsingButton(),
            ] else
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _HeroHeadline()),
                  SizedBox(width: 16),
                  _ResumePulsingButton(),
                ],
              ),

            const SizedBox(height: 14),

            // ── Bio ───────────────────────────────────────────
            Text(
              'I design interfaces and build them with Flutter. '
              'Bridging pixel-perfect UI/UX design with high-performance mobile engineering. '
              'I turn complex logic into smooth, tactile experiences that feel solid, responsive, and alive.',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13.5,
                color: textSec,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 28),
            const DashedDivider(),
            const SizedBox(height: 22),

            // ── Quick Reach Out ───────────────────────────────
            Row(
              children: [
                Text(
                  'QUICK REACH OUT',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w600,
                    color: textSec,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(height: 0.5, color: border),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const _ReachOutGrid(),
          ],
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// HERO HEADLINE — Outfit ExtraBold with accent badge
// ─────────────────────────────────────────────

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        Text(
          'Building interfaces that feel better ',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: AppSpacing.headlineSize(context,
                mobile: 24, tablet: 26, laptop: 28),
            fontWeight: FontWeight.w800,
            color: textPri,
            height: 1.1,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// REACH OUT GRID — 2×2 premium layout
// ─────────────────────────────────────────────

class _ReachOutGrid extends StatelessWidget {
  const _ReachOutGrid();

  static const _links = [
    _SocialData(
      svgAsset: 'assets/icons/github.svg',
      label: 'GitHub',
      handle: '@Deepanshu-ui-dev',
      sublabel: 'Source Code',
      url: PortfolioConfig.githubUrl,
    ),
    _SocialData(
      svgAsset: 'assets/icons/linkedin.svg',
      label: 'LinkedIn',
      handle: 'imdeepanshukaushik',
      sublabel: 'Professional',
      url: PortfolioConfig.linkedinUrl,
    ),
    _SocialData(
      svgAsset: 'assets/icons/x.svg',
      label: 'X / Twitter',
      handle: '@Deepanshu25u',
      sublabel: 'Micro thoughts',
      url: PortfolioConfig.twitterUrl,
    ),
    _SocialData(
      icon: Icons.mail_outline_rounded,
      label: 'Email',
      handle: 'imdeepanshu4work',
      sublabel: 'Direct line',
      url: 'mailto:${PortfolioConfig.email}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 380;
      if (isWide) {
        // 2×2 grid
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: ScrollFadeIn(
                  delay: const Duration(milliseconds: 80),
                  child: _ReachOutCard(data: _links[0]),
                )),
                const SizedBox(width: 8),
                Expanded(child: ScrollFadeIn(
                  delay: const Duration(milliseconds: 135),
                  child: _ReachOutCard(data: _links[1]),
                )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: ScrollFadeIn(
                  delay: const Duration(milliseconds: 190),
                  child: _ReachOutCard(data: _links[2]),
                )),
                const SizedBox(width: 8),
                Expanded(child: ScrollFadeIn(
                  delay: const Duration(milliseconds: 245),
                  child: _ReachOutCard(data: _links[3]),
                )),
              ],
            ),
          ],
        );
      }
      // Narrow: single column
      return Column(
        children: [
          for (int i = 0; i < _links.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            ScrollFadeIn(
              delay: Duration(milliseconds: 80 + i * 55),
              child: _ReachOutCard(data: _links[i]),
            ),
          ],
        ],
      );
    });
  }
}

class _SocialData {
  final String? svgAsset;
  final IconData? icon;
  final String label;
  final String handle;
  final String sublabel;
  final String url;

  const _SocialData({
    this.svgAsset,
    this.icon,
    required this.label,
    required this.handle,
    required this.sublabel,
    required this.url,
  });
}

class _ReachOutCard extends StatefulWidget {
  final _SocialData data;

  const _ReachOutCard({required this.data});

  @override
  State<_ReachOutCard> createState() => _ReachOutCardState();
}

class _ReachOutCardState extends State<_ReachOutCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _springCtrl;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _springCtrl = AnimationController.unbounded(vsync: this)..value = 0.0;
  }

  @override
  void dispose() {
    _springCtrl.dispose();
    super.dispose();
  }

  void _onHover(bool hovered) {
    setState(() => _hovered = hovered);
    _springCtrl.animateWith(SpringSimulation(
      SpringDescription(
        mass: 0.3,
        stiffness: hovered ? 300 : 500,
        damping: hovered ? 14 : 22,
      ),
      _springCtrl.value,
      hovered ? 1.0 : 0.0,
      0.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;
    final surfHov = isDark ? AppColors.surfaceHoverDark : AppColors.surfaceHoverLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.data.url),
            mode: LaunchMode.externalApplication),
        child: AnimatedBuilder(
          animation: _springCtrl,
          builder: (context, child) {
            final t = _springCtrl.value.clamp(0.0, 1.0);
            final liftY = -3.0 * t;
            return Transform.translate(
              offset: Offset(0, liftY),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _hovered ? surfHov : surface,
              border: Border(
                left: BorderSide(
                  color: _hovered ? accent : border,
                  width: _hovered ? 2.0 : 0.5,
                ),
                top: BorderSide(color: _hovered ? border2 : border, width: 0.5),
                right: BorderSide(color: _hovered ? border2 : border, width: 0.5),
                bottom: BorderSide(color: _hovered ? border2 : border, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? accent.withValues(alpha: isDark ? 0.15 : 0.1)
                        : (isDark ? AppColors.surfaceElevDark : AppColors.surfaceElevLight),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: widget.data.svgAsset != null
                        ? SvgPicture.asset(
                            widget.data.svgAsset!,
                            width: 14,
                            height: 14,
                            colorFilter: ColorFilter.mode(
                              _hovered ? accent : textSec,
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(widget.data.icon,
                            size: 14, color: _hovered ? accent : textSec),
                  ),
                ),
                const SizedBox(width: 10),

                // Label + handle + sublabel
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 160),
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _hovered ? textPri : textSec,
                          letterSpacing: -0.1,
                        ),
                        child: Text(widget.data.label),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            widget.data.handle,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: _hovered ? accent : textSec,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '//',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 9,
                              color: textTer.withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              widget.data.sublabel,
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 8,
                                color: textTer,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow — fades in on hover
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  opacity: _hovered ? 1.0 : 0.0,
                  child: Icon(Icons.arrow_outward_rounded,
                      size: 12, color: accent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESUME PULSING BUTTON
// ─────────────────────────────────────────────

class _ResumePulsingButton extends StatefulWidget {
  const _ResumePulsingButton();

  @override
  State<_ResumePulsingButton> createState() => _ResumePulsingButtonState();
}

class _ResumePulsingButtonState extends State<_ResumePulsingButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.55, end: 1.25)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final border2 = isDark ? AppColors.border2Dark : AppColors.border2Light;
    final surfHov = isDark ? AppColors.surfaceHoverDark : AppColors.surfaceHoverLight;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(PortfolioConfig.resumeUrl),
            mode: LaunchMode.externalApplication),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? surfHov : Colors.transparent,
            border: Border.all(color: _hovered ? border2 : border, width: 0.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'RESUME',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w600,
                  color: textPri,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}