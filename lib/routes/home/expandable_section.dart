import 'package:flutter/material.dart';

class ExpandableSection extends StatefulWidget {
  final Widget child;
  final bool expand;

  const ExpandableSection({Key? key, this.expand = false, required this.child}) : super(key: key);

  @override
  _ExpandableSectionState createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    sizeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    opacityAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.slowMiddle,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (widget.expand) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: opacityAnimation,
        child: SizeTransition(axisAlignment: 1.0, sizeFactor: sizeAnimation, child: widget.child));
  }
}
