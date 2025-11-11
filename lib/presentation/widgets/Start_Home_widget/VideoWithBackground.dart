// import 'package:flutter/material.dart';
// import 'package:prime_academy/presentation/widgets/Start_Home_widget/trophy_section.dart';

// class VideoWithBackground extends StatefulWidget {
//   const VideoWithBackground({super.key});

//   @override
//   State<VideoWithBackground> createState() => _VideoWithBackgroundState();
// }

// class _VideoWithBackgroundState extends State<VideoWithBackground>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.8,
//       width: double.infinity,
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: Transform.scale(
//               scale: 1.2, // تكبير الصورة الخلفية
//               child: Image.asset(
//                 "assets/images/background.jpg",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),

//           Positioned.fill(
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, _) {
//                 double start = _controller.value * 1.2 - 0.2;
//                 double middle = start + 0.15;
//                 double end = middle + 0.15;

//                 return ShaderMask(
//                   shaderCallback: (rect) {
//                     return LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         Colors.white.withOpacity(0),
//                         Colors.white.withOpacity(0.8),
//                         Colors.white.withOpacity(0),
//                       ],
//                       stops: [
//                         start.clamp(0.0, 1.0),
//                         middle.clamp(0.0, 1.0),
//                         end.clamp(0.0, 1.0),
//                       ],
//                     ).createShader(rect);
//                   },
//                   blendMode: BlendMode.srcATop,
//                   child: Transform.scale(
//                     scale: 0.6, // تصغير السهم
//                     alignment: Alignment.center, // المحاذاة من المنتصف
//                     child: Transform.translate(
//                       offset: Offset(
//                         0,
//                         60,
//                       ), // تحريك السهم للأسفل شوية عشان يبدأ من تحت الكأس
//                       child: Image.asset(
//                         "assets/frames/frame_0001.png", // صورة الخط
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           // الطبقة السفلية (Trophy Section)
//           Positioned(
//             bottom: 20,
//             right: 0,
//             child: SafeArea(child: TrophySection()),
//           ),
//         ],
//       ),
//     );
//   }

// }
import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/trophy_section.dart';

class VideoWithBackground extends StatefulWidget {
  const VideoWithBackground({super.key});

  @override
  State<VideoWithBackground> createState() => _VideoWithBackgroundState();
}

class _VideoWithBackgroundState extends State<VideoWithBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none, // عشان ميقصش السهم
        children: [
          // الصورة الخلفية
          Positioned.fill(
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset(
                "assets/images/background.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // السهم المتحرك
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                double start = _controller.value * 1.2 - 0.2;
                double middle = start + 0.15;
                double end = middle + 0.15;

                return ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0),
                      ],
                      stops: [
                        start.clamp(0.0, 1.0),
                        middle.clamp(0.0, 1.0),
                        end.clamp(0.0, 1.0),
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Transform.scale(
                    scale: 0.7,
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(0, 30),
                      child: Image.asset(
                        "assets/frames/frame_0001.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 20,
            right: 0,
            child: SafeArea(child: TrophySection()),
          ),
        ],
      ),
    );
  }
}
