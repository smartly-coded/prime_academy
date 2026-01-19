import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/splashWidgets/build_text_withoutImage.dart';
import 'package:video_player/video_player.dart';

class VideoSection extends StatefulWidget {
  const VideoSection({super.key});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late VideoPlayerController _controller;

  final double fixedOverlap = 20;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash3.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    if (!_controller.value.isInitialized) {
      return Container(
        height: isMobile ? 200 : 400,
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return Transform.translate(
      offset: Offset(0, -fixedOverlap),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.black,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: buildTextWithBorder(
                "في برايم أكاديمي",
                "",
                context,
                containerWidth: width * 0.7,
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: const Text(
                "لاتخاف تنسى \nالفيديوهات عندك، تعيدها متى ما\n !تبي، ومرات قد ما تبي",
                style: TextStyle(
                  fontSize: 26,
                  
                  color: Colors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.end,
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
