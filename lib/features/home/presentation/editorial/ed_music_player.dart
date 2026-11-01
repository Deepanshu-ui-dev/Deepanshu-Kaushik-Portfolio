import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/portfolio_config.dart';
import 'ed_primitives.dart';
import 'ed_theme.dart';

/// Turntable-style "Now Playing" card. The audio asset is only loaded on the
/// first press of play, so it costs nothing on initial page load.
class EdMusicPlayer extends StatefulWidget {
  const EdMusicPlayer({super.key});

  @override
  State<EdMusicPlayer> createState() => _EdMusicPlayerState();
}

class _EdMusicPlayerState extends State<EdMusicPlayer>
    with SingleTickerProviderStateMixin {
  final _player = AudioPlayer();
  late final AnimationController _spin =
      AnimationController(vsync: this, duration: const Duration(seconds: 4));
  final List<StreamSubscription> _subs = [];

  bool _loaded = false;
  bool _loading = false;
  bool _playing = false;
  bool _failed = false;
  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;

  static const _track = PortfolioConfig.nowPlaying;

  @override
  void initState() {
    super.initState();
    _subs.add(_player.positionStream.listen((p) {
      if (mounted) setState(() => _pos = p);
    }));
    _subs.add(_player.durationStream.listen((d) {
      if (mounted && d != null) setState(() => _dur = d);
    }));
    _subs.add(_player.playerStateStream.listen((s) {
      if (!mounted) return;
      if (s.processingState == ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
      final playing = s.playing && s.processingState != ProcessingState.completed;
      if (playing != _playing) {
        setState(() => _playing = playing);
        playing ? _spin.repeat() : _spin.stop();
      }
    }));
  }

  Future<void> _toggle() async {
    if (_failed || _loading) return;
    if (!_loaded) {
      setState(() => _loading = true);
      try {
        await _player.setAsset(_track.asset);
        _loaded = true;
      } catch (_) {
        if (mounted) setState(() => _failed = true);
        return;
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
    _playing ? _player.pause() : _player.play();
  }

  void _nudge(int seconds) {
    if (!_loaded) return;
    var t = _pos + Duration(seconds: seconds);
    if (t < Duration.zero) t = Duration.zero;
    if (_dur > Duration.zero && t > _dur) t = _dur;
    _player.seek(t);
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _spin.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final progress =
        _dur.inMilliseconds == 0 ? 0.0 : (_pos.inMilliseconds / _dur.inMilliseconds).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Turntable(spin: _spin, playing: _playing, onTap: _toggle),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(_failed ? 'UNAVAILABLE' : 'NOW PLAYING',
                    style: ed.mono(9, ls: 1.4)),
                const SizedBox(width: 8),
                _EqBars(active: _playing, color: ed.ink2),
              ]),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_track.title,
                            style: ed.sans(13.5, color: ed.ink, w: FontWeight.w500, h: 1.3),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(_track.artist,
                            style: ed.mono(10, color: ed.ink2),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  _CtrlIcon(LucideIcons.skipBack, 'Back 10 seconds', () => _nudge(-10)),
                  const SizedBox(width: 6),
                  Hover(
                    onTap: _toggle,
                    semanticLabel: _playing ? 'Pause' : 'Play',
                    builder: (_, h) => AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: h ? ed.ink : Colors.transparent,
                        border: Border.all(color: ed.ink, width: 1.2),
                      ),
                      child: _loading
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircularProgressIndicator(strokeWidth: 1.4, color: h ? ed.paper : ed.ink),
                            )
                          : Icon(_playing ? LucideIcons.pause : LucideIcons.play,
                              size: 14, color: h ? ed.paper : ed.ink),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _CtrlIcon(LucideIcons.skipForward, 'Forward 10 seconds', () => _nudge(10)),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(builder: (context, c) {
                void seekTo(double dx) {
                  if (!_loaded || _dur == Duration.zero) return;
                  final f = (dx / c.maxWidth).clamp(0.0, 1.0);
                  _player.seek(Duration(milliseconds: (_dur.inMilliseconds * f).round()));
                }

                return MouseRegion(
                  cursor: _loaded ? SystemMouseCursors.click : MouseCursor.defer,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (d) => seekTo(d.localPosition.dx),
                    onHorizontalDragUpdate: (d) => seekTo(d.localPosition.dx),
                    child: SizedBox(
                      height: 12,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(height: 1.5, color: ed.line2),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(height: 1.5, color: ed.ink),
                          ),
                          Align(
                            alignment: Alignment(progress * 2 - 1, 0),
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(color: ed.ink, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_fmt(_pos), style: ed.mono(9.5)),
                  Text(_dur == Duration.zero ? '--:--' : _fmt(_dur), style: ed.mono(9.5)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CtrlIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _CtrlIcon(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Tooltip(
      message: label,
      waitDuration: const Duration(milliseconds: 500),
      child: Hover(
        onTap: onTap,
        semanticLabel: label,
        builder: (_, h) => Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 13, color: h ? ed.ink : ed.ink2),
        ),
      ),
    );
  }
}

class _Turntable extends StatelessWidget {
  final AnimationController spin;
  final bool playing;
  final VoidCallback onTap;
  const _Turntable({required this.spin, required this.playing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    return Hover(
      onTap: onTap,
      semanticLabel: playing ? 'Pause record' : 'Play record',
      builder: (_, h) => SizedBox(
        width: 84,
        height: 84,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 2,
              top: 6,
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: ed.dark ? 0.6 : 0.35),
                      blurRadius: h ? 22 : 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: RotationTransition(
                  turns: spin,
                  child: CustomPaint(painter: _VinylPainter(label: ed.dark ? const Color(0xFFE4E4E7) : const Color(0xFFF4F4F5))),
                ),
              ),
            ),
            // Tonearm swings onto the record while playing.
            Positioned(
              right: 0,
              top: 0,
              child: AnimatedRotation(
                turns: playing ? 0.07 : 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                alignment: const Alignment(0.6, -0.8),
                child: CustomPaint(
                  size: const Size(22, 46),
                  painter: _ArmPainter(ed.ink3, ed.ink2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VinylPainter extends CustomPainter {
  final Color label;
  const _VinylPainter({required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFF0E0E10));
    final groove = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = Colors.white.withValues(alpha: 0.06);
    for (double g = r * 0.42; g < r * 0.97; g += 2.2) {
      canvas.drawCircle(c, g, groove);
    }
    // Light catching the grooves — rotates with the disc.
    final sheen = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: 0.14),
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: 0),
          Colors.white.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.08, 0.18, 0.5, 0.58, 0.68],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawCircle(c, r * 0.96, sheen);
    canvas.drawCircle(c, r * 0.34, Paint()..color = label);
    canvas.drawCircle(
        c,
        r * 0.34,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6
          ..color = Colors.black26);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r * 0.22), -math.pi * 0.9, math.pi * 0.5, false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.black38);
    canvas.drawCircle(c, 2.2, Paint()..color = const Color(0xFF0E0E10));
  }

  @override
  bool shouldRepaint(_VinylPainter old) => old.label != label;
}

class _ArmPainter extends CustomPainter {
  final Color arm;
  final Color pivot;
  const _ArmPainter(this.arm, this.pivot);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = arm
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final top = Offset(size.width * 0.8, 4);
    final elbow = Offset(size.width * 0.75, size.height * 0.62);
    final head = Offset(size.width * 0.2, size.height - 4);
    canvas.drawLine(top, elbow, p);
    canvas.drawLine(elbow, head, p);
    canvas.drawCircle(top, 3.4, Paint()..color = pivot);
    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: head, width: 6, height: 4), const Radius.circular(1)),
        Paint()..color = pivot);
  }

  @override
  bool shouldRepaint(_ArmPainter old) => old.arm != arm || old.pivot != pivot;
}

/// Three tiny bars that bounce while audio is playing.
class _EqBars extends StatefulWidget {
  final bool active;
  final Color color;
  const _EqBars({required this.active, required this.color});

  @override
  State<_EqBars> createState() => _EqBarsState();
}

class _EqBarsState extends State<_EqBars> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void didUpdateWidget(covariant _EqBars old) {
    super.didUpdateWidget(old);
    if (widget.active && !_c.isAnimating) _c.repeat();
    if (!widget.active && _c.isAnimating) _c.animateTo(0, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          final t = _c.value * 2 * math.pi + i * 1.7;
          final h = widget.active ? 3 + (math.sin(t) + 1) * 3.5 : 2.0;
          return Container(
            width: 2,
            height: h,
            margin: const EdgeInsets.only(right: 1.5),
            color: widget.color,
          );
        }),
      ),
    );
  }
}
