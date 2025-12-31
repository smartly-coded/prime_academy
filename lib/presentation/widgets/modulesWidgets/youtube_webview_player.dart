// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:prime_academy/presentation/widgets/modulesWidgets/fullscreen_youtube_player.dart';
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// // class YouTubeWebViewPlayer extends StatefulWidget {
// //   final String videoId;
// //   final bool autoPlay;
// //   final bool showControls;
// //   final VoidCallback? onReady;
// //   final Function(String)? onError;
// //   final Function(Duration position, Duration duration)? onProgress;
// //   final VoidCallback? onVideoEnd;

// //   const YouTubeWebViewPlayer({
// //     Key? key,
// //     required this.videoId,
// //     this.autoPlay = true,
// //     this.showControls = true,
// //     this.onReady,
// //     this.onError,
// //     this.onProgress,
// //     this.onVideoEnd,
// //   }) : super(key: key);

// //   @override
// //   State<YouTubeWebViewPlayer> createState() => YouTubeWebViewPlayerState();
// // }

// // class YouTubeWebViewPlayerState extends State<YouTubeWebViewPlayer> {
// //   late YoutubePlayerController _controller;
// //   bool _isReady = false;
// //   Timer? _progressTimer;
// //   bool _isInFullscreen = false;
// //   bool _showBlackBar = true;
// //   Timer? _blackBarTimer;

// //   @override
// //   void initState() {
// //     super.initState();
// //     print('🎬 Initializing YouTube player for: ${widget.videoId}');

// //     _controller =
// //     // YoutubePlayerController(
// //     //   initialVideoId: widget.videoId,
// //     //   flags: YoutubePlayerFlags(
// //     //     autoPlay: widget.autoPlay,
// //     //     mute: false,
// //     //     enableCaption: false,
// //     //     controlsVisibleAtStart: widget.showControls,
// //     //     hideThumbnail: true,
// //     //     showLiveFullscreenButton: false,
// //     //     forceHD: false,
// //     //     useHybridComposition: true,

// //     //   ),
// //     // );
// //     YoutubePlayerController(
// //   initialVideoId: widget.videoId,
// //   flags: YoutubePlayerFlags(
// //     autoPlay: widget.autoPlay,
// //     mute: false,
// //     controlsVisibleAtStart: false,
// //     hideControls: true,

// //     // modestBranding: true,

// //     disableDragSeek: false,
// //     loop: false,
// //     isLive: false,
// //     forceHD: false,
// //     enableCaption: false,
// //   ),
// // );

// //     _controller.addListener(_playerListener);

// //     // ✅ بعد 10 ثواني نخفي الشريط الأسود
// //     print('⏰ Timer started - black bar will hide after 10 seconds');
// //     _blackBarTimer = Timer(const Duration(seconds: 10), () {
// //       if (mounted) {
// //         setState(() {
// //           _showBlackBar = false;
// //         });
// //         print('✅ Black bar hidden after 10 seconds');
// //       }
// //     });
// //   }

// //   void _playerListener() {
// //     if (!mounted || _isInFullscreen) return;

// //     final state = _controller.value.playerState;

// //     if (!_isReady && state == PlayerState.playing) {
// //       _isReady = true;
// //       widget.onReady?.call();
// //       _startProgressTracking();
// //     }

// //     if (state == PlayerState.ended) {
// //       widget.onVideoEnd?.call();
// //       _progressTimer?.cancel();
// //     }

// //     if (state == PlayerState.playing && _progressTimer == null) {
// //       _startProgressTracking();
// //     } else if (state != PlayerState.playing) {
// //       _progressTimer?.cancel();
// //       _progressTimer = null;
// //     }
// //   }

// //   void _startProgressTracking() {
// //     _progressTimer?.cancel();
// //     _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
// //       if (!mounted || !_controller.value.isReady || _isInFullscreen) return;

// //       final position = _controller.value.position;
// //       final duration = _controller.metadata.duration;

// //       widget.onProgress?.call(position, duration);
// //     });
// //   }

// //   Future<void> _enterFullscreen() async {
// //     if (_isInFullscreen) return;

// //     setState(() {
// //       _isInFullscreen = true;
// //     });

// //     _progressTimer?.cancel();

// //     final currentPosition = _controller.value.position;
// //     final wasPlaying = _controller.value.isPlaying;

// //     print('📍 Entering fullscreen at ${currentPosition.inSeconds}s, playing: $wasPlaying');

// //     final fullscreenController = YoutubePlayerController(
// //       initialVideoId: widget.videoId,
// //       flags: YoutubePlayerFlags(
// //         autoPlay: false,
// //         startAt: currentPosition.inSeconds,
// //         mute: false,
// //         enableCaption: false,
// //         controlsVisibleAtStart: widget.showControls,
// //         hideThumbnail: true,
// //         showLiveFullscreenButton: false,
// //         forceHD: false,
// //         useHybridComposition: true,
// //       ),
// //     );

// //     final returnedData = await Navigator.of(context).push<Map<String, dynamic>>(
// //       MaterialPageRoute(
// //         builder: (context) => FullscreenYouTubePlayer(
// //           controller: fullscreenController,
// //           wasPlaying: wasPlaying,
// //         ),
// //       ),
// //     );

// //     fullscreenController.dispose();

// //     setState(() {
// //       _isInFullscreen = false;
// //     });

// //     if (!mounted) return;

// //     final returnedPosition = returnedData?['position'] as Duration?;
// //     final shouldPlay = returnedData?['wasPlaying'] as bool? ?? wasPlaying;

// //     print('🔙 Returned from fullscreen at ${returnedPosition?.inSeconds ?? 0}s, shouldPlay: $shouldPlay');

// //     if (returnedPosition != null) {
// //       _controller.pause();
// //       await Future.delayed(const Duration(milliseconds: 200));

// //       _controller.seekTo(returnedPosition);
// //       await Future.delayed(const Duration(milliseconds: 400));

// //       if (shouldPlay && mounted) {
// //         _controller.play();
// //         _startProgressTracking();
// //       }
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _progressTimer?.cancel();
// //     _blackBarTimer?.cancel();
// //     _controller.removeListener(_playerListener);
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         // ✅ الـ YouTube Player
// //         YoutubePlayerBuilder(
// //           player: YoutubePlayer(
// //             controller: _controller,
// //             showVideoProgressIndicator: true,
// //             progressIndicatorColor: const Color(0xFF1E3A8A),
// //             progressColors: const ProgressBarColors(
// //               playedColor: Color(0xFF1E3A8A),
// //               handleColor: Color(0xFF1E3A8A),
// //               bufferedColor: Colors.grey,
// //               backgroundColor: Colors.white24,
// //             ),
// //             topActions: const [],
// //             bottomActions: [
// //               CurrentPosition(),
// //               const SizedBox(width: 10),
// //               ProgressBar(
// //                 isExpanded: true,
// //                 colors: const ProgressBarColors(
// //                   playedColor: Color(0xFF1E3A8A),
// //                   handleColor: Color(0xFF1E3A8A),
// //                   bufferedColor: Colors.grey,
// //                   backgroundColor: Colors.white24,
// //                 ),
// //               ),
// //               const SizedBox(width: 10),
// //               RemainingDuration(),
// //               const SizedBox(width: 10),
// //               IconButton(
// //                 icon: const Icon(
// //                   Icons.fullscreen,
// //                   color: Colors.white,
// //                   size: 28,
// //                 ),
// //                 onPressed: _isInFullscreen ? null : _enterFullscreen,
// //               ),
// //             ],
// //             onReady: () {
// //               print('✅ YouTube player ready');
// //             },
// //             onEnded: (metadata) {
// //               print('🏁 Video ended');
// //             },
// //           ),
// //           builder: (context, player) {
// //             return Container(
// //               color: Colors.black,
// //               child: player,
// //             );
// //           },
// //         ),

// //         // ✅ الشريط الأسود في الأسفل (فوق الفيديو مباشرة)
// //         if (_showBlackBar)
// //           Positioned.fill(
// //             child: Align(
// //               alignment: Alignment.bottomCenter,
// //               child: IgnorePointer(
// //                 child: Container(
// //                   height: 80, // ✅ زودت الارتفاع شوية
// //                   width: double.infinity,
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       begin: Alignment.bottomCenter,
// //                       end: Alignment.topCenter,
// //                       colors: [
// //                         Colors.black, // أسود صافي في الأسفل
// //                         Colors.black.withOpacity(0.98),
// //                         Colors.black.withOpacity(0.92),
// //                         Colors.black.withOpacity(0.8),
// //                         Colors.transparent, // شفاف في الأعلى
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //       ],
// //     );
// //   }

// //   // Public methods
// //   Future<void> seekTo(Duration position) async {
// //     if (!_isInFullscreen) {
// //       _controller.seekTo(position);
// //     }
// //   }

// //   Future<void> play() async {
// //     if (!_isInFullscreen) {
// //       _controller.play();
// //     }
// //   }

// //   Future<void> pause() async {
// //     if (!_isInFullscreen) {
// //       _controller.pause();
// //     }
// //   }

// //   bool get isPlaying => _controller.value.isPlaying;
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/fullscreen_youtube_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeWebViewPlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onReady;
  final Function(String)? onError;
  final Function(Duration position, Duration duration)? onProgress;
  final VoidCallback? onVideoEnd;

  const YouTubeWebViewPlayer({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.showControls = true,
    this.onReady,
    this.onError,
    this.onProgress,
    this.onVideoEnd,
  }) : super(key: key);

  @override
  State<YouTubeWebViewPlayer> createState() => YouTubeWebViewPlayerState();
}

class YouTubeWebViewPlayerState extends State<YouTubeWebViewPlayer> {
  late YoutubePlayerController _controller;
  bool _isReady = false;
  Timer? _progressTimer;
  bool _isInFullscreen = false;

  @override
  void initState() {
    super.initState();
    print('🎬 Initializing YouTube player for: ${widget.videoId}');

    _controller =
        // YoutubePlayerController(
        //   initialVideoId: widget.videoId,
        //   flags: YoutubePlayerFlags(
        //     autoPlay: widget.autoPlay,
        //     mute: false,
        //     enableCaption: false,
        //     controlsVisibleAtStart: widget.showControls,
        //     hideThumbnail: true,
        //     showLiveFullscreenButton: false,
        //     forceHD: false,
        //     useHybridComposition: true,
        //   ),
        // );
        YoutubePlayerController(
          initialVideoId: widget.videoId,
          flags: YoutubePlayerFlags(
            // autoPlay: widget.autoPlay,

            mute: false,
            controlsVisibleAtStart: false,

            // hideControls: true,

            // modestBranding: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: false,
          ),
        );
    _controller.addListener(_playerListener);
  }

  void _playerListener() {
    if (!mounted || _isInFullscreen) return;

    final state = _controller.value.playerState;

    if (!_isReady && state == PlayerState.playing) {
      _isReady = true;
      widget.onReady?.call();
      _startProgressTracking();
    }

    if (state == PlayerState.ended) {
      widget.onVideoEnd?.call();
      _progressTimer?.cancel();
    }

    if (state == PlayerState.playing && _progressTimer == null) {
      _startProgressTracking();
    } else if (state != PlayerState.playing) {
      _progressTimer?.cancel();
      _progressTimer = null;
    }
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_controller.value.isReady || _isInFullscreen) return;

      final position = _controller.value.position;
      final duration = _controller.metadata.duration;

      widget.onProgress?.call(position, duration);
    });
  }

  Future<void> _enterFullscreen() async {
    if (_isInFullscreen) return;

    setState(() {
      _isInFullscreen = true;
    });

    _progressTimer?.cancel();

    // ✅ حفظ الحالة الحالية
    final currentPosition = _controller.value.position;
    final wasPlaying = _controller.value.isPlaying;

    print(
      '📍 Entering fullscreen at ${currentPosition.inSeconds}s, playing: $wasPlaying',
    );

    // ✅ إنشاء controller جديد للـ fullscreen
    final fullscreenController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false, // مش هنشغله أوتوماتيك
        startAt: currentPosition.inSeconds, // ✅ نبدأ من الـ position الصحيح
        mute: false,
        enableCaption: false,
        controlsVisibleAtStart: widget.showControls,
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        forceHD: false,
        useHybridComposition: true,
      ),
    );

    final returnedData = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (context) => FullscreenYouTubePlayer(
          controller: fullscreenController,
          wasPlaying: wasPlaying,
        ),
      ),
    );

    // ✅ تنظيف الـ fullscreen controller
    fullscreenController.dispose();

    setState(() {
      _isInFullscreen = false;
    });

    if (!mounted) return;

    // ✅ استعادة الـ position من fullscreen
    final returnedPosition = returnedData?['position'] as Duration?;
    final shouldPlay = returnedData?['wasPlaying'] as bool? ?? wasPlaying;

    print(
      '🔙 Returned from fullscreen at ${returnedPosition?.inSeconds ?? 0}s, shouldPlay: $shouldPlay',
    );

    if (returnedPosition != null) {
      // ✅ نوقف الفيديو، نعمل seek، ثم نشغله
      _controller.pause();
      await Future.delayed(const Duration(milliseconds: 200));

      _controller.seekTo(returnedPosition);
      await Future.delayed(const Duration(milliseconds: 400));

      if (shouldPlay && mounted) {
        _controller.play();
        _startProgressTracking();
      }
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _controller.removeListener(_playerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: const Color(0xFF1E3A8A),
        progressColors: const ProgressBarColors(
          playedColor: Color(0xFF1E3A8A),
          handleColor: Color(0xFF1E3A8A),
          bufferedColor: Colors.grey,
          backgroundColor: Colors.white24,
        ),
        topActions: const [],
        bottomActions: [
          CurrentPosition(),
          const SizedBox(width: 10),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: Color(0xFF1E3A8A),
              handleColor: Color(0xFF1E3A8A),
              bufferedColor: Colors.grey,
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(width: 10),
          RemainingDuration(),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
            onPressed: _isInFullscreen ? null : _enterFullscreen,
          ),
        ],
        onReady: () {
          print('✅ YouTube player ready');
        },
        onEnded: (metadata) {
          print('🏁 Video ended');
        },
      ),
      builder: (context, player) {
        return Container(color: Colors.black, child: player);
      },
    );
  }

  // Public methods
  Future<void> seekTo(Duration position) async {
    if (!_isInFullscreen) {
      _controller.seekTo(position);
    }
  }

  Future<void> play() async {
    if (!_isInFullscreen) {
      _controller.play();
    }
  }

  Future<void> pause() async {
    if (!_isInFullscreen) {
      _controller.pause();
    }
  }

  bool get isPlaying => _controller.value.isPlaying;
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class YouTubeWebViewPlayer extends StatefulWidget {
//   final String videoId;
//   final bool autoPlay;
//   final VoidCallback? onReady;
//   final VoidCallback? onVideoEnd;

//   const YouTubeWebViewPlayer({
//     super.key,
//     required this.videoId,
//     this.autoPlay = false,
//     this.onReady,
//     this.onVideoEnd,
//   });

//   @override
//   State<YouTubeWebViewPlayer> createState() => _YouTubeWebViewPlayerState();
// }

// class _YouTubeWebViewPlayerState extends State<YouTubeWebViewPlayer> {
//   late final WebViewController _controller;
//   bool _isReady = false;

//   @override
//   void initState() {
//     super.initState();

//     final autoplay = widget.autoPlay ? 1 : 0;

//     final html = '''
// <!DOCTYPE html>
// <html>
//   <head>
//     <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     <style>
//       html, body {
//         margin: 0;
//         padding: 0;
//         background: black;
//         height: 100%;
//         overflow: hidden;
//       }
//       iframe {
//         position: absolute;
//         top: 0;
//         left: 0;
//         width: 100%;
//         height: 100%;
//         border: none;
//       }
//     </style>
//   </head>
//   <body>
//     <iframe
//       src="https://www.youtube-nocookie.com/embed/${widget.videoId}
//         ?autoplay=$autoplay
//         &controls=0
//         &modestbranding=1
//         &rel=0
//         &playsinline=1
//         &fs=0
//         &disablekb=1
//         &iv_load_policy=3
//         &mute=0"
//       allow="autoplay; encrypted-media"
//       allowfullscreen="false">
//     </iframe>

//     <script>
//       // جاهزية الفيديو
//       setTimeout(() => {
//         window.flutter_inappwebview?.callHandler('ready');
//       }, 800);
//     </script>
//   </body>
// </html>
// ''';

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.black)
//       ..addJavaScriptChannel(
//         'ready',
//         onMessageReceived: (_) {
//           if (!_isReady) {
//             _isReady = true;
//             widget.onReady?.call();
//           }
//         },
//       )
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (request) {
//             // 🚫 منع فتح يوتيوب خارجي أو الضغط على اللوجو
//             if (request.url.contains('youtube.com')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadHtmlString(html);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 16 / 9,
//       child: WebViewWidget(controller: _controller),
//     );
//   }
// }
