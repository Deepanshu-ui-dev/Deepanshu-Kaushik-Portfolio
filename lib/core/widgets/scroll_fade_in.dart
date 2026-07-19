import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';







class ScrollFadeIn extends StatefulWidget {
  final Widget child;

  
  final Duration delay;

  
  final double slideBegin;

  const ScrollFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideBegin = 0.035,
  });

  @override
  State<ScrollFadeIn> createState() => _ScrollFadeInState();
}

class _ScrollFadeInState extends State<ScrollFadeIn>
    with SingleTickerProviderStateMixin {
  
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  
  
  bool _animated = false;

  @override
  void initState() {
    super.initState();

    
    _ctrl = AnimationController.unbounded(vsync: this)..value = 0.0;

    
    
    
    
    _opacity = _ClampedTween(begin: 0.0, end: 1.0).animate(_ctrl);

    
    _slide = _ctrl.drive(
      Tween<Offset>(
        begin: Offset(0, widget.slideBegin),
        end: Offset.zero,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    
    
    if (!_animated) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAnimate());
    }
  }

  void _maybeAnimate() {
    if (_animated || !mounted) return;

    
    
    final tickerEnabled = TickerMode.of(context);
    if (!tickerEnabled) return;

    _animated = true;

    void runSpring() {
      if (!mounted) return;
      _ctrl.animateWith(
        SpringSimulation(
          const SpringDescription(
            mass: 0.5,
            stiffness: 200,
            damping: 18,
          ),
          0.0, 
          1.0, 
          0.0, 
        ),
      );
    }

    if (widget.delay == Duration.zero) {
      runSpring();
    } else {
      Future.delayed(widget.delay, runSpring);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    
    
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}









class _ClampedTween extends Tween<double> {
  _ClampedTween({required super.begin, required super.end});

  @override
  double transform(double t) => super.transform(t.clamp(0.0, 1.0));
}
