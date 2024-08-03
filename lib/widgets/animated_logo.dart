import 'package:flutter/material.dart';
import 'package:flowlinkapp/widgets/theme_data.dart';

const basicDuration = 6;
const acceleratedDuration = 3;

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
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setDuration(Duration newDuration) {
    setState(() {
      _controller.duration = newDuration;
      _controller.reset();
      _controller.repeat();
    });
  }

  void accelerate(bool accelerate) {
    if (accelerate) {
      setDuration(const Duration(seconds: acceleratedDuration));
    } else {
      setDuration(const Duration(seconds: basicDuration));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Center(
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
          child: ClipOval(
            child: Image.asset('assets/flowlink_logo.png'),
          ),
        ),
      ),
    );
  }
}
