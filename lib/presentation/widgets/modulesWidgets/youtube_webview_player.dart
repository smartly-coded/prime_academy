// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:prime_academy/presentation/widgets/modulesWidgets/fullscreen_youtube_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class YouTubeWebViewPlayer extends StatefulWidget {
//   final String videoId;
//   final bool autoPlay;
//   final bool showControls;
//   final VoidCallback? onReady;
//   final Function(String)? onError;
//   final Function(Duration position, Duration duration)? onProgress;
//   final VoidCallback? onVideoEnd;

//   const YouTubeWebViewPlayer({
//     Key? key,
//     required this.videoId,
//     this.autoPlay = true,
//     this.showControls = true,
//     this.onReady,
//     this.onError,
//     this.onProgress,
//     this.onVideoEnd,
//   }) : super(key: key);

//   @override
//   State<YouTubeWebViewPlayer> createState() => YouTubeWebViewPlayerState();
// }

// class YouTubeWebViewPlayerState extends State<YouTubeWebViewPlayer> {
//   late YoutubePlayerController _controller;
//   bool _isReady = false;
//   Timer? _progressTimer;
// // bool _isInFullscreen = false;
//   @override
//   void initState() {
//     super.initState();
//     print('🎬 Initializing YouTube player for: ${widget.videoId}');
    
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: YoutubePlayerFlags(
//         autoPlay: widget.autoPlay,
//         mute: false,
//         enableCaption: false,
//         controlsVisibleAtStart: widget.showControls,
//         hideThumbnail: true,
//         showLiveFullscreenButton: false,
//         forceHD: false,
//         useHybridComposition: true,
//       ),
//     );

//     _controller.addListener(_playerListener);
//   }

//   void _playerListener() {
//     if (!mounted) return;

//     final state = _controller.value.playerState;
    
//     if (!_isReady && state == PlayerState.playing) {
//       _isReady = true;
//       widget.onReady?.call();
//       _startProgressTracking();
//     }

//     if (state == PlayerState.ended) {
//       widget.onVideoEnd?.call();
//       _progressTimer?.cancel();
//     }

//     if (state == PlayerState.playing && _progressTimer == null) {
//       _startProgressTracking();
//     } else if (state != PlayerState.playing) {
//       _progressTimer?.cancel();
//       _progressTimer = null;
//     }
//   }

//   void _startProgressTracking() {
//     _progressTimer?.cancel();
//     _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted || !_controller.value.isReady) return;

//       final position = _controller.value.position;
//       final duration = _controller.metadata.duration;

//       widget.onProgress?.call(position, duration);
//     });
//   }


// Future<void> _enterFullscreen() async {
//   final currentPosition = _controller.value.position;

//   final returnedPosition = await Navigator.of(context).push<Duration>(
//     MaterialPageRoute(
//       builder: (context) => FullscreenYouTubePlayer(
//         controller: _controller,
//         startAt: currentPosition,
//       ),
//     ),
//   );

//   if (!mounted) return;

//   if (returnedPosition != null) {
//     _controller.seekTo(returnedPosition);
//     if (!_controller.value.isPlaying) {
//       _controller.play();
//     }
//   }

//   // ← أضف السطر ده: نوقف الـ WebView مؤقتًا عشان ما يبعتش رسايل بعد الرجوع
//   _controller.pause();
// }


// //   Future<void> _enterFullscreen() async {
// //   final currentPosition = _controller.value.position;

// //   final returnedPosition = await Navigator.of(context).push<Duration>(
// //     MaterialPageRoute(
// //       builder: (context) => FullscreenYouTubePlayer(
// //         controller: _controller,
// //         startAt: currentPosition,
// //       ),
// //     ),
// //   );

// //   if (!mounted) return;

// //   if (returnedPosition != null) {
// //     _controller.seekTo(returnedPosition);
// //     if (!_controller.value.isPlaying) {
// //       _controller.play();
// //     }
// //   }
// // }

//   @override
//   @override
// void dispose() {
//   _progressTimer?.cancel();

//   // نعمل dispose هنا بس، لما الصفحة تتدمر فعلاً (مش لما نطلع من فول سكرين)
//   _controller.removeListener(_playerListener); // مهم جدًا
//   _controller.dispose();

//   super.dispose();
// }
//   // void dispose() {
//   //   _progressTimer?.cancel();

//   //   // ← الحل السحري: ما نعملش dispose إلا لو مش في الفول سكرين
//   //   // if (!_isInFullscreen) {
//   //   //   _controller.dispose();
//   //   // }
//   //   // لو كنا في الفول سكرين، الـ FullscreenYouTubePlayer هي اللي هتعمل dispose لما تطلع

//   //   super.dispose();
//   // }
//   // ✅ Enter fullscreen WITHOUT restarting video
//   // Future<void> _enterFullscreen() async {
//   //   // Save current position and playing state
//   //   final currentPosition = _controller.value.position;
//   //   final wasPlaying = _controller.value.isPlaying;
    
//   //   print('📍 Saving position: ${currentPosition.inSeconds}s, playing: $wasPlaying');

//   //   // Navigate to fullscreen
//   //   await Navigator.of(context).push(
//   //     MaterialPageRoute(
//   //       builder: (context) => FullscreenYouTubePlayer(
//   //         controller: _controller,
//   //       ),
//   //     ),
//   //   );

//   //   // After returning from fullscreen, ensure video continues from same position
//   //   print('🔙 Returned from fullscreen');
    
//   //   if (mounted) {
//   //     // Small delay to ensure controller is ready
//   //     await Future.delayed(const Duration(milliseconds: 300));
      
//   //     // Restore position if needed
//   //     if (_controller.value.position != currentPosition) {
//   //       _controller.seekTo(currentPosition);
//   //     }
      
//   //     // Resume playing if it was playing before
//   //     if (wasPlaying && !_controller.value.isPlaying) {
//   //       _controller.play();
//   //     }
//   //   }
//   // }
// // Future<void> _enterFullscreen() async {
// //   final currentPosition = _controller.value.position;
// //   print('📍 Entering fullscreen at ${currentPosition.inSeconds}s');

// //   final returnedPosition = await Navigator.of(context).push<Duration>(
// //     MaterialPageRoute(
// //       builder: (context) => FullscreenYouTubePlayer(
// //         controller: _controller,  // نفس الـ controller
// //         startAt: currentPosition,
// //       ),
// //     ),
// //   );

// //   // لما نرجع، نضمن الـ position والتشغيل
// //   if (returnedPosition != null && mounted) {
// //     print('🔙 Returned from fullscreen at ${returnedPosition.inSeconds}s');
// //     _controller.seekTo(returnedPosition);
// //     if (!_controller.value.isPlaying) {
// //       _controller.play();

// //     }
// //   }
// // }

// //   @override
// //   void dispose() {
// //     _progressTimer?.cancel();
// //     _controller.dispose();
// //     super.dispose();
// //   }

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerBuilder(
//       player: YoutubePlayer(
//         controller: _controller,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: const Color(0xFF1E3A8A),
//         progressColors: const ProgressBarColors(
//           playedColor: Color(0xFF1E3A8A),
//           handleColor: Color(0xFF1E3A8A),
//           bufferedColor: Colors.grey,
//           backgroundColor: Colors.white24,
//         ),
//         topActions: const [],
//         bottomActions: [
//           CurrentPosition(),
//           const SizedBox(width: 10),
//           ProgressBar(
//             isExpanded: true,
//             colors: const ProgressBarColors(
//               playedColor: Color(0xFF1E3A8A),
//               handleColor: Color(0xFF1E3A8A),
//               bufferedColor: Colors.grey,
//               backgroundColor: Colors.white24,
//             ),
//           ),
//           const SizedBox(width: 10),
//           RemainingDuration(),
//           const SizedBox(width: 10),
//           IconButton(
//             icon: const Icon(
//               Icons.fullscreen,
//               color: Colors.white,
//               size: 28,
//             ),
//             onPressed: _enterFullscreen,
//           ),
//         ],
//         onReady: () {
//           print('✅ YouTube player ready');
//         },
//         onEnded: (metadata) {
//           print('🏁 Video ended');
//         },
//       ),
//       builder: (context, player) {
//         return Container(
//           color: Colors.black,
//           child: player,
//         );
//       },
//     );
//   }

//   // Public methods
//   Future<void> seekTo(Duration position) async {
//     _controller.seekTo(position);
//   }

//   Future<void> play() async {
//     _controller.play();
//   }

//   Future<void> pause() async {
//     _controller.pause();
//   }

//   bool get isPlaying => _controller.value.isPlaying;
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
    
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        enableCaption: false,
        controlsVisibleAtStart: widget.showControls,
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        forceHD: false,
        useHybridComposition: true,
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

    print('📍 Entering fullscreen at ${currentPosition.inSeconds}s, playing: $wasPlaying');

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

    print('🔙 Returned from fullscreen at ${returnedPosition?.inSeconds ?? 0}s, shouldPlay: $shouldPlay');

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
            icon: const Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 28,
            ),
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
        return Container(
          color: Colors.black,
          child: player,
        );
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