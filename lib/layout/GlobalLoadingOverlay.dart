import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/Utils/GlobalLoadingCubit.dart';

class GlobalLoadingOverlay extends StatefulWidget {
  const GlobalLoadingOverlay({super.key});

  @override
  State<GlobalLoadingOverlay> createState() => _GlobalLoadingOverlayState();
}

class _GlobalLoadingOverlayState extends State<GlobalLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalLoadingCubit, bool>(
      builder: (context, isLoading) {
        if (!isLoading) return const SizedBox.shrink();

        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1220), 
                  Color(0xFF1a1f2e), 
                  Color(0xFF0B1220),
                ],
              ),
            ),
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Opacity(
                              opacity: _glowAnimation.value * 0.5,
                              child: Text(
                                'PRIME',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 8
                                    ..color = const Color(
                                      0xFFF9A44C,
                                    ).withOpacity(0.5)
                                    ..maskFilter = MaskFilter.blur(
                                      BlurStyle.normal,
                                      20 * _glowAnimation.value,
                                    ),
                                ),
                              ),
                            ),

                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFF9A44C),
                                    Color(0xFFFF6B9D),
                                    Color(0xFF8E2DE2),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ).createShader(bounds);
                              },
                              child: Text(
                                'PRIME',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: const Color(
                                        0xFFF9A44C,
                                      ).withOpacity(_glowAnimation.value),
                                      blurRadius: 30,
                                    ),
                                    Shadow(
                                      color: const Color(
                                        0xFF8E2DE2,
                                      ).withOpacity(_glowAnimation.value * 0.8),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                       
                        Stack(
                          children: [
                           
                            Opacity(
                              opacity: _glowAnimation.value * 0.4,
                              child: Text(
                                'Academy',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = const Color(
                                      0xFF8E2DE2,
                                    ).withOpacity(0.5)
                                    ..maskFilter = MaskFilter.blur(
                                      BlurStyle.normal,
                                      15 * _glowAnimation.value,
                                    ),
                                ),
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFF9A44C), 
                                    Color(0xFFFF6B9D),
                                    Color(0xFF8E2DE2),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ).createShader(bounds);
                              },
                              child: Text(
                                'Academy',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: const Color(
                                        0xFF8E2DE2,
                                      ).withOpacity(_glowAnimation.value),
                                      blurRadius: 25,
                                    ),
                                    Shadow(
                                      color: const Color(
                                        0xFFF9A44C,
                                      ).withOpacity(_glowAnimation.value * 0.6),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
