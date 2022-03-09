import 'package:flutter/material.dart';

class RotatableSection extends StatefulWidget {
  final Widget child;
  final bool rotated;
  final double initialSpin;
  final double endingSpin;

  const RotatableSection(
      {Key? key, this.rotated = false, required this.child, this.initialSpin = 0, this.endingSpin = 0.5})
      : super(key: key);

  @override
  _RotatableSectionState createState() => _RotatableSectionState();
}

class _RotatableSectionState extends State<RotatableSection> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: _oneSpin * widget.initialSpin,
      upperBound: _oneSpin * widget.endingSpin,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    _runCheck();
  }

  final double _oneSpin = 6.283184;

  void _runCheck() {
    if (widget.rotated) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(RotatableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runCheck();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (BuildContext context, Widget? _widget) {
        return Transform.rotate(
          angle: animationController.value,
          child: _widget,
        );
      },
    );
  }
}
