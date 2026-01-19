

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class FullscreenYouTubePlayer extends StatefulWidget {
//   final YoutubePlayerController controller;
//   final bool wasPlaying;

//   const FullscreenYouTubePlayer({
//     Key? key,
//     required this.controller,
//     required this.wasPlaying,
//   }) : super(key: key);

//   @override
//   State<FullscreenYouTubePlayer> createState() =>
//       _FullscreenYouTubePlayerState();
// }

// class _FullscreenYouTubePlayerState extends State<FullscreenYouTubePlayer> {
//   bool _isInitialized = false;
//   bool _isDragging = false;
//   double _dragValue = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     print('🖥️ Entering fullscreen mode');

//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);

//     widget.controller.addListener(_onPlayerReady);
//   }

//   void _onPlayerReady() {
//     if (!mounted || _isInitialized) return;

//     if (widget.controller.value.isReady) {
//       _isInitialized = true;
//       print('✅ Fullscreen player ready');

//       if (widget.wasPlaying) {
//         Future.delayed(const Duration(milliseconds: 300), () {
//           if (mounted) {
//             widget.controller.play();
//             print('▶️ Playing in fullscreen');
//           }
//         });
//       }

//       widget.controller.removeListener(_onPlayerReady);
//     }
//   }

//   @override
//   void dispose() {
//     widget.controller.removeListener(_onPlayerReady);

//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.manual,
//       overlays: SystemUiOverlay.values,
//     );
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     print('🔙 Exiting fullscreen mode');
//     super.dispose();
//   }

//   void _exitFullscreen() {
//     final currentPos = widget.controller.value.position;
//     final isPlaying = widget.controller.value.isPlaying;

//     print('🔙 Exiting at ${currentPos.inSeconds}s, playing: $isPlaying');

//     Navigator.pop(context, {'position': currentPos, 'wasPlaying': isPlaying});
//   }

//   void _onDragStart(double value) {
//     setState(() {
//       _isDragging = true;
//       _dragValue = value;
//     });
//   }

//   void _onDragUpdate(double value) {
//     setState(() {
//       _dragValue = value.clamp(0.0, 1.0);
//     });
//   }

//   void _onDragEnd() {
//     final duration = widget.controller.value.metaData.duration;
//     final newPosition = Duration(
//       milliseconds: (duration.inMilliseconds * _dragValue).round(),
//     );

//     widget.controller.seekTo(newPosition);
//     print('⏩ Seeked to ${newPosition.inSeconds}s');

//     setState(() {
//       _isDragging = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _exitFullscreen();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: [
//             Center(
//               child: AspectRatio(
//                 aspectRatio: 16 / 9,
//                 child: YoutubePlayer(
//                   controller: widget.controller,
//                   showVideoProgressIndicator: false,
//                   topActions: const [],
//                   bottomActions: const [],
//                 ),
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
//                   onPressed: _exitFullscreen,
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

//                   final progress = _isDragging
//                       ? _dragValue
//                       : (duration.inMilliseconds == 0
//                             ? 0.0
//                             : (pos.inMilliseconds / duration.inMilliseconds)
//                                   .clamp(0.0, 1.0)
//                                   .toDouble());

//                   final displayPos = _isDragging
//                       ? Duration(
//                           milliseconds: (duration.inMilliseconds * _dragValue)
//                               .round(),
//                         )
//                       : pos;
//                   final displayRemaining = duration - displayPos;

//                   return Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       LayoutBuilder(
//                         builder: (context, constraints) {
//                           return GestureDetector(
//                             onHorizontalDragStart: (details) {
//                               final localPosition = details.localPosition;
//                               final width = constraints.maxWidth;
//                               _onDragStart(localPosition.dx / width);
//                             },
//                             onHorizontalDragUpdate: (details) {
//                               final localPosition = details.localPosition;
//                               final width = constraints.maxWidth;
//                               _onDragUpdate(localPosition.dx / width);
//                             },
//                             onHorizontalDragEnd: (details) {
//                               _onDragEnd();
//                             },
//                             onTapDown: (details) {
//                               final localPosition = details.localPosition;
//                               final width = constraints.maxWidth;
//                               final tapValue = (localPosition.dx / width).clamp(
//                                 0.0,
//                                 1.0,
//                               );

//                               final newPosition = Duration(
//                                 milliseconds:
//                                     (duration.inMilliseconds * tapValue)
//                                         .round(),
//                               );
//                               widget.controller.seekTo(newPosition);
//                               print('⏩ Tapped to ${newPosition.inSeconds}s');
//                             },
//                             child: Container(
//                               height: 30,
//                               color: Colors.transparent,
//                               child: Center(
                               
//                                 child: Stack(
//                                   clipBehavior: Clip.none,
//                                   children: [
//                                     Container(
//                                       height: 6,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white24,
//                                         borderRadius: BorderRadius.circular(3),
//                                       ),
//                                     ),

//                                     FractionallySizedBox(
//                                       widthFactor: progress,
//                                       child: Container(
//                                         height: 6,
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFF1E3A8A),
//                                           borderRadius: BorderRadius.circular(
//                                             3,
//                                           ),
//                                         ),
//                                       ),
//                                     ),

//                                     Positioned(
//                                       left: progress * constraints.maxWidth - 8,
//                                       top: -5,
//                                       child: Container(
//                                         width: 16,
//                                         height: 16,
//                                         decoration: BoxDecoration(
//                                           color: Color(0xFF1E3A8A),
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(
//                                                 0.3,
//                                               ),
//                                               blurRadius: 6,
//                                               offset: const Offset(0, 2),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '${displayPos.inMinutes}:${(displayPos.inSeconds % 60).toString().padLeft(2, '0')}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             '-${displayRemaining.inMinutes}:${(displayRemaining.inSeconds % 60).toString().padLeft(2, '0')}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
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
