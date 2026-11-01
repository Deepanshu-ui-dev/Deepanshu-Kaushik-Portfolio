import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_primitives.dart';
import 'ed_sections.dart' show OpenToWork;
import 'ed_theme.dart';

/// Banner + profile header. The avatar is the landing target of the intro
/// animation, so it stays invisible until [avatarVisible] flips to true.
class EdHero extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onViewWork;
  final VoidCallback onCopyEmail;
  final GlobalKey avatarKey;
  final ValueListenable<bool> avatarVisible;

  const EdHero({
    super.key,
    required this.onSearch,
    required this.onViewWork,
    required this.onCopyEmail,
    required this.avatarKey,
    required this.avatarVisible,
  });

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 600;
    final veryNarrow = width < 400;
    final avatar = veryNarrow ? 52.0 : (narrow ? 60.0 : 72.0);

    return ColumnBox(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner image — shorter on mobile
          Container(
            height: veryNarrow ? 110 : (narrow ? 140 : 210),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ed.line2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/profile_banner.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: ed.raised),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(edPad(context) - 8, 14, edPad(context) - 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + name row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: avatarVisible,
                      builder: (_, visible, child) => Opacity(opacity: visible ? 1 : 0, child: child),
                      child: Hover(
                        builder: (_, h) => Container(
                          key: avatarKey,
                          width: avatar,
                          height: avatar,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: h ? ed.line2 : ed.line, width: 1.2),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AnimatedScale(
                            scale: h ? 1.05 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                            child: Image.asset('assets/images/profile.png',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(LucideIcons.user, color: ed.ink3)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + open-to-work badge — wrap gracefully
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                PortfolioConfig.name,
                                style: ed.serif(veryNarrow ? 20 : (narrow ? 24 : 30)),
                              ),
                              if (PortfolioConfig.openToWork) const OpenToWork(),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            PortfolioConfig.headline,
                            style: ed.sans(
                              veryNarrow ? 11.5 : 13,
                              color: ed.ink2,
                              w: FontWeight.w500,
                              h: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(children: [
                            Icon(LucideIcons.mapPin, size: 10, color: ed.ink3),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                PortfolioConfig.location,
                                style: ed.mono(10, color: ed.ink3),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // CTA buttons — scrollable row on mobile to prevent bad wrapping
                if (narrow)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _Cta('View projects', LucideIcons.arrowDown, onTap: onViewWork, filled: true),
                        const SizedBox(width: 8),
                        _Cta('Résumé', LucideIcons.fileText, onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                        const SizedBox(width: 8),
                        _Cta('GitHub', LucideIcons.arrowUpRight, onTap: () => openUrl(PortfolioConfig.githubUrl)),
                        const SizedBox(width: 8),
                        _Cta('Copy email', LucideIcons.copy, onTap: onCopyEmail),
                      ],
                    ),
                  )
                else
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    _Cta('View projects', LucideIcons.arrowDown, onTap: onViewWork, filled: true),
                    _Cta('Résumé', LucideIcons.fileText, onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                    _Cta('GitHub', LucideIcons.arrowUpRight, onTap: () => openUrl(PortfolioConfig.githubUrl)),
                    _Cta('Copy email', LucideIcons.copy, onTap: onCopyEmail),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Returns identity filter (full color).
ColorFilter grayFilter(double t) {
  return const ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0,
  ]);
}

/// Terminal-style prompt that types and deletes each role in turn.
class RoleTicker extends StatefulWidget {
  const RoleTicker({super.key});
  @override
  State<RoleTicker> createState() => _RoleTickerState();
}

class _RoleTickerState extends State<RoleTicker> {
  static const _roles = PortfolioConfig.roles;
  int _i = 0;
  int _chars = 0;
  bool _deleting = false;
  bool _caret = true;
  Timer? _t;
  Timer? _blink;

  @override
  void initState() {
    super.initState();
    _blink = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _caret = !_caret);
    });
    _schedule(const Duration(milliseconds: 400));
  }

  void _schedule(Duration d) {
    _t?.cancel();
    _t = Timer(d, _step);
  }

  void _step() {
    if (!mounted) return;
    final word = _roles[_i];
    setState(() {
      if (!_deleting) {
        if (_chars < word.length) {
          _chars++;
          _schedule(Duration(milliseconds: 45 + (_chars % 3) * 15));
        } else {
          _deleting = true;
          _schedule(const Duration(milliseconds: 1900));
        }
      } else {
        if (_chars > 0) {
          _chars--;
          _schedule(const Duration(milliseconds: 22));
        } else {
          _deleting = false;
          _i = (_i + 1) % _roles.length;
          _schedule(const Duration(milliseconds: 260));
        }
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _blink?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final text = _roles[_i].substring(0, _chars);
    return RepaintBoundary(child: Semantics(
      label: PortfolioConfig.headline,
      excludeSemantics: true,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('~ \$ ', style: ed.mono(12, color: ed.live)),
        Text(text, style: ed.mono(12, color: ed.ink)),
        Opacity(
          opacity: _caret ? 1 : 0,
          child: Container(width: 7, height: 14, margin: const EdgeInsets.only(left: 1), color: ed.ink),
        ),
      ]),
    ));
  }
}

class _Cta extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  const _Cta(this.label, this.icon, {required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: onTap,
      semanticLabel: label,
      builder: (_, h) => AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: filled ? (h ? ed.ink.withValues(alpha: 0.88) : ed.ink) : (h ? ed.raised : ed.card),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: filled ? ed.ink : (h ? ed.line2 : ed.line)),
          boxShadow: h
              ? [BoxShadow(color: Colors.black.withValues(alpha: filled ? 0.22 : 0.06), blurRadius: 10, offset: const Offset(0, 3))]
              : null,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: ed.sans(12, color: filled ? ed.paper : (h ? ed.ink : ed.ink2), w: FontWeight.w500, h: 1)),
          const SizedBox(width: 6),
          Icon(icon, size: 12, color: filled ? ed.paper : (h ? ed.ink : ed.ink3)),
        ]),
      ),
    );
  }
}
