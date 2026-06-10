import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SCROLL BORDER APP BAR
//
// Sticky header that reacts to scroll — mirrors abdulrehmanwaseem.me's nav.
//
// Behaviour:
//   Rest:    fully transparent, no border
//   Scrolled: frosted-glass blur (sigma 12) + 97% opaque bg + 0.5px bottom border
//   Transition: 200ms easeOutCubic on color/border, instant on blur (ImageFilter
//               can't animate — we switch it on threshold)
//
// Improvements over original:
//   • Backdrop blur (ImageFilter.blur) for the frosted glass effect
//   • ScrollController-based detection instead of NotificationListener —
//     avoids false positives from nested scrollables
//   • Exposes scrollController so callers can share one instance
//   • Slim 48px height, 16px horizontal padding — matches the site's nav
//   • No Scaffold wrapper — renders as a plain widget for composability
//
// Usage (simple):
//   ScrollBorderAppBar(
//     title: Text('Abdul Rehman'),
//     actions: [ThemeToggle(), GitHubIcon()],
//     child: PageBody(),
//   )
//
// Usage (shared controller):
//   final _ctrl = ScrollController();
//   ScrollBorderAppBar(
//     scrollController: _ctrl,
//     child: ListView(controller: _ctrl, ...),
//   )
// ─────────────────────────────────────────────────────────────────────────────

class ScrollBorderAppBar extends StatefulWidget {
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;

  /// Provide an external ScrollController to share with the body.
  /// If null, an internal one is created and injected via [ScrollBorderAppBar.builder].
  final ScrollController? scrollController;

  /// Height of the app bar. Default: 48.
  final double height;

  /// Horizontal padding inside the bar. Default: 16.
  final double horizontalPadding;

  /// Scroll offset threshold to trigger the scrolled state. Default: 1.
  final double scrollThreshold;

  const ScrollBorderAppBar({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.leading,
    this.scrollController,
    this.height = 48.0,
    this.horizontalPadding = 16.0,
    this.scrollThreshold = 1.0,
  });

  @override
  State<ScrollBorderAppBar> createState() => _ScrollBorderAppBarState();
}

class _ScrollBorderAppBarState extends State<ScrollBorderAppBar> {
  late final ScrollController _scrollCtrl;
  bool _isScrolled = false;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollCtrl = widget.scrollController!;
    } else {
      _scrollCtrl = ScrollController();
      _ownsController = true;
    }
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    if (_ownsController) _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrolled = _scrollCtrl.offset > widget.scrollThreshold;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final bgColor = (isDark ? AppColors.bgDark : AppColors.bgLight)
        .withValues(alpha: 0.92);

    return Stack(
      children: [
        // ── Body — passes internal scroll controller if we own it ─────────
        Padding(
          padding: EdgeInsets.only(top: widget.height + MediaQuery.of(context).padding.top),
          child: _ownsController
              ? _InjectScrollController(
                  controller: _scrollCtrl,
                  child: widget.child,
                )
              : widget.child,
        ),

        // ── App bar — pinned at top ────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _AppBarSurface(
            isScrolled: _isScrolled,
            height: widget.height,
            horizontalPadding: widget.horizontalPadding,
            bgColor: bgColor,
            borderColor: borderColor,
            leading: widget.leading,
            title: widget.title,
            actions: widget.actions,
          ),
        ),
      ],
    );
  }
}

// ── Surface widget — isolates rebuilds to just the bar ───────────────────────

class _AppBarSurface extends StatelessWidget {
  final bool isScrolled;
  final double height;
  final double horizontalPadding;
  final Color bgColor;
  final Color borderColor;
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;

  const _AppBarSurface({
    required this.isScrolled,
    required this.height,
    required this.horizontalPadding,
    required this.bgColor,
    required this.borderColor,
    this.leading,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    // Blur is switched on/off (can't animate ImageFilter)
    Widget surface = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      color: isScrolled ? bgColor : Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isScrolled ? borderColor : Colors.transparent,
              width: 0.5,
            ),
          ),
        ),
        padding: EdgeInsets.only(
          top: topPad,
          left: horizontalPadding,
          right: horizontalPadding,
        ),
        height: height + topPad,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            if (title != null) Expanded(child: title!)
            else const Spacer(),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );

    // Wrap in blur only when scrolled — avoids permanent compositing layer cost
    if (isScrolled) {
      surface = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: surface,
        ),
      );
    }

    return surface;
  }
}

// ── Injects a ScrollController into a subtree via PrimaryScrollController ────

class _InjectScrollController extends StatelessWidget {
  final ScrollController controller;
  final Widget child;

  const _InjectScrollController({
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: controller,
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCROLL DIRECTION HIDE APP BAR
//
// Extension of the above — hides the bar when scrolling down, reveals on
// scroll up. Common on content-heavy pages where the nav should stay out
// of the way while reading.
//
// Usage:
//   ScrollDirectionHideAppBar(
//     title: Text('Blog'),
//     child: PostList(),
//   )
// ─────────────────────────────────────────────────────────────────────────────

class ScrollDirectionHideAppBar extends StatefulWidget {
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final double height;
  final double horizontalPadding;

  const ScrollDirectionHideAppBar({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.leading,
    this.height = 48.0,
    this.horizontalPadding = 16.0,
  });

  @override
  State<ScrollDirectionHideAppBar> createState() =>
      _ScrollDirectionHideAppBarState();
}

class _ScrollDirectionHideAppBarState
    extends State<ScrollDirectionHideAppBar> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _isScrolled = false;
  bool _isHidden = false;
  double _prevOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    final scrolled = offset > 1.0;
    final scrollingDown = offset > _prevOffset;

    if (scrolled != _isScrolled || scrollingDown != _isHidden) {
      setState(() {
        _isScrolled = scrolled;
        // Only hide if scrolling down AND already past the bar height
        _isHidden = scrollingDown && offset > widget.height;
      });
    }
    _prevOffset = offset;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final bgColor = (isDark ? AppColors.bgDark : AppColors.bgLight)
        .withValues(alpha: 0.92);
    final topPad = MediaQuery.of(context).padding.top;
    final totalBarHeight = widget.height + topPad;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: totalBarHeight),
          child: PrimaryScrollController(
            controller: _scrollCtrl,
            child: widget.child,
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          top: _isHidden ? -totalBarHeight : 0,
          left: 0,
          right: 0,
          child: _AppBarSurface(
            isScrolled: _isScrolled,
            height: widget.height,
            horizontalPadding: widget.horizontalPadding,
            bgColor: bgColor,
            borderColor: borderColor,
            leading: widget.leading,
            title: widget.title,
            actions: widget.actions,
          ),
        ),
      ],
    );
  }
}