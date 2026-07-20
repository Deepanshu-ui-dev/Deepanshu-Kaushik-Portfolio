import 'package:flutter/material.dart';

/// Animated terminal-style progress bar in the portfolio accent color.
/// Shows a chunked fill with a pulsing leading edge, staying on-theme
/// with the dot-grid / mono aesthetic used throughout the app.
///
/// Usage:
/// ```dart
/// TerminalProgressBar(progress: 0.75) // 75%
/// ```
class TerminalProgressBar extends StatefulWidget {
  final double progress; // 0.0 – 1.0
  final double height;
  final String? label;
  final bool showPercent;

  const TerminalProgressBar({
    super.key,
    required this.progress,
    this.height = 4.0,
    this.label,
    this.showPercent = false,
  });

  @override
  State<TerminalProgressBar> createState() => _TerminalProgressBarState();
}

class _TerminalProgressBarState extends State<TerminalProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark
        ? const Color(0xFF00FF88)
        : const Color(0xFF007A3D);
    final track = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    final pct = widget.progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null || widget.showPercent) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.label != null)
                Text(
                  widget.label!,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    letterSpacing: 0.5,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.55)
                        : Colors.black.withValues(alpha: 0.45),
                  ),
                ),
              if (widget.showPercent)
                Text(
                  '${(pct * 100).round()}%',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    letterSpacing: 0.5,
                    color: accent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: widget.height,
            child: LayoutBuilder(builder: (context, constraints) {
              final totalW = constraints.maxWidth;
              final fillW = totalW * pct;
              return Stack(
                children: [
                  // Track
                  Container(width: totalW, color: track),
                  // Fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    width: fillW,
                    color: accent.withValues(alpha: 0.85),
                  ),
                  // Pulsing leading edge dot
                  if (pct > 0 && pct < 1)
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) {
                        return Positioned(
                          left: fillW - 2,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 4,
                            decoration: BoxDecoration(
                              color: accent.withValues(
                                alpha: 0.5 + 0.5 * _pulse.value,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// A set of terminal-style progress bars for the skills section.
/// Each bar has a label, value, and percent label.
class TerminalSkillBars extends StatelessWidget {
  final List<SkillBarData> skills;
  final Duration staggerDelay;

  const TerminalSkillBars({
    super.key,
    required this.skills,
    this.staggerDelay = const Duration(milliseconds: 80),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < skills.length; i++) ...[
          _AnimatedSkillBar(
            data: skills[i],
            delay: staggerDelay * i,
          ),
          if (i < skills.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class SkillBarData {
  final String label;
  final double value; // 0.0 – 1.0
  const SkillBarData({required this.label, required this.value});
}

class _AnimatedSkillBar extends StatefulWidget {
  final SkillBarData data;
  final Duration delay;

  const _AnimatedSkillBar({required this.data, required this.delay});

  @override
  State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<_AnimatedSkillBar> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _progress = widget.data.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TerminalProgressBar(
      progress: _progress,
      label: widget.data.label,
      showPercent: true,
      height: 3.5,
    );
  }
}
