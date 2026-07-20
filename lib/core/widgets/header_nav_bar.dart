import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import 'hatch_background.dart';




import '../../config/portfolio_config.dart';





























class HeaderNavBar extends StatefulWidget implements PreferredSizeWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool elevated;
  final double maxContentWidth;

  const HeaderNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.elevated = false,
    this.maxContentWidth = 760,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  State<HeaderNavBar> createState() => _HeaderNavBarState();
}

class _HeaderNavBarState extends State<HeaderNavBar> {
  static const List<_NavTab> _tabs = [
    _NavTab(label: 'HOME', icon: Icons.home_outlined),
    _NavTab(label: 'ABOUT', icon: Icons.person_outline_rounded),
    _NavTab(label: 'PROJECTS', icon: Icons.grid_view_rounded),
    _NavTab(label: 'SKILLS', icon: Icons.code_rounded),
    _NavTab(label: 'CONTACT', icon: Icons.mail_outline_rounded),
  ];

  
  
  
  static const double _mobileBreakpoint = 560.0;
  static const double _tinyBrandBreakpoint = 360.0;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<_MobileNavOverlayState> _overlayKey =
      GlobalKey<_MobileNavOverlayState>();
  OverlayEntry? _drawerEntry;
  bool _isMenuOpen = false;

  void _openMobileMenu(BuildContext context) {
    if (_drawerEntry != null) return;
    final overlay = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox?;
    final headerBottom = renderBox != null
        ? renderBox.localToGlobal(Offset.zero).dy + widget.preferredSize.height
        : MediaQuery.of(context).padding.top + widget.preferredSize.height;

    setState(() => _isMenuOpen = true);

    final entry = OverlayEntry(
      builder: (ctx) => _MobileNavOverlay(
        key: _overlayKey,
        tabs: _tabs,
        currentIndex: widget.currentIndex,
        topOffset: headerBottom,
        maxContentWidth: widget.maxContentWidth,
        onSelect: (i) {
          widget.onTap(i);
          _overlayKey.currentState?.animateOutAndRemove();
        },
        onRemoved: _handleOverlayRemoved,
      ),
    );
    _drawerEntry = entry;
    overlay.insert(entry);
  }

  void _requestCloseMobileMenu() {
    _overlayKey.currentState?.animateOutAndRemove();
  }

  
  void _handleOverlayRemoved() {
    _drawerEntry?.remove();
    _drawerEntry = null;
    if (mounted) setState(() => _isMenuOpen = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    
    
    _drawerEntry?.remove();
    _drawerEntry = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HeaderNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    
    
    if (_isMenuOpen && oldWidget.currentIndex != widget.currentIndex) {
      _requestCloseMobileMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final boxFill = isDark ? AppColors.bgDark : Colors.white;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Align(
      alignment: Alignment.topCenter,
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxContentWidth),
          child: LayoutBuilder(builder: (context, outer) {
            final w = outer.maxWidth;
            final isMobile = w < _mobileBreakpoint;

            final t = ((w - 340) / (760 - 340)).clamp(0.0, 1.0);
            final brandSize = _lerp(9.5, 11.0, t);
            final linkSize = _lerp(9.5, 11.5, t);
            final gap = _lerp(12.0, 24.0, t);
            final hPad = _lerp(14.0, 20.0, t);
            final showFullBrand = w >= 420;
            final showBrandAtAll = w >= _tinyBrandBreakpoint;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: boxFill,
                border: Border(
                  bottom: BorderSide(
                    color: (widget.elevated || _isMenuOpen)
                        ? border.withValues(alpha: 0.25)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                height: widget.preferredSize.height,
                child: DotGridBackground(
                  drawBackground: true,
                  enableVignette: false,
                  spacing: 20.0,
                  dotRadius: 0.9,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    child: Row(
                      children: [
                        if (showBrandAtAll) ...[
                          _BrandMark(
                            onTap: () => widget.onTap(0),
                            textSec: textSec,
                            fontSize: brandSize,
                            text: showFullBrand ? 'EST. 2006' : 'DEEPANSHU',
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: isMobile
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    
                                    
                                    
                                    
                                    
                                    if (w >= 260)
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: _SectionChip(
                                            label: _tabs[widget.currentIndex].label,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    _MenuButton(
                                      color: textPri,
                                      isOpen: _isMenuOpen,
                                      onTap: () => _isMenuOpen
                                          ? _requestCloseMobileMenu()
                                          : _openMobileMenu(context),
                                    ),
                                  ],
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: ScrollConfiguration(
                                    behavior: const _NoGlowBehavior(),
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      scrollDirection: Axis.horizontal,
                                      reverse: true,
                                      physics: const ClampingScrollPhysics(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (int i = 0; i < _tabs.length; i++) ...[
                                            if (i > 0) SizedBox(width: gap),
                                            _NavLink(
                                              tab: _tabs[i],
                                              isActive: widget.currentIndex == i,
                                              onTap: () => widget.onTap(i),
                                              fontSize: linkSize,
                                            ),
                                          ],
                                        ],
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
            );
          }),
        ),
      ),
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}






class _MenuButton extends StatefulWidget {
  final Color color;
  final bool isOpen;
  final VoidCallback onTap;
  const _MenuButton({required this.color, required this.isOpen, required this.onTap});

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final active = _pressed || widget.isOpen;

    return Semantics(
      button: true,
      label: widget.isOpen ? 'Close navigation menu' : 'Open navigation menu',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: active ? accent : border, width: 1),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                transitionBuilder: (child, anim) =>
                    RotationTransition(turns: anim, child: FadeTransition(opacity: anim, child: child)),
                child: Icon(
                  widget.isOpen ? Icons.close_rounded : Icons.menu_rounded,
                  key: ValueKey(widget.isOpen),
                  size: 17,
                  color: active ? accent : widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





class _BrandMark extends StatelessWidget {
  final VoidCallback onTap;
  final Color textSec;
  final double fontSize;
  final String text;

  const _BrandMark({
    required this.onTap,
    required this.textSec,
    required this.fontSize,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: fontSize,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w500,
            color: textSec,
          ),
        ),
      ),
    );
  }
}







class _SectionChip extends StatelessWidget {
  final String label;
  const _SectionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(border: Border.all(color: accent, width: 1)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '/$label',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10.5,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class _NavTab {
  final String label;
  final IconData icon;
  const _NavTab({required this.label, required this.icon});
}

class _NavLink extends StatefulWidget {
  final _NavTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final double fontSize;

  const _NavLink({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.fontSize,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;

    final Color color = widget.isActive ? textPri : (_hovered ? accent : textTer);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 160),
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: widget.fontSize,
                  letterSpacing: 0.8,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
                child: Text('/${widget.tab.label}'),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                height: 1.5,
                width: (widget.isActive || _hovered) ? 14 : 0,
                color: widget.isActive ? accent : accent.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}











class _MobileNavOverlay extends StatefulWidget {
  final List<_NavTab> tabs;
  final int currentIndex;
  final double topOffset;
  final double maxContentWidth;
  final ValueChanged<int> onSelect;
  final VoidCallback onRemoved;

  const _MobileNavOverlay({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.topOffset,
    required this.maxContentWidth,
    required this.onSelect,
    required this.onRemoved,
  });

  @override
  State<_MobileNavOverlay> createState() => _MobileNavOverlayState();
}

class _MobileNavOverlayState extends State<_MobileNavOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _panelScale;
  late final Animation<double> _fade;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _panelScale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _ctrl.value = 1.0;
    } else if (!_ctrl.isAnimating && _ctrl.value == 0.0) {
      _ctrl.forward();
    }
  }

  Future<void> animateOutAndRemove() async {
    if (_closing) return;
    _closing = true;
    if (mounted && !MediaQuery.of(context).disableAnimations) {
      await _ctrl.reverse();
    }
    widget.onRemoved();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boxFill = isDark ? AppColors.bgDark : Colors.white;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final screenSize = MediaQuery.of(context).size;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Positioned.fill(
      child: Stack(
        children: [
          
          
          
          Positioned(
            top: widget.topOffset,
            left: 0,
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _fade,
              child: GestureDetector(
                onTap: animateOutAndRemove,
                behavior: HitTestBehavior.opaque,
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(color: Colors.black.withValues(alpha: 0.35)),
                ),
              ),
            ),
          ),
          
          
          
          Positioned(
            top: widget.topOffset,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.maxContentWidth),
                child: AnimatedBuilder(
                  animation: _panelScale,
                  builder: (context, child) => ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _panelScale.value,
                      child: child,
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fade,
                    child: Material(
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: screenSize.height - widget.topOffset - bottomInset - 24,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: boxFill,
                            border: Border(
                              left: BorderSide(color: border, width: 1),
                              right: BorderSide(color: border, width: 1),
                              bottom: BorderSide(color: border, width: 1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              
                              SingleChildScrollView(
                                child: _MobileTabList(
                                  reveal: _ctrl,
                                  tabs: widget.tabs,
                                  currentIndex: widget.currentIndex,
                                  onSelect: widget.onSelect,
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
            ),
          ),
        ],
      ),
    );
  }
}



// ignore: unused_element
class _PanelFooter extends StatelessWidget {
  final Color border;
  const _PanelFooter({required this.border});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    final links = <_SocialLink>[
      const _SocialLink(Icons.code_rounded, 'Open GitHub profile', PortfolioConfig.githubUrl),
      const _SocialLink(Icons.business_center_outlined, 'Open LinkedIn profile', PortfolioConfig.linkedinUrl),
      const _SocialLink(Icons.alternate_email_rounded, 'Open X profile', PortfolioConfig.twitterUrl),
      const _SocialLink(Icons.mail_outline_rounded, 'Email ${PortfolioConfig.email}', 'mailto:${PortfolioConfig.email}'),
    ];

    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: border, width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  'OPEN TO WORK',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                for (var i = 0; i < links.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: _SocialButton(link: links[i])),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLink {
  final IconData icon;
  final String semanticLabel;
  final String url;
  const _SocialLink(this.icon, this.semanticLabel, this.url);
}

class _SocialButton extends StatefulWidget {
  final _SocialLink link;
  const _SocialButton({required this.link});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textTer = isDark ? AppColors.textTerDark : AppColors.textTerLight;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;

    return Semantics(
      link: true,
      label: widget.link.semanticLabel,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: () => launchUrl(
          Uri.parse(widget.link.url),
          mode: LaunchMode.externalApplication,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            border: Border.all(color: _pressed ? accent : border, width: 1),
          ),
          child: Center(
            child: Icon(widget.link.icon, size: 15, color: _pressed ? accent : textTer),
          ),
        ),
      ),
    );
  }
}








class _MobileTabList extends StatelessWidget {
  final List<_NavTab> tabs;
  final int currentIndex;
  final ValueChanged<int> onSelect;
  
  
  
  
  
  final Animation<double> reveal;

  const _MobileTabList({
    required this.tabs,
    required this.currentIndex,
    required this.onSelect,
    required this.reveal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tabs.length; i++) ...[
          _MobileTabRow(
            index: i,
            tab: tabs[i],
            active: currentIndex == i,
            onTap: () => onSelect(i),
            reveal: reveal,
            staggerStart: i / (tabs.length + 1),
          ),
          if (i < tabs.length - 1) _DashLine(color: border),
        ],
      ],
    );
  }
}

class _MobileTabRow extends StatefulWidget {
  final int index;
  final _NavTab tab;
  final bool active;
  final VoidCallback onTap;
  final Animation<double> reveal;
  final double staggerStart;

  const _MobileTabRow({
    required this.index,
    required this.tab,
    required this.active,
    required this.onTap,
    required this.reveal,
    required this.staggerStart,
  });

  @override
  State<_MobileTabRow> createState() => _MobileTabRowState();
}

class _MobileTabRowState extends State<_MobileTabRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accentLight;
    final textPri = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSec = isDark ? AppColors.textSecDark : AppColors.textSecLight;

    final bg = widget.active
        ? accent.withValues(alpha: 0.08)
        : (_pressed ? accent.withValues(alpha: 0.04) : Colors.transparent);

    final rowEntrance = CurvedAnimation(
      parent: widget.reveal,
      curve: Interval(widget.staggerStart, 1.0, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: rowEntrance,
      builder: (context, child) => Opacity(
        opacity: rowEntrance.value,
        child: Transform.translate(
          offset: Offset(0, (1 - rowEntrance.value) * 10),
          child: child,
        ),
      ),
      child: Semantics(
        button: true,
        selected: widget.active,
        label: widget.tab.label,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: bg,
            constraints: const BoxConstraints(minHeight: 56),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                
                
                
                
                
                Positioned(
                  right: 8,
                  top: -14,
                  child: Text(
                    '0${widget.index}',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: (widget.active ? accent : textSec).withValues(alpha: 0.06),
                    ),
                  ),
                ),
                
                
                if (widget.active)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 3, color: accent),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Text(
                          '0${widget.index}',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10,
                            color: textSec,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(widget.tab.icon, size: 17, color: widget.active ? accent : textSec),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '/${widget.tab.label}',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: widget.active ? 16 : 14,
                            letterSpacing: 0.6,
                            fontWeight: widget.active ? FontWeight.w700 : FontWeight.w400,
                            color: widget.active ? accent : textPri,
                          ),
                        ),
                      ),
                      if (widget.active)
                        Icon(Icons.circle, size: 6, color: accent)
                      else
                        Icon(Icons.arrow_forward_rounded, size: 14, color: textSec.withValues(alpha: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashLine extends StatelessWidget {
  final Color color;
  const _DashLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashPainter(color: color),
        size: Size.infinite,
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  final Color color;
  const _DashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter old) => old.color != color;
}