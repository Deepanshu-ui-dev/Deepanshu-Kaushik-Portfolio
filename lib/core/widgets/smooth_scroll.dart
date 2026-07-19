import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';







class SmoothScroll extends StatefulWidget {
  
  final ScrollController controller;

  
  final Widget child;

  
  final int animationDuration;

  
  final Curve curve;

  const SmoothScroll({
    super.key,
    required this.controller,
    required this.child,
    this.animationDuration = 280,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<SmoothScroll> createState() => _SmoothScrollState();
}

class _SmoothScrollState extends State<SmoothScroll> {
  double _targetOffset = 0.0;
  bool _isAnimating = false;

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (!widget.controller.hasClients) return;

      final double scrollDelta = event.scrollDelta.dy;
      if (scrollDelta == 0) return;

      
      
      
      if (scrollDelta.abs() < 20.0) {
        return; 
      }

      
      GestureBinding.instance.pointerSignalResolver.register(event, (PointerEvent event) {});

      final double maxScroll = widget.controller.position.maxScrollExtent;

      
      
      final double baseOffset = _isAnimating ? _targetOffset : widget.controller.offset;
      _targetOffset = (baseOffset + scrollDelta).clamp(0.0, maxScroll);
      _isAnimating = true;

      widget.controller.animateTo(
        _targetOffset,
        duration: Duration(milliseconds: widget.animationDuration),
        curve: widget.curve,
      ).whenComplete(() {
        
        
        if (mounted && (widget.controller.offset - _targetOffset).abs() < 1.0) {
          _isAnimating = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: _onPointerSignal,
      child: widget.child,
    );
  }
}
