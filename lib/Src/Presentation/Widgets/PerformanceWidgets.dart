import 'package:flutter/material.dart';

class BlinkingWidget extends StatefulWidget {
  final bool isBelowRequirement;
  final Widget child;

  const BlinkingWidget(
      {super.key, required this.isBelowRequirement, required this.child});

  @override
  _BlinkingWidgetState createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.isBelowRequirement
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  (_controller.value > 0.5)
                      ? Colors.red.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8),
                  BlendMode.modulate,
                ),
                child: widget.child,
              )
            : widget.child;
      },
    );
  }
}

class BlinkingWidget1 extends StatefulWidget {
  final bool isBelowRequirement;
  final Widget child;

  const BlinkingWidget1(
      {super.key, required this.isBelowRequirement, required this.child});

  @override
  _BlinkingWidget1State createState() => _BlinkingWidget1State();
}

class _BlinkingWidget1State extends State<BlinkingWidget1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.isBelowRequirement
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(
                  (_controller.value > 0.5) ? Colors.red : Colors.white,
                  BlendMode.modulate,
                ),
                child: widget.child,
              )
            : widget.child;
      },
    );
  }
}
