import 'package:flutter/material.dart';

class PlayIconAnimation extends StatefulWidget {
const PlayIconAnimation({super.key});
  @override
  _PlayIconAnimationState createState() => _PlayIconAnimationState();
}

class _PlayIconAnimationState extends State<PlayIconAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 999),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 11, 0, 32).withOpacity(0.8),
      end: const Color.fromARGB(255, 52, 46, 129).withOpacity(0.8),
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          Icons.play_circle_filled,
          size: 60,
          color: _colorAnimation.value,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(3 * size.width / 4, size.height - 40, size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AnimatedProfileBorder extends StatefulWidget {
  final String imageUrl;
  final double radius;
  const AnimatedProfileBorder({super.key, required this.imageUrl, this.radius = 50});
  @override
  _AnimatedProfileBorderState createState() => _AnimatedProfileBorderState();
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