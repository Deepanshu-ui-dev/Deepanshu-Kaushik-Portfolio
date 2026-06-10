/// Deepanshu Kaushik's Interactive Portfolio Application
///
/// A high-performance Flutter portfolio showcasing:
/// - Smooth theme switching with circular reveal transition
/// - Responsive design across mobile, tablet, and web platforms
/// - Optimized animations and transitions
/// - SEO-friendly web presence
///
/// Entry point configuration:
/// - Initializes theme color cache for instant color access
/// - Sets up Riverpod provider scope for state management
/// - Configures MaterialApp with theme and navigation
library portfolio;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'config/portfolio_config.dart';
import 'core/theme/theme_extensions.dart';
// floating_nav_bar is re-exported via shared_widgets.dart
import 'core/widgets/shared_widgets.dart';
import 'core/widgets/lamp_theme_switcher.dart';
import 'core/widgets/circular_reveal_transition.dart';
import 'core/widgets/cat_cursor_follower.dart';

// ── Screens ──────────────────────────────────────────────────
import 'features/home/presentation/screens/home_screen.dart';
import 'features/about/presentation/screens/about_screen.dart';
import 'features/projects/presentation/screens/projects_screen.dart';
import 'features/skills/presentation/screens/skills_screen.dart';
import 'features/contact/presentation/screens/contact_screen.dart';

/// Application entry point
///
/// Initializes:
/// - Theme color cache for optimal performance
/// - Riverpod provider scope
/// - Root MaterialApp widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: PortfolioConfig.supabaseUrl,
    anonKey: PortfolioConfig.supabaseAnonKey,
  );

  // ── Performance boosts ──────────────────────────────────────────────────
  // Enable pointer-event resampling so touch/stylus input is interpolated
  // between frames → eliminates jitter on 90/120 Hz displays.
  GestureBinding.instance.resamplingEnabled = true;

  // Expand image LRU cache to 256 MB (default is 100 MB).
  // Prevents the gallery and project thumbnails from being evicted and
  // re-decoded every time the user scrolls back.
  PaintingBinding.instance.imageCache.maximumSizeBytes = 256 << 20;

  // Pre-compute and cache all theme colors for instant access during theme switching
  ThemeTransitionUtils.initializeColorCache();
  runApp(const ProviderScope(child: PortfolioApp()));
}

// ─────────────────────────────────────────────────────────────
// APP ROOT — Material App Configuration
// ─────────────────────────────────────────────────────────────

/// Root Material application widget
///
/// Responsibilities:
/// - Provides theme (light/dark mode support)
/// - Initializes navigation
/// - Watches theme state changes via Riverpod
///
/// SEO Note: Title and description are indexable by search engines
class PortfolioApp extends ConsumerWidget {
  /// Create a new PortfolioApp instance
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // Sync app colors globally whenever theme changes
    ref.watch(themeSyncProvider);

    return MaterialApp(
      title: 'Deepanshu Kaushik — Flutter Developer & UI/UX Designer | Portfolio 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const _AppShell(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// APP SHELL
//
// BLASTBufferQueue fix notes:
//   IndexedStack keeps ALL children in the widget tree and
//   active (ticking). Previously, multiple screens each had
//   AnimationControllers running simultaneously which pushed
//   the SurfaceView buffer count past the limit (max 1+2=3).
//
//   The fix is NOT to use PageView or Navigator (which unmounts
//   screens and loses state) — instead we ensure each screen's
//   animations are lightweight, use RepaintBoundary to isolate
//   repaints, and avoid IntrinsicHeight inside animated widgets.
//
//   Additionally, we add Offstage wrapping so hidden screens
//   do not participate in hit-testing or layout passes, while
//   still being kept alive for instant switching.
// ─────────────────────────────────────────────────────────────

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell();

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell>
    with SingleTickerProviderStateMixin {
  int _idx = 0;
  double _scrollOffset = 0.0;
  final Map<int, double> _scrollOffsets = {};

  // One dedicated ScrollController per tab — the FAB calls these directly
  final Map<int, ScrollController> _scrollControllers = {};

  ScrollController _controllerFor(int index) {
    return _scrollControllers.putIfAbsent(index, () => ScrollController());
  }

  // Track visited tabs to build them lazily
  final List<bool> _visited = [true, false, false, false, false];

  Widget _buildScreen(int index) {
    final sc = _controllerFor(index);
    switch (index) {
      case 0:  return HomeScreen(scrollController: sc);
      case 1:  return AboutScreen(scrollController: sc);
      case 2:  return ProjectsScreen(scrollController: sc);
      case 3:  return SkillsScreen(scrollController: sc);
      case 4:  return ContactScreen(scrollController: sc);
      default: return const SizedBox.shrink();
    }
  }

  void _openTab(int index) {
    if (index == _idx) {
      _scrollToTop();
      return;
    }
    if (!_visited[index]) {
      setState(() {
        _visited[index] = true;
      });
    }
    setState(() {
      _idx = index;
      _scrollOffset = _scrollOffsets[index] ?? 0.0;
    });
  }

  void _scrollToTop() {
    final controller = _scrollControllers[_idx];
    if (controller == null || !controller.hasClients) return;
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 420),
      curve: const Cubic(0.25, 0.46, 0.45, 0.94), // easeOutQuart — snappy
    );
  }

  // Keys to access screen contexts (kept for Offstage, not scroll lookup)
  final List<GlobalKey> _screenKeys = List.generate(5, (_) => GlobalKey());

  @override
  void dispose() {
    for (final c in _scrollControllers.values) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeSyncProvider); // Sync global AppColors state

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return CatCursorFollower(
      child: HatchBackground(
        child: Scaffold(
          body: RepaintBoundary(
            child: Stack(
              children: [
                Column(
                  children: [
                    // ── Main Content Area ───────────────────────────
                    Expanded(
                      child: CircularRevealTransition(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.axis == Axis.vertical) {
                              final offset = notification.metrics.pixels;
                              _scrollOffsets[_idx] = offset;
                              if (offset != _scrollOffset) {
                                setState(() {
                                  _scrollOffset = offset;
                                });
                              }
                            }
                            return false;
                          },
                          child: Stack(
                            children: [
                              // ── Screen content ─────────────────────────
                              GestureDetector(
                                  onHorizontalDragEnd: (details) {
                                    if (details.primaryVelocity == null) return;
                                    if (details.primaryVelocity! < -500) {
                                      if (_idx < _visited.length - 1) _openTab(_idx + 1);
                                    } else if (details.primaryVelocity! > 500) {
                                      if (_idx > 0) _openTab(_idx - 1);
                                    }
                                  },
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 760),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.bgDark : Colors.white,
                                      ),
                                      child: DotGridBackground(
                                        drawBackground: false,
                                        spacing: 20.0,
                                        dotRadius: 0.9,
                                        child: Stack(
                                          children: [
                                          for (int i = 0; i < 5; i++)
                                            if (_visited[i])
                                              Offstage(
                                                offstage: _idx != i,
                                                child: TickerMode(
                                                  enabled: _idx == i,
                                                  child: RepaintBoundary(
                                                    child: AnimatedScale(
                                                      scale: _idx == i ? 1.0 : 0.98,
                                                      duration: const Duration(milliseconds: 300),
                                                      curve: Curves.easeOutCubic,
                                                      child: AnimatedOpacity(
                                                        key: _screenKeys[i],
                                                        opacity: _idx == i ? 1.0 : 0.0,
                                                        duration: const Duration(milliseconds: 300),
                                                        curve: Curves.easeOutCubic,
                                                        child: AnimatedSlide(
                                                          offset: _idx == i
                                                              ? Offset.zero
                                                              : const Offset(0, 0.02),
                                                          duration: const Duration(milliseconds: 300),
                                                          curve: Curves.easeOutCubic,
                                                          child: _buildScreen(i),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ),
                                ),
                              ),

                              // ── Column frame lines ──────────────────────
                              // Hairline vertical lines at ±380px from center,
                              // matching the reference site's column border.
                              // Only drawn when screen width > 760px.
                              IgnorePointer(
                                child: CustomPaint(
                                  painter: _ColumnFramePainter(
                                    color: borderColor,
                                    maxContentWidth: 760,
                                  ),
                                  child: const SizedBox.expand(),
                                ),
                              ),

                              // ── Floating Nav Bar ───────────────────────────
                              Positioned(
                                bottom: 24,
                                left: 0,
                                right: 0,
                                child: RepaintBoundary(
                                  child: FloatingNavBar(
                                    currentIndex: _idx,
                                    onTap: _openTab,
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Footer ──────────────────────────────────────
                    PortfolioFooter(
                      onToggleTheme: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                    ),
                  ],
                ),

                // ── Standalone Lamp ───────────────────────────
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  right: 20,
                  child: const LampThemeSwitcher(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COLUMN FRAME PAINTER
//
// Draws two hairline vertical lines at ±(maxContentWidth/2) from
// the horizontal center. Only visible when the canvas is wider
// than maxContentWidth — on narrow screens lines sit at the edges
// and are not rendered.
// ─────────────────────────────────────────────────────────────

class _ColumnFramePainter extends CustomPainter {
  final Color color;
  final double maxContentWidth;

  const _ColumnFramePainter({
    required this.color,
    required this.maxContentWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= maxContentWidth) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final cx   = size.width / 2;
    final half = maxContentWidth / 2;

    // Left column border
    canvas.drawLine(Offset(cx - half, 0), Offset(cx - half, size.height), paint);
    // Right column border
    canvas.drawLine(Offset(cx + half, 0), Offset(cx + half, size.height), paint);
  }

  @override
  bool shouldRepaint(_ColumnFramePainter old) =>
      old.color != color || old.maxContentWidth != maxContentWidth;
}
