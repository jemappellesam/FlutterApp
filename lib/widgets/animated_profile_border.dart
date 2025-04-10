import 'package:flutter/material.dart';

class AnimatedProfileBorder extends StatefulWidget {
  final String imageUrl;
  final double radius;
  const AnimatedProfileBorder({super.key, required this.imageUrl, this.radius = 50});

  @override
  State<AnimatedProfileBorder> createState() => _AnimatedProfileBorderState();
}

class _AnimatedProfileBorderState extends State<AnimatedProfileBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation1;
  late Animation<Color?> _colorAnimation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _colorAnimation1 = ColorTween(begin: const Color(0xFF6200EA), end: const Color(0xFF03DAC6)).animate(_controller);
    _colorAnimation2 = ColorTween(begin: const Color(0xFFBB86FC), end: const Color(0xFF018786)).animate(_controller);
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
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [_colorAnimation1.value!, _colorAnimation2.value!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: AssetImage(widget.imageUrl),
          ),
        );
      },
    );
  }
}