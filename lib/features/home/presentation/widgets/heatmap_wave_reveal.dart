import 'package:flutter/material.dart';

class HeatmapWaveReveal extends StatefulWidget {
  final Widget child;
  final int columnIndex;

  const HeatmapWaveReveal({
    super.key,
    required this.child,
    required this.columnIndex,
  });

  @override
  State<HeatmapWaveReveal> createState() => _HeatmapWaveRevealState();
}

class _HeatmapWaveRevealState extends State<HeatmapWaveReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    
    Future.delayed(Duration(milliseconds: widget.columnIndex * 8), () {
      if (mounted) {
        _ctrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Opacity(
        opacity: _fade.value,
        child: Transform.scale(
          scale: _scale.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
