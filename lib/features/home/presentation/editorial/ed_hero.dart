import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_motion.dart';
import 'ed_primitives.dart';
import 'ed_sections.dart' show OpenToWork;
import 'ed_theme.dart';

/// Banner + profile header.
///
/// Layout follows a "personal notebook" pattern: cover image with a
/// handwritten margin note, an avatar that leans toward the cursor and talks
/// through a speech bubble, a meta list (role, live clock, place, email), pill
/// links and a "before you hire me" tray of questions the avatar answers.
class EdHero extends StatefulWidget {
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
  State<EdHero> createState() => _EdHeroState();
}

class _EdHeroState extends State<EdHero> {
  /// Text currently in the avatar's speech bubble ('' = hidden, '…' = typing).
  final _say = ValueNotifier<String>('');
  final _lean = ValueNotifier<Offset>(Offset.zero);
  final _pokes = ValueNotifier<int>(0);
  final _asked = <int>{};
  int? _on;
  bool _askOpen = false;
  Timer? _sayTimer;
  int _pokeIndex = 0;

  void _speak(String text) {
    _sayTimer?.cancel();
    _say.value = '…';
    _sayTimer = Timer(const Duration(milliseconds: 520), () {
      if (!mounted) return;
      _say.value = text;
      _sayTimer = Timer(Duration(milliseconds: 3800 + text.length * 45), () {
        if (!mounted) return;
        _say.value = '';
        setState(() => _on = null);
      });
    });
  }

  void _ask(int i) {
    setState(() {
      _on = i;
      _asked.add(i);
    });
    _speak(PortfolioConfig.askMe[i].$2);
  }

  void _poke() {
    _pokes.value++;
    const lines = PortfolioConfig.pokeLines;
    _speak(lines[_pokeIndex++ % lines.length]);
  }

  @override
  void dispose() {
    _sayTimer?.cancel();
    _say.dispose();
    _lean.dispose();
    _pokes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final narrow = width < 600;
    final veryNarrow = width < 400;
    final avatar = veryNarrow ? 64.0 : (narrow ? 72.0 : 84.0);
    final pad = edPad(context);

    return MouseRegion(
      // The avatar leans a few degrees toward wherever the cursor is.
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final c = box.size.center(Offset.zero);
        _lean.value = Offset(
          ((e.localPosition.dx - c.dx) / box.size.width).clamp(-0.5, 0.5),
          ((e.localPosition.dy - c.dy) / box.size.height).clamp(-0.5, 0.5),
        );
      },
      onExit: (_) => _lean.value = Offset.zero,
      child: ColumnBox(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Cover ──────────────────────────────────────────────────
            EdReveal(
              rise: 0,
              blur: 14,
              child: Container(
                height: veryNarrow ? 130 : (narrow ? 170 : 240),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ed.line2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/profile_banner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: ed.raised),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(pad - 8, 22, pad - 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Avatar + name ─────────────────────────────────────
                  Stack(clipBehavior: Clip.none, children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      EdReveal(
                        delay: const Duration(milliseconds: 120),
                        child: ValueListenableBuilder<bool>(
                          valueListenable: widget.avatarVisible,
                          builder: (_, visible, child) => Opacity(opacity: visible ? 1 : 0, child: child),
                          child: _Avatar(
                            key: widget.avatarKey,
                            size: avatar,
                            lean: _lean,
                            pokes: _pokes,
                            onPoke: _poke,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 4,
                            children: [
                              SplitReveal(
                                PortfolioConfig.name,
                                delay: const Duration(milliseconds: 200),
                                style: ed.serif(veryNarrow ? 30 : (narrow ? 34 : 42)),
                              ),
                              if (PortfolioConfig.openToWork)
                                const EdReveal(delay: Duration(milliseconds: 900), child: OpenToWork()),
                            ],
                          ),
                          const SizedBox(height: 4),
                          EdReveal(
                            delay: const Duration(milliseconds: 280),
                            child: Text(
                              PortfolioConfig.headline,
                              style: ed.sans(veryNarrow ? 13 : 14.5, color: ed.ink2, h: 1.4),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                    // Only on full-width columns, where it clears the name.
                    if (width >= Ed.column)
                      Positioned(
                        right: 0,
                        top: -14,
                        child: EdReveal(
                          delay: const Duration(milliseconds: 1100),
                          child: _MarginNote(ed: ed),
                        ),
                      ),
                    // Speech bubble floats above the avatar.
                    Positioned(
                      left: avatar * 0.62,
                      top: -6,
                      child: _SpeechBubble(say: _say, ed: ed, maxWidth: narrow ? 230 : 290),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Meta list ─────────────────────────────────────────
                  EdReveal(
                    delay: const Duration(milliseconds: 360),
                    child: _MetaList(ed: ed),
                  ),

                  const SizedBox(height: 18),

                  // ── Pill links ────────────────────────────────────────
                  EdReveal(
                    delay: const Duration(milliseconds: 440),
                    child: Wrap(spacing: 6, runSpacing: 6, children: [
                      _Pill('github', null, svg: 'assets/icons/tech/github.svg', onTap: () => openUrl(PortfolioConfig.githubUrl)),
                      _Pill('linkedin', null, svg: 'assets/icons/tech/linkedin.svg', onTap: () => openUrl(PortfolioConfig.linkedinUrl)),
                      _Pill('résumé', LucideIcons.fileText,
                          trailing: LucideIcons.arrowUpRight, onTap: () => openUrl(PortfolioConfig.resumeUrl)),
                      _Pill('before you hire me', LucideIcons.circleQuestionMark,
                          active: _askOpen, onTap: () => setState(() => _askOpen = !_askOpen)),
                    ]),
                  ),
                ],
              ),
            ),

            // ── Ask tray ─────────────────────────────────────────────────
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Ed.easeOut,
                alignment: Alignment.topCenter,
                child: _askOpen
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(pad - 8, 16, pad - 8, 0),
                        child: _AskTray(on: _on, asked: _asked, onAsk: _ask),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Avatar — leans toward the cursor, wobbles when poked.
// ════════════════════════════════════════════════════════════════════

class _Avatar extends StatefulWidget {
  final double size;
  final ValueListenable<Offset> lean;
  final ValueListenable<int> pokes;
  final VoidCallback onPoke;
  const _Avatar({super.key, required this.size, required this.lean, required this.pokes, required this.onPoke});

  @override
  State<_Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<_Avatar> with TickerProviderStateMixin {
  late final AnimationController _wobble =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  late final AnimationController _leanC = AnimationController.unbounded(vsync: this);
  Offset _from = Offset.zero, _to = Offset.zero;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    widget.pokes.addListener(_onPoke);
    widget.lean.addListener(_onLean);
  }

  void _onPoke() {
    if (edReduceMotion(context)) return;
    _wobble.forward(from: 0);
  }

  void _onLean() {
    // Ease toward the new target instead of snapping.
    _from = Offset.lerp(_from, _to, _leanC.value.clamp(0, 1))!;
    _to = widget.lean.value;
    _leanC
      ..value = 0
      ..animateTo(1, duration: const Duration(milliseconds: 420), curve: Ed.easeOut);
  }

  @override
  void dispose() {
    widget.pokes.removeListener(_onPoke);
    widget.lean.removeListener(_onLean);
    _wobble.dispose();
    _leanC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final reduce = edReduceMotion(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPoke,
        child: Semantics(
          button: true,
          label: 'Photo of ${PortfolioConfig.name}. Tap to poke.',
          child: AnimatedBuilder(
            animation: Listenable.merge([_wobble, _leanC]),
            builder: (_, child) {
              final l = reduce ? Offset.zero : Offset.lerp(_from, _to, _leanC.value.clamp(0, 1))!;
              // Damped sine wobble.
              final w = _wobble.value;
              final wob = w == 0 || w == 1 ? 0.0 : math.sin(w * math.pi * 5) * (1 - w) * 0.12;
              final m = Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..rotateY(l.dx * 0.35)
                ..rotateX(-l.dy * 0.35)
                ..rotateZ(wob);
              return Transform(alignment: Alignment.center, transform: m, child: child);
            },
            child: AnimatedScale(
              scale: _hover ? 1.04 : 1,
              duration: const Duration(milliseconds: 450),
              curve: Curves.elasticOut,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _hover ? ed.line2 : ed.line, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: ed.dark ? 0.35 : 0.08),
                      blurRadius: _hover ? 18 : 8,
                      offset: Offset(0, _hover ? 8 : 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(LucideIcons.user, color: ed.ink3)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Speech bubble — springs in above the avatar, shows a typing indicator
//  before each answer.
// ════════════════════════════════════════════════════════════════════

class _SpeechBubble extends StatelessWidget {
  final ValueListenable<String> say;
  final Ed ed;
  final double maxWidth;
  const _SpeechBubble({required this.say, required this.ed, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: say,
      builder: (_, text, __) => Semantics(
        liveRegion: true,
        label: text == '…' ? null : text,
        child: FractionalTranslation(
          translation: const Offset(0, -1),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 380),
            switchInCurve: Curves.elasticOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (c, a) => FadeTransition(
              opacity: CurvedAnimation(parent: a, curve: const Interval(0, 0.5)),
              child: ScaleTransition(scale: a, alignment: Alignment.bottomLeft, child: c),
            ),
            layoutBuilder: (cur, prev) => Stack(
              alignment: Alignment.bottomLeft,
              children: [...prev, if (cur != null) cur],
            ),
            child: text.isEmpty
                ? const SizedBox(key: ValueKey('none'))
                : Container(
                    key: ValueKey(text),
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ed.ink,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                        bottomLeft: Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: ed.dark ? 0.4 : 0.14),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: text == '…'
                        ? _TypingDots(color: ed.paper)
                        : Text(text, style: ed.sans(13, color: ed.paper, h: 1.45)),
                  ),
          ),
        ),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  final Color color;
  const _TypingDots({required this.color});
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Row(mainAxisSize: MainAxisSize.min, children: [
          for (int i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.translate(
                offset: Offset(0, -3 * math.max(0, math.sin((_c.value - i * 0.18) * 2 * math.pi))),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withValues(alpha: 0.8)),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Meta list — role, live local clock vs the visitor's, place, email.
// ════════════════════════════════════════════════════════════════════

class _MetaList extends StatefulWidget {
  final Ed ed;
  const _MetaList({required this.ed});
  @override
  State<_MetaList> createState() => _MetaListState();
}

class _MetaListState extends State<_MetaList> {
  static const _days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  late Timer _tick;
  DateTime _now = DateTime.now();
  bool _copied = false;
  Timer? _copiedT;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _tick.cancel();
    _copiedT?.cancel();
    super.dispose();
  }

  String get _time {
    final t = _now.toUtc().add(const Duration(minutes: PortfolioConfig.utcOffsetMinutes));
    final h12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    return '$h12:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'am' : 'pm'} · ${_days[t.weekday - 1]}';
  }

  String get _diff {
    final mins = PortfolioConfig.utcOffsetMinutes - _now.timeZoneOffset.inMinutes;
    if (mins == 0) return '// same time as you';
    final a = mins.abs();
    final h = a ~/ 60, m = a % 60;
    final span = [if (h > 0) '${h}h', if (m > 0) '${m}m'].join(' ');
    return '// $span ${mins > 0 ? 'ahead' : 'behind'}';
  }

  Future<void> _copy() async {
    await Clipboard.setData(const ClipboardData(text: PortfolioConfig.email));
    if (!mounted) return;
    setState(() => _copied = true);
    _copiedT?.cancel();
    _copiedT = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ed = widget.ed;
    final current = PortfolioConfig.experience.where((r) => r.isCurrent).firstOrNull;
    final body = ed.sans(13.5, color: ed.ink2, h: 1.4);

    Widget row(IconData icon, Widget child) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: [
            Icon(icon, size: 14, color: ed.ink3),
            const SizedBox(width: 10),
            Flexible(child: child),
          ]),
        );

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (current != null)
        row(LucideIcons.codeXml, Text.rich(TextSpan(style: body, children: [
          TextSpan(text: '${current.role.toLowerCase()} at '),
          TextSpan(text: current.company, style: body.copyWith(color: ed.ink, fontWeight: FontWeight.w500)),
        ]))),
      row(LucideIcons.clock,
          Text.rich(TextSpan(style: body, children: [
            TextSpan(text: _time),
            TextSpan(text: '  $_diff', style: ed.mono(11.5, color: ed.ink3)),
          ]))),
      row(LucideIcons.mapPin, Text(PortfolioConfig.location.toLowerCase(), style: body)),
      row(
        LucideIcons.mail,
        Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: Hover(
              onTap: _copy,
              semanticLabel: 'Copy email address ${PortfolioConfig.email}',
              builder: (_, h) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.only(bottom: 1),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: h ? ed.ink2 : ed.line2)),
                ),
                child: Text(PortfolioConfig.email,
                    style: body.copyWith(color: h ? ed.ink : ed.ink2), overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedOpacity(
            opacity: _copied ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            child: AnimatedSlide(
              offset: _copied ? Offset.zero : const Offset(-0.3, 0),
              duration: const Duration(milliseconds: 400),
              curve: Ed.easeOut,
              child: Text('copied', style: ed.mono(11, color: ed.live)),
            ),
          ),
        ]),
      ),
    ]);
  }
}

// ════════════════════════════════════════════════════════════════════
//  Pill link
// ════════════════════════════════════════════════════════════════════

class _Pill extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? svg;
  final IconData? trailing;
  final bool active;
  final VoidCallback onTap;
  const _Pill(this.label, this.icon, {required this.onTap, this.svg, this.trailing, this.active = false});

  @override
  State<_Pill> createState() => _PillState();
}

class _PillState extends State<_Pill> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: Hover(
        onTap: widget.onTap,
        semanticLabel: widget.label,
        builder: (_, h) {
          final on = h || widget.active;
          return AnimatedScale(
            scale: _down ? 0.95 : 1,
            duration: const Duration(milliseconds: 380),
            curve: Curves.elasticOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: on ? ed.raised : ed.card,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: on ? ed.line2 : ed.line),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (widget.svg != null)
                  SvgPicture.asset(widget.svg!,
                      width: 13,
                      height: 13,
                      colorFilter: ColorFilter.mode(on ? ed.ink : ed.ink2, BlendMode.srcIn))
                else
                  Icon(widget.icon, size: 14, color: on ? ed.ink : ed.ink2),
                const SizedBox(width: 7),
                Text(widget.label, style: ed.sans(13, color: on ? ed.ink : ed.ink2, w: FontWeight.w500, h: 1)),
                if (widget.trailing != null) ...[
                  const SizedBox(width: 4),
                  AnimatedSlide(
                    offset: h ? const Offset(0.15, -0.15) : Offset.zero,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.elasticOut,
                    child: Icon(widget.trailing, size: 12, color: on ? ed.ink : ed.ink3),
                  ),
                ],
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Ask tray — dashed question chips; the avatar answers in its bubble.
// ════════════════════════════════════════════════════════════════════

class _AskTray extends StatelessWidget {
  final int? on;
  final Set<int> asked;
  final ValueChanged<int> onAsk;
  const _AskTray({required this.on, required this.asked, required this.onAsk});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    const qs = PortfolioConfig.askMe;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('go on, ask. i\'ll answer from up there.', style: ed.sans(13, color: ed.ink3)),
      const SizedBox(height: 10),
      Wrap(spacing: 6, runSpacing: 6, children: [
        for (int i = 0; i < qs.length; i++)
          EdReveal(
            delay: Duration(milliseconds: 50 * i),
            rise: 6,
            blur: 4,
            child: _AskChip(
              qs[i].$1,
              state: on == i ? _ChipState.on : (asked.contains(i) ? _ChipState.asked : _ChipState.fresh),
              onTap: () => onAsk(i),
            ),
          ),
      ]),
    ]);
  }
}

enum _ChipState { fresh, on, asked }

class _AskChip extends StatelessWidget {
  final String label;
  final _ChipState state;
  final VoidCallback onTap;
  const _AskChip(this.label, {required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: onTap,
      semanticLabel: label,
      builder: (_, h) {
        final dashed = state == _ChipState.fresh;
        final border = switch (state) {
          _ChipState.on => ed.ink,
          _ChipState.asked => ed.line,
          _ChipState.fresh => h ? ed.ink3 : ed.line2,
        };
        final color = switch (state) {
          _ChipState.on => ed.ink,
          _ChipState.asked => ed.ink3,
          _ChipState.fresh => h ? ed.ink : ed.ink2,
        };
        return CustomPaint(
          foregroundPainter: dashed ? DashedRRectPainter(border) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: dashed ? null : Border.all(color: border),
              color: state == _ChipState.on ? ed.raised : Colors.transparent,
            ),
            child: Text(label, style: ed.sans(13, color: color, h: 1.2)),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  Handwritten margin note with a hand-drawn arrow pointing at the avatar.
// ════════════════════════════════════════════════════════════════════

class _MarginNote extends StatelessWidget {
  final Ed ed;
  const _MarginNote({required this.ed});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        // Arrow flicks back toward the photo on the left.
        Transform.flip(
          flipX: true,
          child: CustomPaint(size: const Size(40, 26), painter: _ArrowPainter(ed.ink3)),
        ),
        const SizedBox(width: 4),
        Transform.rotate(
          angle: -0.05,
          child: Text('psst, that\'s me.\ngo on, poke the photo.', style: ed.hand(14, color: ed.ink3)),
        ),
      ]),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  _ArrowPainter(this.color);
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    // Curving down-and-right, like a pen flick, then an arrowhead.
    final path = Path()
      ..moveTo(2, 4)
      ..cubicTo(14, 2, 30, 8, 36, 22);
    canvas.drawPath(path, p);
    canvas.drawPath(
        Path()
          ..moveTo(28, 19)
          ..lineTo(36, 23)
          ..lineTo(38, 14),
        p);
  }

  @override
  bool shouldRepaint(_ArrowPainter old) => old.color != color;
}
