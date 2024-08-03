import 'package:flutter/material.dart';
import 'package:flowlinkapp/widgets/theme_data.dart';

const basicDuration = 6;
const acceleratedDuration = 1;

class AnimatedLogo extends StatefulWidget {
  AnimatedLogo({Key? key}) : super(key: key);

  @override
  AnimatedLogoState createState() => AnimatedLogoState();
}

class AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: basicDuration),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setDuration(Duration newDuration) {
    final double currentProgress = _controller.value;
    _controller.stop();
    _controller.duration = newDuration;
    _controller.forward(from: currentProgress);
    _controller.repeat();
  }

  void accelerate(bool accelerate) {
    final newDuration = accelerate ? Duration(seconds: acceleratedDuration) : Duration(seconds: basicDuration);
    _controller.animateTo(
      _controller.value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    ).then((_) => setDuration(newDuration));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 4,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: RotationTransition(
          turns: _animation,
          child: ClipOval(
            child: Image.asset('assets/flowlink_logo.png'),
          ),
        ),
      ),
    );
  }
}
