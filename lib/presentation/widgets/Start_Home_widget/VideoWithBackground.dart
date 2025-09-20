import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/trophy_section.dart';

class VideoWithBackground extends StatefulWidget {
  const VideoWithBackground({super.key});

  @override
  State<VideoWithBackground> createState() => _VideoWithBackgroundState();
}

class _VideoWithBackgroundState extends State<VideoWithBackground> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: _hasError
                ? Image.asset("assets/images/background.jpg", fit: BoxFit.cover)
                : Image.asset(
                    "assets/Gifs/line-mobile.gif",
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame == null) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return child;
                        },
                    errorBuilder: (context, error, stackTrace) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _hasError = true;
                          });
                        }
                      });
                      return Image.asset(
                        "assets/images/background.jpg",
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),

          Positioned(
            bottom: 10,
            right: 10,
            child: SafeArea(child: TrophySection()),
          ),
        ],
      ),
    );
  }
}
