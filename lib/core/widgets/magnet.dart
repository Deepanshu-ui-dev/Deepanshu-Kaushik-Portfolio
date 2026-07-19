import 'package:flutter/material.dart';




class Magnet extends StatefulWidget {
  final Widget child;

  
  
  final double displacement;

  final Duration duration;
  final Curve   curve;

  const Magnet({
    super.key,
    required this.child,
    this.displacement = 0.18,
    this.duration     = const Duration(milliseconds: 200),
    this.curve        = Curves.easeOutCubic,
  });

  @override
  State<Magnet> createState() => _MagnetState();
}

class _MagnetState extends State<Magnet> {
  Offset _target = Offset.zero;

  void _onHover(PointerEvent event) {
    final box  = context.findRenderObject() as RenderBox;
    final size = box.size;
    
    final dx = (event.localPosition.dx / size.width)  - 0.5;
    final dy = (event.localPosition.dy / size.height) - 0.5;
    setState(() {
      _target = Offset(
        dx * size.width  * widget.displacement,
        dy * size.height * widget.displacement,
      );
    });
  }

  void _onExit(PointerEvent event) {
    setState(() => _target = Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit:  _onExit,
      
      child: TweenAnimationBuilder<Offset>(
        tween:    Tween(begin: Offset.zero, end: _target),
        duration: widget.duration,
        curve:    widget.curve,
        builder:  (context, offset, child) {
          return Transform.translate(
            offset: offset,
            child:  child,
          );
        },
        child: widget.child, 
      ),
    );
  }
}