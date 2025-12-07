// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class FullscreenYouTubePlayer extends StatefulWidget {
//   final YoutubePlayerController controller;
//   final Duration startAt;

//   const FullscreenYouTubePlayer({
//     Key? key,
//     required this.controller,
//     required this.startAt,
//   }) : super(key: key);

//   @override
//   State<FullscreenYouTubePlayer> createState() =>
//       _FullscreenYouTubePlayerState();
// }

// class _FullscreenYouTubePlayerState extends State<FullscreenYouTubePlayer> {
//   @override
//   void initState() {
//     super.initState();
//     print('🖥️ Entering fullscreen mode');
//     widget.controller.seekTo(widget.startAt);

//     // Force landscape and hide system UI
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   @override
//   void dispose() {
//     print('🔙 Exiting fullscreen mode');

//     // Restore portrait and show system UI
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: SystemUiOverlay.values,
//     );
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       // onWillPop: () async {
//       //   // Just pop, don't pause the video
//       //   return true;
//       // },
//       onWillPop: () async {
//         final pos = widget.controller.value.position;
//         Navigator.pop(context, pos);
//         return false;
//       },

//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: YoutubePlayer(
//               controller: widget.controller,
//               showVideoProgressIndicator: true,
//               progressIndicatorColor: const Color(0xFF1E3A8A),
//               progressColors: const ProgressBarColors(
//                 playedColor: Color(0xFF1E3A8A),
//                 handleColor: Color(0xFF1E3A8A),
//                 bufferedColor: Colors.grey,
//                 backgroundColor: Colors.white24,
//               ),
//               topActions: [
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     widget.controller.metadata.title,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                   ),
//                 ),
//               ],
// //               bottomActions: [
// //                 // CurrentPosition(),
// //                 ValueListenableBuilder<YoutubePlayerValue>(
// //   valueListenable: widget.controller,
// //   builder: (context, value, child) {
// //     final pos = value.position;
// //     return Text(
// //       "${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}",
// //       style: TextStyle(color: Colors.white),
// //     );
// //   },
// // )
// // ,
// //                 const SizedBox(width: 10),
// //                 ProgressBar(
// //                   isExpanded: true,
// //                   colors: const ProgressBarColors(
// //                     playedColor: Color(0xFF1E3A8A),
// //                     handleColor: Color(0xFF1E3A8A),
// //                     bufferedColor: Colors.grey,
// //                     backgroundColor: Colors.white24,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 RemainingDuration(),
// //                 const SizedBox(width: 10),
// //                 // Exit fullscreen button
// //                 IconButton(
// //                   icon: const Icon(
// //                     Icons.fullscreen_exit,
// //                     color: Colors.white,
// //                     size: 32,
// //                   ),
// //                   // onPressed: () {
// //                   //   Navigator.of(context).pop();
// //                   // },
// //                   onPressed: () async {
// //                     final pos = widget.controller.value.position;
// //                     Navigator.pop(context, pos);
// //                   },
// //                 ),
// //               ],

// bottomActions: [
//   // الوقت الحالي
//   ValueListenableBuilder<YoutubePlayerValue>(
//     valueListenable: widget.controller,
//     builder: (context, value, child) {
//       final pos = value.position;
//       return Text(
//         "${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}",
//         style: const TextStyle(color: Colors.white),
//       );
//     },
//   ),

//   const SizedBox(width: 10),

//   // شريط التقدم البديل
//   Expanded(
//     child: ValueListenableBuilder<YoutubePlayerValue>(
//       valueListenable: widget.controller,
//       builder: (context, value, child) {
//         final progress =
//             value.position.inMilliseconds /
//             value.metaData.duration.inMilliseconds;

//         return LinearProgressIndicator(
//           value: progress.isNaN ? 0 : progress.clamp(0.0, 1.0),
//           minHeight: 5,
//         );
//       },
//     ),
//   ),

//   const SizedBox(width: 10),

//   // الوقت المتبقي
//   ValueListenableBuilder<YoutubePlayerValue>(
//     valueListenable: widget.controller,
//     builder: (context, value, child) {
//       final duration = value.metaData.duration;
//       final pos = value.position;
//       final remaining = duration - pos;

//       return Text(
//         "-${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}",
//         style: const TextStyle(color: Colors.white),
//       );
//     },
//   ),

//   const SizedBox(width: 10),

//   IconButton(
//     icon: const Icon(
//       Icons.fullscreen_exit,
//       color: Colors.white,
//       size: 32,
//     ),
//     onPressed: () {
//       final pos = widget.controller.value.position;
//       Navigator.pop(context, pos);
//     },
//   ),
// ],

//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class FullscreenYouTubePlayer extends StatefulWidget {
//   final YoutubePlayerController controller;
//   final Duration startAt;

//   const FullscreenYouTubePlayer({
//     Key? key,
//     required this.controller,
//     required this.startAt,
//   }) : super(key: key);

//   @override
//   State<FullscreenYouTubePlayer> createState() =>
//       _FullscreenYouTubePlayerState();
// }

// class _FullscreenYouTubePlayerState extends State<FullscreenYouTubePlayer> {
//   bool _hasSeeked = false;
// bool _isDisposed = false;
//   @override
//   void initState() {
//     super.initState();

//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _waitAndSeek();
//     });

//     widget.controller.addListener(_controllerListener);
//   }

//   void _controllerListener() {
//     if (_isDisposed || !mounted) return;
//     if (widget.controller.value.isReady && !_hasSeeked && mounted) {
//       _seekAndPlay();
//     }
//   }

//   void _waitAndSeek() {
//     if (widget.controller.value.isReady && !_hasSeeked) {
//       _seekAndPlay();
//       return;
//     }

//   }

//   void _seekAndPlay() {
//     if (!mounted || _hasSeeked) return;

//     _hasSeeked = true;
//     print('🎯 Seeking to ${widget.startAt.inSeconds}s in fullscreen');

//     // Seek للوقت المطلوب
//     widget.controller.seekTo(widget.startAt);

//     // نضمن التشغيل بعد delay صغير عشان الـ seek يخلص
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (mounted && !widget.controller.value.isPlaying) {
//         widget.controller.play();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _isDisposed = true;
//     widget.controller.removeListener(_controllerListener);

//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//         overlays: SystemUiOverlay.values);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     // ← dispose الـ controller هنا بس ومرة واحدة
//     // widget.controller.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         final currentPos = widget.controller.value.position;
//         Navigator.pop(context, currentPos);
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: [
//             Center(
//               child: YoutubePlayerBuilder(
//                 // onExitFullScreen: () {
//                 //   final pos = widget.controller.value.position;
//                 //   Navigator.pop(context, pos);
//                 // },
//                 player: YoutubePlayer(
//                   controller: widget.controller,
//                   showVideoProgressIndicator: false,
//                   progressColors: const ProgressBarColors(
//                     playedColor: Color(0xFF1E3A8A),
//                     handleColor: Color(0xFF1E3A8A),
//                   ),
//                 ),
//                 builder: (context, player) {
//                   return AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: player,
//                   );
//                 },
//               ),
//             ),

           
//             Positioned(
//               top: 40,
//               right: 20,
//               child: SafeArea(
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.fullscreen_exit,
//                     color: Colors.white,
//                     size: 32,
//                   ),
//                   onPressed: () {
//                     final pos = widget.controller.value.position;
//                     Navigator.pop(context, pos);
//                   },
//                 ),
//               ),
//             ),

//             Positioned(
//               bottom: 40,
//               left: 20,
//               right: 20,
//               child: ValueListenableBuilder<YoutubePlayerValue>(
//                 valueListenable: widget.controller,
//                 builder: (context, value, child) {
//                   final pos = value.position;
//                   final duration = value.metaData.duration;
//                   final remaining = duration - pos;
//                   final progress = duration.inMilliseconds == 0
//                       ? 0.0
//                       : (pos.inMilliseconds / duration.inMilliseconds)
//                             .clamp(0.0, 1.0)
//                             .toDouble();

//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // شريط التقدم
//                       LinearProgressIndicator(
//                         value: progress,
//                         minHeight: 6,
//                         backgroundColor: Colors.white24,
//                         color: const Color(0xFF1E3A8A),
//                       ),
//                       const SizedBox(height: 8),
//                       // الوقت
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             '-${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullscreenYouTubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool wasPlaying;

  const FullscreenYouTubePlayer({
    Key? key,
    required this.controller,
    required this.wasPlaying,
  }) : super(key: key);

  @override
  State<FullscreenYouTubePlayer> createState() =>
      _FullscreenYouTubePlayerState();
}

class _FullscreenYouTubePlayerState extends State<FullscreenYouTubePlayer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    print('🖥️ Entering fullscreen mode');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // ✅ انتظر حتى يكون الـ controller جاهز ثم شغل الفيديو
    widget.controller.addListener(_onPlayerReady);
  }

  void _onPlayerReady() {
    if (!mounted || _isInitialized) return;

    if (widget.controller.value.isReady) {
      _isInitialized = true;
      print('✅ Fullscreen player ready');

      // ✅ شغل الفيديو لو كان شغال قبل كده
      if (widget.wasPlaying) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            widget.controller.play();
            print('▶️ Playing in fullscreen');
          }
        });
      }

      widget.controller.removeListener(_onPlayerReady);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPlayerReady);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    print('🔙 Exiting fullscreen mode');
    super.dispose();
  }

  void _exitFullscreen() {
    final currentPos = widget.controller.value.position;
    final isPlaying = widget.controller.value.isPlaying;

    print('🔙 Exiting at ${currentPos.inSeconds}s, playing: $isPlaying');

    Navigator.pop(context, {
      'position': currentPos,
      'wasPlaying': isPlaying,
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _exitFullscreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: widget.controller,
                  showVideoProgressIndicator: false,
                  topActions: const [],
                  bottomActions: const [],
                ),
              ),
            ),

            // زر الخروج
            Positioned(
              top: 40,
              right: 20,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _exitFullscreen,
                ),
              ),
            ),

            // Progress bar المخصص
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ValueListenableBuilder<YoutubePlayerValue>(
                valueListenable: widget.controller,
                builder: (context, value, child) {
                  final pos = value.position;
                  final duration = value.metaData.duration;
                  final remaining = duration - pos;
                  final progress = duration.inMilliseconds == 0
                      ? 0.0
                      : (pos.inMilliseconds / duration.inMilliseconds)
                            .clamp(0.0, 1.0)
                            .toDouble();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        color: const Color(0xFF1E3A8A),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '-${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}