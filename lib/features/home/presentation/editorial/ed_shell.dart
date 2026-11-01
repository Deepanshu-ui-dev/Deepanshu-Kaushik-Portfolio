import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/smooth_scroll.dart';
import '../../../photography/presentation/screens/gallery_screen.dart';
import 'ed_command_palette.dart';
import 'ed_hero.dart';
import 'ed_nav.dart';
import 'ed_pages.dart';
import 'ed_primitives.dart';
import 'ed_projects.dart';
import 'ed_sections.dart';
import 'ed_theme.dart';

export 'ed_nav.dart' show EdSection;

/// The single-page editorial portfolio.
class EditorialShell extends ConsumerStatefulWidget {
  const EditorialShell({super.key});
  @override
  ConsumerState<EditorialShell> createState() => _EditorialShellState();
}

class _EditorialShellState extends ConsumerState<EditorialShell> {
  final _scroll = ScrollController();
  final _focus = FocusNode(debugLabel: 'shell');
  final _keys = {for (final s in EdSection.values) s: GlobalKey(debugLabel: s.name)};
  final _avatarKey = GlobalKey(debugLabel: 'hero-avatar');
  final _avatarVisible = ValueNotifier(false);
  final _progress = ValueNotifier<double>(0);
  final _floating = ValueNotifier(false);
  final _active = ValueNotifier<EdSection?>(null);
  final _navIndex = ValueNotifier(0);


  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _active.addListener(() => _navIndex.value = _indexFor(_active.value));
    edSectionRequest.addListener(_onSectionRequest);
    edTopRequest.addListener(_onTopRequest);

    // Deep links: ?page=projects, ?project=<name>
    _avatarVisible.value = true;
    final q = Uri.base.queryParameters;
    final project = q['project'];
    final match = project == null
        ? null
        : PortfolioConfig.projects.where((p) => p.name.toLowerCase() == project.toLowerCase()).firstOrNull;
    if (q['page'] == 'projects' || match != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (match != null) {
          openProject(context, match, 'link');
        } else if (q['page'] == 'projects') {
          openProjectsPage(context);
        }
      });
    }
  }

  static int _indexFor(EdSection? s) => switch (s) {
        null || EdSection.about => 0,
        EdSection.work => 2,
        EdSection.skills => 3,
        EdSection.contact => 4,
        _ => 0,
      };

  void _onSectionRequest() {
    final s = edSectionRequest.value;
    if (s == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _goTo(s));
  }

  void _onTopRequest() => WidgetsBinding.instance.addPostFrameCallback((_) => _toTop());

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    _progress.value = pos.maxScrollExtent <= 0 ? 0 : (pos.pixels / pos.maxScrollExtent).clamp(0, 1);
    _floating.value = pos.pixels > 24;

    // Scroll-spy: the last section whose band has passed the reading line.
    final line = Ed.headerH + MediaQuery.sizeOf(context).height * 0.3;
    EdSection? current;
    for (final s in EdSection.values) {
      final box = _keys[s]!.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= line) current = s;
    }
    if (pos.pixels >= pos.maxScrollExtent - 4) current = EdSection.values.last;
    _active.value = current;
  }

  void _goTo(EdSection s) {
    final box = _keys[s]!.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !_scroll.hasClients) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final target = (_scroll.offset + dy - (Ed.headerH + 14)).clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(target, duration: const Duration(milliseconds: 750), curve: Curves.easeInOutCubic);
  }

  void _toTop() =>
      _scroll.animateTo(0, duration: const Duration(milliseconds: 750), curve: Curves.easeInOutCubic);

  void _selectNav(int i) {
    switch (i) {
      case 0:
        _toTop();
        break;
      case 1:
        openAboutPage(context);
        break;
      case 2:
        openProjectsPage(context);
        break;
      case 3:
        openSkillsPage(context);
        break;
      case 4:
        openContactPage(context);
        break;
    }
  }

  void _toggleTheme() => ref.read(themeModeProvider.notifier).toggle();

  Future<void> _openContactForm() async {
    await Navigator.of(context).push(edRoute(const ContactPage()));
    _focus.requestFocus();
  }

  List<PaletteCommand> _commands() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      PaletteCommand('Navigate', 'Home', LucideIcons.house, _toTop, hint: 'top'),
      PaletteCommand('Pages', 'About Me', LucideIcons.user, () => openAboutPage(context)),
      PaletteCommand('Pages', 'Projects', LucideIcons.layoutGrid, () => openProjectsPage(context)),
      PaletteCommand('Pages', 'Skills & Stack', LucideIcons.layers, () => openSkillsPage(context)),
      PaletteCommand('Pages', 'Photography Gallery', LucideIcons.camera, () => Navigator.of(context).push(edRoute(const GalleryScreen()))),
      PaletteCommand('Pages', 'Contact', LucideIcons.send, () => openContactPage(context)),
      for (final p in PortfolioConfig.projects)
        PaletteCommand('Projects', p.name, LucideIcons.folderGit2, () => openProject(context, p, 'palette'),
            hint: p.categories.isEmpty ? null : p.categories.first),
      PaletteCommand('Links', 'Résumé', LucideIcons.fileText, () => openUrl(PortfolioConfig.resumeUrl)),
      PaletteCommand('Links', 'GitHub', LucideIcons.gitBranch, () => openUrl(PortfolioConfig.githubUrl)),
      PaletteCommand('Links', 'LinkedIn', LucideIcons.briefcase, () => openUrl(PortfolioConfig.linkedinUrl)),
      PaletteCommand('Links', 'Twitter / X', LucideIcons.messageCircle, () => openUrl(PortfolioConfig.twitterUrl)),
      PaletteCommand('Actions', 'Contact form', LucideIcons.send, _openContactForm),
      PaletteCommand('Actions', 'Copy email address', LucideIcons.copy, _copyEmail, hint: PortfolioConfig.email),
      PaletteCommand('Actions', dark ? 'Switch to light mode' : 'Switch to dark mode',
          dark ? LucideIcons.sun : LucideIcons.moon, _toggleTheme, hint: 'T'),
      PaletteCommand('Actions', 'Star this portfolio', LucideIcons.star, () => openUrl(PortfolioConfig.repoUrl)),
    ];
  }


  Future<void> _copyEmail() async {
    await Clipboard.setData(const ClipboardData(text: PortfolioConfig.email));
    if (!mounted) return;
    final ed = Ed.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      width: 280,
      backgroundColor: ed.ink,
      duration: const Duration(seconds: 2),
      content: Text('Email copied to clipboard', style: ed.mono(11, color: ed.paper)),
    ));
  }

  Future<void> _openPalette() async {
    await showCommandPalette(context, _commands());
    _focus.requestFocus();
  }

  @override
  void dispose() {
    edSectionRequest.removeListener(_onSectionRequest);
    edTopRequest.removeListener(_onTopRequest);
    _scroll.dispose();
    _focus.dispose();
    _avatarVisible.dispose();
    _progress.dispose();
    _floating.dispose();
    _active.dispose();
    _navIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final page = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final w in <Widget>[
        const SizedBox(height: Ed.headerH),
        EdHero(
          onSearch: _openPalette,
          onViewWork: () => _goTo(EdSection.work),
          onCopyEmail: _copyEmail,
          avatarKey: _avatarKey,
          avatarVisible: _avatarVisible,
        ),
        SectionBand('About', key: _keys[EdSection.about]),
        const EdAbout(),
        SectionBand(
          'Projects',
          key: _keys[EdSection.work],
          trailing: width < 540
              ? PillButton('View all', icon: LucideIcons.arrowRight, onTap: () => openProjectsPage(context))
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  const ProjectsViewToggle(),
                  const SizedBox(width: 8),
                  PillButton('View all', icon: LucideIcons.arrowRight, onTap: () => openProjectsPage(context)),
                ]),
        ),
        const EdProjects(count: 2),
        SectionBand('Experience', key: _keys[EdSection.experience]),
        const EdExperience(),
        SectionBand('Tech Stack', key: _keys[EdSection.skills]),
        const EdTechStack(),
        SectionBand(
          'Photography',
          key: _keys[EdSection.photography],
          trailing: PillButton(
            width < 540 ? 'Gallery' : 'Explore gallery',
            icon: LucideIcons.arrowRight,
            onTap: () => Navigator.of(context).push(edRoute(const GalleryScreen())),
          ),
        ),
        const EdPhotography(),
        SectionBand('GitHub Activity', key: _keys[EdSection.github], trailing: const EdGitHubTrailing()),
        const EdGitHub(),
        SectionBand('Contact', key: _keys[EdSection.contact]),
        const EdContact(),
      ])
        w is SizedBox ? w : RepaintBoundary(child: w),
    ],
  );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _openPalette,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): _openPalette,
        const SingleActivator(LogicalKeyboardKey.slash): _openPalette,
        const SingleActivator(LogicalKeyboardKey.keyT): _toggleTheme,
        const SingleActivator(LogicalKeyboardKey.keyP): () => openProjectsPage(context),
      },
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        child: Scaffold(
          backgroundColor: ed.page,
          body: Stack(children: [
            // Dot-grid background in the black side backgrounds
            Positioned.fill(
              child: RepaintBoundary(child: CustomPaint(
                painter: DotGridPainter(
                  ed.dark ? const Color(0xFF2B2B30) : const Color(0xFFE2E2E6),
                  spacing: 22,
                  radius: 1.1,
                ),
              )),
            ),
            SmoothScroll(
              controller: _scroll,
              child: SingleChildScrollView(
                controller: _scroll,
                physics: null,
                child: RepaintBoundary(child: page),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: EdNavBar(
                floating: _floating,
                progress: _progress,
                activeIndex: _navIndex,
                onSelect: _selectNav,
                onBrand: _toTop,
                onSearch: _openPalette,
                onToggleTheme: _toggleTheme,
              ),
            ),
            Positioned(
              right: width < 600 ? 14 : 22,
              bottom: width < 600 ? 14 : 22,
              child: _SectionPill(
                floating: _floating,
                progress: _progress,
                active: _active,
                onTap: _toTop,
              ),
            ),

          ]),
        ),
      ),
    );
  }
}




// ════════════════════════════════════════════════════════════════════
//  Floating section pill — current section + reading progress ring.
//  Appears once the page is scrolled; tap to return to the top.
// ════════════════════════════════════════════════════════════════════

class _SectionPill extends StatelessWidget {
  final ValueListenable<bool> floating;
  final ValueListenable<double> progress;
  final ValueListenable<EdSection?> active;
  final VoidCallback onTap;
  const _SectionPill({
    required this.floating,
    required this.progress,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return ValueListenableBuilder<bool>(
      valueListenable: floating,
      builder: (_, show, child) => IgnorePointer(
        ignoring: !show,
        child: AnimatedSlide(
          offset: show ? Offset.zero : const Offset(0, 0.6),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            duration: const Duration(milliseconds: 240),
            child: child,
          ),
        ),
      ),
      child: Hover(
        onTap: onTap,
        semanticLabel: 'Back to top',
        builder: (_, h) => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 36,
          padding: const EdgeInsets.fromLTRB(8, 0, 13, 0),
          decoration: BoxDecoration(
            color: h ? ed.raised : ed.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: h ? ed.line2 : ed.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: ed.dark ? 0.4 : 0.1),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Stack(alignment: Alignment.center, children: [
                ValueListenableBuilder<double>(
                  valueListenable: progress,
                  builder: (_, v, __) => CircularProgressIndicator(
                    value: v,
                    strokeWidth: 2,
                    backgroundColor: ed.line,
                    valueColor: AlwaysStoppedAnimation(ed.ink),
                  ),
                ),
                AnimatedOpacity(
                  opacity: h ? 1 : 0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(LucideIcons.arrowUp, size: 10, color: ed.ink),
                ),
              ]),
            ),
            const SizedBox(width: 9),
            ValueListenableBuilder<EdSection?>(
              valueListenable: active,
              builder: (_, s, __) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (c, a) => FadeTransition(
                  opacity: a,
                  child: SlideTransition(
                    position: Tween(begin: const Offset(0, 0.4), end: Offset.zero).animate(a),
                    child: c,
                  ),
                ),
                child: Text(
                  s?.label ?? 'Home',
                  key: ValueKey(s),
                  style: ed.sans(12.5, color: ed.ink, w: FontWeight.w500, h: 1),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}


