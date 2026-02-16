import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final int delayMs;

  const FadeIn({super.key, required this.child, this.delayMs = 0});

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _a = CurvedAnimation(parent: _c, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _a, child: widget.child);
  }
}
