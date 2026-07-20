











library portfolio;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'config/portfolio_config.dart';
import 'core/theme/theme_extensions.dart';
import 'core/widgets/header_nav_bar.dart';


import 'core/widgets/shared_widgets.dart';
import 'core/widgets/lamp_theme_switcher.dart';
import 'core/widgets/cat_cursor_follower.dart';
import 'core/widgets/smooth_scroll.dart';
import 'core/widgets/portfolio_drawer.dart';


import 'features/home/presentation/screens/home_screen.dart';
import 'features/about/presentation/screens/about_screen.dart';
import 'features/projects/presentation/screens/projects_screen.dart';
import 'features/skills/presentation/screens/skills_screen.dart';
import 'features/contact/presentation/screens/contact_screen.dart';







void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  await Supabase.initialize(
    url: PortfolioConfig.supabaseUrl,
    anonKey: PortfolioConfig.supabaseAnonKey,
  );

  
  
  
  GestureBinding.instance.resamplingEnabled = true;

  
  
  
  PaintingBinding.instance.imageCache.maximumSizeBytes = 256 << 20;

  
  ThemeTransitionUtils.initializeColorCache();
  runApp(const ProviderScope(child: PortfolioApp()));
}













class PortfolioApp extends ConsumerWidget {
  
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
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

  
  final Map<int, ScrollController> _scrollControllers = {};

  ScrollController _controllerFor(int index) {
    return _scrollControllers.putIfAbsent(index, () => ScrollController());
  }

  
  final List<bool> _visited = [true, false, false, false, false];

  Widget _buildScreen(int index) {
    final sc = _controllerFor(index);
    Widget screen;
    switch (index) {
      case 0:  screen = HomeScreen(scrollController: sc); break;
      case 1:  screen = AboutScreen(scrollController: sc); break;
      case 2:  screen = ProjectsScreen(scrollController: sc); break;
      case 3:  screen = SkillsScreen(scrollController: sc); break;
      case 4:  screen = ContactScreen(scrollController: sc); break;
      default: screen = const SizedBox.shrink();
    }
    return SmoothScroll(controller: sc, child: screen);
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
      curve: const Cubic(0.25, 0.46, 0.45, 0.94), 
    );
  }

  
  final List<GlobalKey> _screenKeys = List.generate(5, (_) => GlobalKey());

  @override
  void dispose() {
    for (final c in _scrollControllers.values) { c.dispose(); }
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    ref.watch(themeSyncProvider); 

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final safeTop = MediaQuery.of(context).padding.top;

    return CatCursorFollower(
      child: HatchBackground(
        child: Scaffold(
          drawer: PortfolioDrawer(
            currentIndex: _idx,
            onSelect: _openTab,
          ),
          body: RepaintBoundary(
            child: Column(
              children: [
                
                
                
                Expanded(
                  child: Stack(
                    children: [
                      
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.bgDark : Colors.white,
                            ),
                            child: DotGridBackground(
                              drawBackground: false, 
                              enableVignette: false,
                              spacing: 20.0,
                              dotRadius: 0.9,
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
                                child: GestureDetector(
                                  onHorizontalDragEnd: (details) {
                                    if (details.primaryVelocity == null) return;
                                    if (details.primaryVelocity! < -500) {
                                      if (_idx < _visited.length - 1) _openTab(_idx + 1);
                                    } else if (details.primaryVelocity! > 500) {
                                      if (_idx > 0) _openTab(_idx - 1);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      for (int i = 0; i < 5; i++)
                                        if (_visited[i])
                                          Offstage(
                                            offstage: _idx != i,
                                            child: TickerMode(
                                              enabled: _idx == i,
                                              child: RepaintBoundary(
                                                child: AnimatedOpacity(
                                                  key: _screenKeys[i],
                                                  opacity: _idx == i ? 1.0 : 0.0,
                                                  duration: const Duration(milliseconds: 250),
                                                  curve: Curves.easeOutCubic,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 80.0),
                                                    child: _buildScreen(i),
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
                      ),

                      
                      Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: HeaderNavBar(
                          currentIndex: _idx,
                          onTap: _openTab,
                          elevated: _scrollOffset > 8,
                        ),
                      ),

                      
                      
                      
                      
                      
                      
                      IgnorePointer(
                        child: CustomPaint(
                          painter: _ColumnFramePainter(
                            color: borderColor,
                            maxContentWidth: 760,
                            elevated: _scrollOffset > 8,
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),

                      
                      
                      
                      
                      if (MediaQuery.of(context).size.width > 860)
                        Positioned(
                          top: safeTop + 4,
                          right: 16,
                          child: const LampThemeSwitcher(),
                        ),
                    ],
                  ),
                ),

                
                
                
                
                Stack(
                  children: [
                    
                    Container(
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Container(
                            color: isDark ? AppColors.bgDark : Colors.white,
                            child: DotGridBackground(
                              drawBackground: false,
                              enableVignette: false,
                              spacing: 20.0,
                              dotRadius: 0.9,
                              child: PortfolioFooter(
                                onToggleTheme: () =>
                                    ref.read(themeModeProvider.notifier).toggle(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _ColumnFramePainter(
                            color: borderColor,
                            maxContentWidth: 760,
                            elevated: true, 
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}












class _ColumnFramePainter extends CustomPainter {
  final Color color;
  final double maxContentWidth;
  final bool elevated;

  const _ColumnFramePainter({
    required this.color,
    required this.maxContentWidth,
    this.elevated = false,
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

    
    canvas.drawLine(Offset(cx - half, 0), Offset(cx - half, size.height), paint);
    
    canvas.drawLine(Offset(cx + half, 0), Offset(cx + half, size.height), paint);
    
    
    
    if (!elevated) {
      canvas.drawLine(Offset(cx - half, 0), Offset(cx + half, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_ColumnFramePainter old) =>
      old.color != color ||
      old.maxContentWidth != maxContentWidth ||
      old.elevated != elevated;
}