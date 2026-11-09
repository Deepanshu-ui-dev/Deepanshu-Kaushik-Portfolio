import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_music_player.dart';
import 'ed_primitives.dart';
import 'ed_projects.dart';
import 'ed_theme.dart';

void openAboutPage(BuildContext context) {
  Navigator.of(context).push(edRoute(const AboutPage()));
}

void openSkillsPage(BuildContext context) {
  Navigator.of(context).push(edRoute(const SkillsPage()));
}

void openContactPage(BuildContext context) {
  Navigator.of(context).push(edRoute(const ContactPage()));
}

// ════════════════════════════════════════════════════════════════════
//  ABOUT PAGE
// ════════════════════════════════════════════════════════════════════

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 600;

    return EdSubScaffold(
      trail: '/ about',
      activeIndex: 1,
      builder: (context, scroll) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero — same look as the home hero
          PageHeroBand(
            title: 'About',
            badge: '[ ${PortfolioConfig.name.toUpperCase()} ]',
            description:
                '${PortfolioConfig.headline} crafting tactile cross-platform products, distributed backends, and multi-agent AI systems.',
            highlights: [
              (label: '✦ Available for SWE roles', color: ed.live),
              (label: '📍 ${PortfolioConfig.location}', color: ed.ink2),
              (label: '🎓 ${PortfolioConfig.degree} @ ABESEC', color: ed.ink2),
            ],
            onBack: () => goHome(context),
            extra: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PillButton('Download Résumé',
                      icon: LucideIcons.download,
                      filled: true,
                      onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                  PillButton('GitHub',
                      icon: LucideIcons.arrowUpRight,
                      onTap: () => openUrl(PortfolioConfig.githubUrl)),
                  PillButton('LinkedIn',
                      icon: LucideIcons.arrowUpRight,
                      onTap: () => openUrl(PortfolioConfig.linkedinUrl)),
                  PillButton('Email',
                      icon: LucideIcons.mail,
                      onTap: () => openUrl('mailto:${PortfolioConfig.email}')),
                ],
              ),
            ),
          ),

          // ── 01. The Person ──────────────────────────────────────────
          const SectionBand('the person'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 28, edPad(context), 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline narrative
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 3.5,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ed.ink,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'No corporate jargon. Just a quiet corner of the internet where I ship tactile software, track life goals, and solve hard problems.',
                        style: ed.sans(narrow ? 14.5 : 16.5,
                            color: ed.ink, w: FontWeight.w600, h: 1.45),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  PortfolioConfig.bio,
                  style: ed.sans(13.5, color: ed.ink2, h: 1.65),
                ),
                const SizedBox(height: 18),
                for (int i = 0; i < PortfolioConfig.aboutBullets.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5, right: 10),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ed.ink2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            PortfolioConfig.aboutBullets[i],
                            style: ed.sans(13, color: ed.ink2, h: 1.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 22),

                // Stat strip — synced to PortfolioConfig.stats
                Container(
                  decoration: BoxDecoration(
                    color: ed.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ed.line),
                  ),
                  child: LayoutBuilder(builder: (context, c) {
                    final is2Col = c.maxWidth < 600;
                    final items = [
                      for (final s in PortfolioConfig.stats)
                        ('${s.value ?? ''}${s.suffix}', s.label),
                    ];
                    final w = is2Col ? c.maxWidth / 2 : c.maxWidth / items.length;
                    return Wrap(
                      children: [
                        for (int i = 0; i < items.length; i++)
                          Container(
                            width: w,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border(
                                right: (!is2Col && i < items.length - 1) || (is2Col && i % 2 == 0)
                                    ? BorderSide(color: ed.line)
                                    : BorderSide.none,
                                bottom: is2Col && i < 2
                                    ? BorderSide(color: ed.line)
                                    : BorderSide.none,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(items[i].$1,
                                    style: ed.serif(22)),
                                const SizedBox(height: 3),
                                Text(items[i].$2,
                                    style: ed.mono(10, color: ed.ink3)),
                              ],
                            ),
                          ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 22),

                // Education block — synced to PortfolioConfig college and degree
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: ed.raised.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ed.line),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ed.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ed.line2),
                        ),
                        child: Icon(LucideIcons.graduationCap,
                            size: 20, color: ed.ink),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              PortfolioConfig.college,
                              style: ed.sans(14,
                                  color: ed.ink, w: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${PortfolioConfig.degree} • ${PortfolioConfig.eduPeriod}',
                              style: ed.mono(10.5, color: ed.ink2),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Coursework: Data Structures & Algorithms, Distributed Systems, DBMS, Machine Learning',
                              style: ed.sans(11.5, color: ed.ink3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── 02. Audio Player ────────────────────────────────────────
          const SectionBand('audio rotation'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 24),
            child: const EdMusicPlayer(),
          ),

          // ── 03. Bucket List ─────────────────────────────────────────
          SectionBand('bucket list',
              trailing: const MonoTag('8 GOALS')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Things I want to build, ship, and experience across my lifetime.',
                  style: ed.sans(13, color: ed.ink2),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(builder: (context, c) {
                  final twoCol = c.maxWidth >= 620;
                  final w = twoCol ? (c.maxWidth - 12) / 2 : c.maxWidth;
                  const goals = [
                    (
                      title: 'Build and deploy 10+ production applications',
                      status: 'Achieved',
                      done: true,
                      tag: 'Engineering'
                    ),
                    (
                      title: 'Co-organize Google Developer Groups & lead tech workshops',
                      status: 'Active',
                      done: true,
                      tag: 'Community'
                    ),
                    (
                      title: 'Solve 350+ algorithmic challenges on LeetCode',
                      status: 'Achieved',
                      done: true,
                      tag: 'DSA'
                    ),
                    (
                      title: 'Ship an open-source tool with 1,000+ GitHub stars',
                      status: 'In Progress',
                      done: false,
                      tag: 'Open Source'
                    ),
                    (
                      title: 'Architect a high-throughput distributed microservice',
                      status: 'In Progress',
                      done: false,
                      tag: 'Systems'
                    ),
                    (
                      title: 'Work at a world-class team building consumer software',
                      status: 'Target',
                      done: false,
                      tag: 'Career'
                    ),
                    (
                      title: 'Travel to Japan and photograph Kyoto architecture',
                      status: 'Planned',
                      done: false,
                      tag: 'Life'
                    ),
                    (
                      title: 'Build a custom physical mechanical macro pad from scratch',
                      status: 'Planned',
                      done: false,
                      tag: 'Hardware'
                    ),
                  ];
                  return Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      for (final g in goals)
                        SizedBox(
                          width: w,
                          child: Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: g.done
                                  ? ed.raised.withValues(alpha: 0.25)
                                  : ed.card,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: g.done
                                      ? ed.line2.withValues(alpha: 0.4)
                                      : ed.line),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  margin: const EdgeInsets.only(top: 1),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: g.done
                                        ? ed.live.withValues(alpha: 0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: g.done ? ed.live : ed.line2),
                                  ),
                                  child: g.done
                                      ? Icon(LucideIcons.check,
                                          size: 11, color: ed.live)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        g.title,
                                        style: ed.sans(12.5,
                                            color: g.done ? ed.ink3 : ed.ink,
                                            w: FontWeight.w500).copyWith(
                                                decoration: g.done
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(g.status.toUpperCase(),
                                              style: ed.mono(9,
                                                  color: g.done
                                                      ? ed.live
                                                      : ed.ink3)),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 3,
                                            height: 3,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ed.ink3),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(g.tag,
                                              style: ed.mono(9,
                                                  color: ed.ink3)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // ── 04. Community & Leadership ──────────────────────────────
          const SectionBand('community'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Communities I have helped build, organize, and grow in.',
                  style: ed.sans(13, color: ed.ink2),
                ),
                const SizedBox(height: 18),
                LayoutBuilder(builder: (context, c) {
                  final twoCol = c.maxWidth >= 600;
                  final w = twoCol ? (c.maxWidth - 14) / 2 : c.maxWidth;
                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      // GDG Card
                      SizedBox(
                        width: w,
                        child: const _MomentCard(
                          title: 'Google Developer Group',
                          role: 'Co-Organizer',
                          period: '2025 – Present',
                          tagline: 'From curious attendee to co-organizer.',
                          imageAsset: 'assets/images/gdg1.jpeg',
                          stats: [('500+', 'Attendees'), ('6', 'Events')],
                          description:
                              'Organizing technical meetups, Flutter hack nights, and mentorship sessions for the local engineering community.',
                        ),
                      ),
                      // CodeChef Card
                      SizedBox(
                        width: w,
                        child: const _MomentCard(
                          title: 'CodeChef ABESEC Chapter',
                          role: 'Graphics & Creative Lead',
                          period: '2024 – Present',
                          tagline: 'Shaping visual identity and CP culture.',
                          imageAsset: 'assets/images/gdg2.jpeg',
                          stats: [('750+', 'Learners'), ('2018', 'Founded')],
                          description:
                              'Leading brand identity, event posters, and design systems for competitive programming contests like Clash of Coders.',
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // ── 05. Writing & Notes ─────────────────────────────────────
          const SectionBand('essays & notes'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ThoughtItem(
                  tag: 'ARCHITECTURE',
                  title: 'Building Tactile Flutter Interfaces: Beyond Material Defaults',
                  excerpt:
                      'Why mechanical clicks, hairline boundaries, and intentional hover states make software feel like a precision instrument instead of an abstract screen.',
                  date: 'Nov 2024 • 5 min read',
                ),
                Container(height: 1, color: ed.line, margin: const EdgeInsets.symmetric(vertical: 14)),
                const _ThoughtItem(
                  tag: 'STATE MANAGEMENT',
                  title: 'Why State Management Is Really About Data Flow Consistency',
                  excerpt:
                      'A practical walkthrough on choosing between Riverpod, Provider, and reactive streams based on data volatility and caching tiers.',
                  date: 'Sep 2024 • 7 min read',
                ),
                Container(height: 1, color: ed.line, margin: const EdgeInsets.symmetric(vertical: 14)),
                const _ThoughtItem(
                  tag: 'ENGINEERING',
                  title: 'From LeetCode Patterns to High-Throughput Production Services',
                  excerpt:
                      'How algorithmic thinking directly translates into writing resilient queries, cache eviction policies, and clean concurrency patterns.',
                  date: 'Jun 2024 • 4 min read',
                ),
              ],
            ),
          ),

          // ── 06. Connect & Socials ───────────────────────────────────
          const SectionBand('connect'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Want to build something together?',
                          style: ed.sans(14, color: ed.ink, w: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Always open to software engineering opportunities, hackathons, and collaborations.',
                          style: ed.mono(11, color: ed.ink3)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                PillButton('Say Hello',
                    icon: LucideIcons.send,
                    filled: true,
                    onTap: () => openContactPage(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MomentCard extends StatelessWidget {
  final String title;
  final String role;
  final String period;
  final String tagline;
  final String imageAsset;
  final String description;
  final List<(String, String)> stats;

  const _MomentCard({
    required this.title,
    required this.role,
    required this.period,
    required this.tagline,
    required this.imageAsset,
    required this.description,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Container(
      decoration: BoxDecoration(
        color: ed.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ed.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Photo banner with colorful full-fidelity image
          SizedBox(
            height: 170,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: ed.raised,
                alignment: Alignment.center,
                child: Icon(LucideIcons.image, color: ed.ink3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: ed.raised,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(role.toUpperCase(),
                          style: ed.mono(9.5, color: ed.ink, w: FontWeight.w600)),
                    ),
                    Text(period, style: ed.mono(9.5, color: ed.ink3)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(title, style: ed.serif(20)),
                const SizedBox(height: 2),
                Text(tagline, style: ed.mono(10.5, color: ed.ink2)),
                const SizedBox(height: 8),
                Text(description,
                    style: ed.sans(12.5, color: ed.ink2, h: 1.5)),
                const SizedBox(height: 14),
                // Mini stats
                Row(
                  children: [
                    for (int i = 0; i < stats.length; i++) ...[
                      if (i > 0) const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(stats[i].$1,
                              style: ed.mono(14,
                                  color: ed.ink, w: FontWeight.bold)),
                          Text(stats[i].$2,
                              style: ed.mono(9, color: ed.ink3)),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThoughtItem extends StatelessWidget {
  final String tag;
  final String title;
  final String excerpt;
  final String date;

  const _ThoughtItem({
    required this.tag,
    required this.title,
    required this.excerpt,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MonoTag(tag),
                const SizedBox(width: 10),
                Text(date, style: ed.mono(10, color: ed.ink3)),
              ],
            ),
            const SizedBox(height: 9),
            Text(title,
                style: ed.serif(h ? 19 : 18, italic: h, color: ed.ink)),
            const SizedBox(height: 6),
            Text(excerpt, style: ed.sans(13, color: ed.ink2, h: 1.55)),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  SKILLS PAGE — Categorized breakdown with live proficiency & tags
// ════════════════════════════════════════════════════════════════════

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);

    return EdSubScaffold(
      trail: '/ skills',
      activeIndex: 3,
      builder: (context, scroll) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero — same look as the home hero
          PageHeroBand(
            title: 'Skills & Stack',
            badge: '[ 20+ TECHNOLOGIES ]',
            description:
                'Comprehensive catalog of programming languages, frontend frameworks, UI design systems, distributed backend engines, databases, and DevOps tooling.',
            highlights: [
              (label: '⚡ Flutter & Dart Specialist', color: ed.live),
              (label: '🎨 Design Systems & Figma', color: ed.ink2),
              (label: '⚙️ Distributed Backend & AI', color: ed.ink2),
            ],
            onBack: () => goHome(context),
          ),

          // ── 01. Design & UI/UX ──────────────────────────────────────
          SectionBand('design & ui/ux',
              trailing: const MonoTag('6 TOOLS')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 28),
            child: const _SkillGrid(
              skills: [
                (
                  name: 'Figma',
                  icon: 'figma',
                  hex: 'F24E1E',
                  level: '0.95',
                  note: 'Design systems, auto-layout, interactive prototypes'
                ),
                (
                  name: 'Framer',
                  icon: 'framer',
                  hex: '0055FF',
                  level: '0.82',
                  note: 'Micro-animations, responsive web landing pages'
                ),
                (
                  name: 'Sketch',
                  icon: 'sketch',
                  hex: 'F7B500',
                  level: '0.70',
                  note: 'Vector UI assets and layout compositions'
                ),
                (
                  name: 'Adobe XD',
                  icon: 'adobexd',
                  hex: 'FF61F6',
                  level: '0.75',
                  note: 'Wireframing and component flows'
                ),
                (
                  name: 'Photoshop',
                  icon: 'adobephotoshop',
                  hex: '31A8FF',
                  level: '0.65',
                  note: 'Asset manipulation, textures, banners'
                ),
                (
                  name: 'Canva',
                  icon: 'canva',
                  hex: '00C4CC',
                  level: '0.80',
                  note: 'Social collateral, pitch decks, quick graphics'
                ),
              ],
            ),
          ),

          // ── 02. Languages ───────────────────────────────────────────
          SectionBand('core languages',
              trailing: const MonoTag('6 LANGUAGES')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 28),
            child: const _SkillGrid(
              skills: [
                (
                  name: 'Dart',
                  icon: 'dart',
                  hex: '0175C2',
                  level: '0.92',
                  note: 'Primary engineering language, async streams, isolates'
                ),
                (
                  name: 'C++',
                  icon: 'cplusplus',
                  hex: '00599C',
                  level: '0.78',
                  note: 'Data structures, algorithmic problem solving on LeetCode'
                ),
                (
                  name: 'C',
                  icon: 'c',
                  hex: 'A8B9CC',
                  level: '0.72',
                  note: 'Systems programming fundamentals, memory pointers'
                ),
                (
                  name: 'HTML5',
                  icon: 'html5',
                  hex: 'E34F26',
                  level: '0.88',
                  note: 'Semantic structure, accessibility, web standards'
                ),
                (
                  name: 'CSS3',
                  icon: 'css3',
                  hex: '1572B6',
                  level: '0.85',
                  note: 'Flexbox, CSS Grid, media queries, keyframe animations'
                ),
                (
                  name: 'JavaScript',
                  icon: 'javascript',
                  hex: 'F7DF1E',
                  level: '0.75',
                  note: 'ES6+, DOM APIs, async event loop runtimes'
                ),
              ],
            ),
          ),

          // ── 03. Frameworks & Architecture ───────────────────────────
          SectionBand('frameworks & state',
              trailing: const MonoTag('4 FRAMEWORKS')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 28),
            child: const _SkillGrid(
              skills: [
                (
                  name: 'Flutter',
                  icon: 'flutter',
                  hex: '02569B',
                  level: '0.93',
                  note: 'Multi-platform mobile, desktop, and web applications'
                ),
                (
                  name: 'Riverpod',
                  icon: 'dart',
                  hex: '5B63FE',
                  level: '0.88',
                  note: 'Compile-safe dependency injection & reactive caching'
                ),
                (
                  name: 'Provider',
                  icon: 'dart',
                  hex: '0175C2',
                  level: '0.80',
                  note: 'InheritedWidget wrapper for reactive state propagation'
                ),
                (
                  name: 'Tailwind CSS',
                  icon: 'tailwindcss',
                  hex: '06B6D4',
                  level: '0.78',
                  note: 'Utility-first styling for fast, modern web interfaces'
                ),
              ],
            ),
          ),

          // ── 04. Databases & Cloud Backend ───────────────────────────
          SectionBand('cloud & backend',
              trailing: const MonoTag('7 PLATFORMS')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 28),
            child: const _SkillGrid(
              skills: [
                (
                  name: 'Node.js',
                  icon: 'nodedotjs',
                  hex: '5FA04E',
                  level: '0.82',
                  note: 'RESTful API servers, async background workers'
                ),
                (
                  name: 'Express',
                  icon: 'express',
                  hex: '808080',
                  level: '0.78',
                  note: 'Lightweight routing, middlewares, microservices'
                ),
                (
                  name: 'Supabase',
                  icon: 'supabase',
                  hex: '3ECF8E',
                  level: '0.85',
                  note: 'PostgreSQL, Row Level Security, Auth & Realtime'
                ),
                (
                  name: 'Firebase',
                  icon: 'firebase',
                  hex: 'FFCA28',
                  level: '0.75',
                  note: 'Cloud Firestore, Auth, Analytics, Remote Config'
                ),
                (
                  name: 'MySQL',
                  icon: 'mysql',
                  hex: '4479A1',
                  level: '0.70',
                  note: 'Relational database schema modeling, queries, indexes'
                ),
                (
                  name: 'GCP',
                  icon: 'googlecloud',
                  hex: '4285F4',
                  level: '0.60',
                  note: 'Cloud Run, IAM, Cloud Storage, serverless functions'
                ),
                (
                  name: 'AWS',
                  icon: 'amazonaws',
                  hex: 'FF9900',
                  level: '0.58',
                  note: 'S3 static buckets, basic EC2 provisioning'
                ),
              ],
            ),
          ),

          // ── 05. DevOps & Tools ──────────────────────────────────────
          SectionBand('developer tooling',
              trailing: const MonoTag('4 TOOLS')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 32),
            child: const _SkillGrid(
              skills: [
                (
                  name: 'Git & GitHub',
                  icon: 'git',
                  hex: 'F05032',
                  level: '0.90',
                  note: 'Branching strategies, CI/CD actions, PR workflows'
                ),
                (
                  name: 'Docker',
                  icon: 'docker',
                  hex: '2496ED',
                  level: '0.72',
                  note: 'Multi-stage container builds, compose environments'
                ),
                (
                  name: 'Postman',
                  icon: 'postman',
                  hex: 'FF6C37',
                  level: '0.85',
                  note: 'API mocking, environment testing, collection runs'
                ),
                (
                  name: 'Linux / Bash',
                  icon: 'linux',
                  hex: 'FCC624',
                  level: '0.78',
                  note: 'Terminal navigation, shell automation, SSH deployment'
                ),
              ],
            ),
          ),

          // ── 05. Open Source Experiments ─────────────────────────────
          const SectionBand('source code'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Looking for open-source implementations?',
                          style: ed.sans(14, color: ed.ink, w: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Explore repositories, algorithmic solutions, and production Flutter architectures on GitHub.',
                          style: ed.mono(11, color: ed.ink3)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                PillButton('GitHub Repos',
                    icon: LucideIcons.arrowUpRight,
                    filled: true,
                    onTap: () => openUrl(PortfolioConfig.githubUrl)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillGrid extends StatelessWidget {
  final List<({String name, String icon, String hex, String level, String note})> skills;
  const _SkillGrid({required this.skills});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 720 ? 3 : (c.maxWidth >= 480 ? 2 : 1);
      const spacing = 12.0;
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final s in skills)
            SizedBox(
              width: w,
              child: _SkillDetailCard(s: s),
            ),
        ],
      );
    });
  }
}

class _SkillDetailCard extends StatefulWidget {
  final ({String name, String icon, String hex, String level, String note}) s;
  const _SkillDetailCard({required this.s});

  @override
  State<_SkillDetailCard> createState() => _SkillDetailCardState();
}

class _SkillDetailCardState extends State<_SkillDetailCard> {
  bool _hovered = false;

  Color _parseHex(String h) {
    try {
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final brandColor = _parseHex(widget.s.hex);
    final proficiency = double.tryParse(widget.s.level) ?? 0.8;
    final percent = (proficiency * 100).round();
    final svgUrl =
        'https://api.iconify.design/simple-icons/${widget.s.icon}.svg?color=%23${widget.s.hex}';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _hovered ? ed.card : ed.raised.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered ? ed.line2 : ed.line,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon box with brand color
                Container(
                  width: 32,
                  height: 32,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ed.card,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: ed.line),
                  ),
                  child: SvgPicture.network(
                    svgUrl,
                    placeholderBuilder: (_) => Icon(LucideIcons.code,
                        size: 14, color: brandColor),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.s.name,
                          style: ed.sans(13.5,
                              color: ed.ink, w: FontWeight.w600)),
                      Text('$percent% Mastery',
                          style: ed.mono(9.5, color: ed.ink3)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Proficiency bar
            Container(
              height: 3.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ed.line,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: proficiency,
                child: Container(
                  decoration: BoxDecoration(
                    color: _hovered ? brandColor : ed.ink2,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.s.note,
                style: ed.sans(11.5, color: ed.ink2, h: 1.45),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  CONTACT PAGE — Direct channels, message form & working preferences
// ════════════════════════════════════════════════════════════════════

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _subjectCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_emailCtrl.text.trim().isEmpty || _msgCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please provide an email and message.'),
        backgroundColor: Ed.of(context).ink,
      ));
      return;
    }
    setState(() => _sending = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
      });
      _nameCtrl.clear();
      _emailCtrl.clear();
      _subjectCtrl.clear();
      _msgCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);

    return EdSubScaffold(
      trail: '/ contact',
      activeIndex: 4,
      builder: (context, scroll) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero — same look as the home hero
          PageHeroBand(
            title: 'Get In Touch',
            badge: '[ SAY HELLO ]',
            description:
                'Interested in discussing a software engineering role, project collaboration, or exchanging ideas on Flutter and multi-agent AI? Let’s connect.',
            highlights: [
              (label: '✉️ ${PortfolioConfig.email}', color: ed.live),
              (label: '⚡ Reply time: < 24 hours', color: ed.ink2),
              (label: '📍 Timezone: IST (UTC +5:30)', color: ed.ink2),
            ],
            onBack: () => goHome(context),
          ),

          // ── 01. Direct Message Composer ─────────────────────────────
          const SectionBand('send a message'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 28, edPad(context), 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_sent) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ed.live.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ed.live),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.checkCircle2, color: ed.live, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Thank you! Your message was received. I will reply to you within 24 hours.',
                            style: ed.sans(13, color: ed.ink, w: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Text(
                  'Fill out the form below to reach my personal inbox directly.',
                  style: ed.sans(13, color: ed.ink2),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(builder: (context, c) {
                  final twoCol = c.maxWidth >= 540;
                  return Column(
                    children: [
                      if (twoCol)
                        Row(
                          children: [
                            Expanded(child: _field('Your Name', _nameCtrl, 'e.g. Alex River')),
                            const SizedBox(width: 14),
                            Expanded(child: _field('Email Address', _emailCtrl, 'e.g. alex@company.com')),
                          ],
                        )
                      else ...[
                        _field('Your Name', _nameCtrl, 'e.g. Alex River'),
                        const SizedBox(height: 14),
                        _field('Email Address', _emailCtrl, 'e.g. alex@company.com'),
                      ],
                      const SizedBox(height: 14),
                      _field('Subject / Role', _subjectCtrl, 'e.g. Flutter Engineer Role / Project Inquiry'),
                      const SizedBox(height: 14),
                      _field('Message Body', _msgCtrl, 'Tell me about the project, role, or ideas...', maxLines: 4),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    PillButton(
                      _sending ? 'Sending...' : 'Send Message',
                      icon: LucideIcons.send,
                      filled: true,
                      onTap: _sending ? null : _send,
                    ),
                    const SizedBox(width: 12),
                    PillButton(
                      'Copy Email Address',
                      icon: LucideIcons.copy,
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: PortfolioConfig.email));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Email copied to clipboard: ${PortfolioConfig.email}'),
                          behavior: SnackBarBehavior.floating,
                          width: 320,
                          backgroundColor: ed.ink,
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── 02. Direct Channels & Networks ──────────────────────────
          SectionBand('direct channels',
              trailing: const MonoTag('5 NETWORKS')),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.zero,
            child: LayoutBuilder(builder: (context, c) {
              final perRow = c.maxWidth >= 600 ? 5 : (c.maxWidth >= 380 ? 3 : 2);
              final w = c.maxWidth / perRow;
              final channels = [
                (
                  label: 'GitHub',
                  handle: PortfolioConfig.githubUsername,
                  url: PortfolioConfig.githubUrl,
                  icon: 'assets/icons/tech/github.svg',
                ),
                (
                  label: 'LinkedIn',
                  handle: 'imdeepanshukaushik',
                  url: PortfolioConfig.linkedinUrl,
                  icon: 'assets/icons/tech/linkedin.svg',
                ),
                (
                  label: 'Twitter / X',
                  handle: '@Deepanshu25u',
                  url: PortfolioConfig.twitterUrl,
                  icon: 'assets/icons/tech/x.svg',
                ),
                (
                  label: 'Email',
                  handle: PortfolioConfig.email,
                  url: 'mailto:${PortfolioConfig.email}',
                  icon: null,
                ),
                (
                  label: 'Framer',
                  handle: PortfolioConfig.framerHandle,
                  url: PortfolioConfig.websiteUrl,
                  icon: 'assets/icons/tech/framer.svg',
                ),
              ];
              return Wrap(
                children: [
                  for (int i = 0; i < channels.length; i++)
                    Container(
                      width: w,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                      decoration: BoxDecoration(
                        border: Border(
                          right: (i + 1) % perRow != 0
                              ? BorderSide(color: ed.line)
                              : BorderSide.none,
                          bottom: i < channels.length - (channels.length % perRow == 0 ? perRow : channels.length % perRow)
                              ? BorderSide(color: ed.line)
                              : BorderSide.none,
                        ),
                      ),
                      child: Hover(
                        onTap: () => openUrl(channels[i].url),
                        semanticLabel: channels[i].label,
                        builder: (_, h) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(channels[i].label.toUpperCase(),
                                    style: ed.mono(9.5, color: ed.ink3)),
                                Icon(LucideIcons.arrowUpRight,
                                    size: 13, color: h ? ed.ink : ed.ink3),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              channels[i].handle,
                              style: ed.sans(12.5,
                                  color: h ? ed.ink : ed.ink2,
                                  w: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),

          // ── 03. Availability & Working Preferences ──────────────────
          const SectionBand('availability'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 32),
            child: LayoutBuilder(builder: (context, c) {
              final cols = c.maxWidth >= 600 ? 3 : 1;
              final w = (c.maxWidth - 12 * (cols - 1)) / cols;
              final prefs = [
                (
                  icon: LucideIcons.mapPin,
                  title: 'Location & Relocation',
                  desc: 'Based in Greater Noida / Delhi NCR, India. Open to in-person, hybrid, or remote roles worldwide.',
                ),
                (
                  icon: LucideIcons.briefcase,
                  title: 'Collaboration Formats',
                  desc: 'Full-time Software Engineer (Flutter/Backend), contract assignments, and design system consulting.',
                ),
                (
                  icon: LucideIcons.clock,
                  title: 'Response Commitment',
                  desc: 'Replies typically dispatched within 24 hours. Connect on LinkedIn for instant real-time chats.',
                ),
              ];
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final p in prefs)
                    SizedBox(
                      width: w,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ed.raised.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: ed.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(p.icon, size: 18, color: ed.ink),
                            const SizedBox(height: 10),
                            Text(p.title,
                                style: ed.sans(13.5,
                                    color: ed.ink, w: FontWeight.w600)),
                            const SizedBox(height: 5),
                            Text(p.desc,
                                style: ed.sans(12, color: ed.ink2, h: 1.5)),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),

          // ── 04. Direct Links & Resume ───────────────────────────────
          const SectionBand('links & resume'),
          ColumnBox(
            reveal: true,
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 30),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prefer reading credentials directly?',
                          style: ed.sans(14, color: ed.ink, w: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Download my updated résumé or check out open-source repositories on GitHub.',
                          style: ed.mono(11, color: ed.ink3)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    PillButton('Download Résumé',
                        icon: LucideIcons.download,
                        filled: true,
                        onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                    PillButton('GitHub',
                        icon: LucideIcons.arrowUpRight,
                        onTap: () => openUrl(PortfolioConfig.githubUrl)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, {int maxLines = 1}) {
    final ed = Ed.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: ed.mono(10.5, color: ed.ink2)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: ed.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ed.line),
          ),
          child: TextField(
            controller: ctrl,
            maxLines: maxLines,
            cursorColor: ed.ink,
            style: ed.sans(13, color: ed.ink),
            decoration: InputDecoration(
              isDense: true,
              filled: false,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: ed.sans(12.5, color: ed.ink3),
            ),
          ),
        ),
      ],
    );
  }
}
