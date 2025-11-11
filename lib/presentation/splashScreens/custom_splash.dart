import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_academy/presentation/splashScreens/splash_controller_screen.dart';
import 'package:prime_academy/layout/app_layout.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  final Random _random = Random();
  late List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = List.generate(40, (_) => _Star());
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // انتظار بسيط لعرض الانيميشن
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;

    if (!hasSeenSplash) {
      // أول مرة → عرض شاشات السبلاتش كلها
      await prefs.setBool('hasSeenSplash', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashControllerScreen()),
      );
    } else {
      // المرات التالية → الذهاب مباشرة لـ AppLayout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppLayout()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0F3890), Color(0xFF1B202F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            ..._stars.map((star) => star.buildStar()),
            Center(
              child: Image.asset(
                'assets/images/footer-logo.webp',
                width: 250,
                height: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Star {
  late double left;
  late double top;
  late double size;
  late int duration;

  _Star() {
    final Random random = Random();
    left = random.nextDouble() * 400;
    top = random.nextDouble() * 800;
    size = random.nextDouble() * 2 + 1;
    duration = random.nextInt(2000) + 1000;
  }

  Widget buildStar() {
    return Positioned(
      left: left,
      top: top,
      child: _TwinklingStar(size: size, duration: duration),
    );
  }
}

class _TwinklingStar extends StatefulWidget {
  final double size;
  final int duration;

  const _TwinklingStar({required this.size, required this.duration});

  @override
  State<_TwinklingStar> createState() => _TwinklingStarState();
}

class _TwinklingStarState extends State<_TwinklingStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    )..repeat(reverse: true);
    _opacity = Tween(begin: 0.1, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
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
