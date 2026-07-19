import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';



































class ScrollBorderAppBar extends StatefulWidget {
  final Widget child;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;

  
  
  final ScrollController? scrollController;

  
  final double height;

  
  final double horizontalPadding;

  
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
        
        Padding(
          padding: EdgeInsets.only(top: widget.height + MediaQuery.of(context).padding.top),
          child: _ownsController
              ? _InjectScrollController(
                  controller: _scrollCtrl,
                  child: widget.child,
                )
              : widget.child,
        ),

        
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