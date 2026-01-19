import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/fullscreen_youtube_player.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/stable_progress_bar.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/settings_bottom_sheets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeWebViewPlayer extends StatefulWidget {
  final String videoId;
  final Duration? initialPosition;
  final bool autoPlay;
  final bool showControls;
  final VoidCallback? onReady;
  final Function(String)? onError;
  final Function(Duration position, Duration duration)? onProgress;
  final VoidCallback? onVideoEnd;

  const YouTubeWebViewPlayer({
    Key? key,
    required this.videoId,
    this.initialPosition,
    this.autoPlay = false,
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
  Duration _lastStablePosition = Duration.zero;
  bool _showControls = true;
  Timer? _controlsTimer;
  bool _isLooping = false;
  bool _showProgressBar = false;

  @override
  void initState() {
    super.initState();
    print('🎬 Initializing YouTube player for: ${widget.videoId}');

    _lastStablePosition = widget.initialPosition ?? Duration.zero;

    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        startAt: widget.initialPosition?.inSeconds ?? 0,
        mute: false,
        controlsVisibleAtStart: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideThumbnail: false,
      ),
    );
    _controller.addListener(_playerListener);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showProgressBar = true;
        });
      }
    });
  }

  void _playerListener() {
    if (!mounted || _isInFullscreen) return;

    final state = _controller.value.playerState;

    if (!_isReady &&
        (state == PlayerState.playing || state == PlayerState.paused)) {
      _isReady = true;
      widget.onReady?.call();
      _startProgressTracking();
    }

    if (state == PlayerState.ended) {
      widget.onVideoEnd?.call();
      _progressTimer?.cancel();

      if (_isLooping && mounted) {
        print('🔁 Looping: Video ended, restarting...');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _controller.seekTo(Duration.zero);
            _lastStablePosition = Duration.zero;
            _controller.play();
            _startProgressTracking();
          }
        });
      }
    }

    if (state == PlayerState.playing && _progressTimer == null) {
      _startProgressTracking();
    } else if (state != PlayerState.playing && state != PlayerState.ended) {
      _progressTimer?.cancel();
      _progressTimer = null;
    }
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();

    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted || !_controller.value.isReady || _isInFullscreen) return;

      final currentPosition = _controller.value.position;
      final duration = _controller.metadata.duration;

      if (currentPosition >= _lastStablePosition) {
        _lastStablePosition = currentPosition;
        widget.onProgress?.call(_lastStablePosition, duration);
      } else {
        final diff = (_lastStablePosition.inSeconds - currentPosition.inSeconds)
            .abs();
        if (diff > 3) {
          _lastStablePosition = currentPosition;
          widget.onProgress?.call(_lastStablePosition, duration);
        }
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
    _showControlsTemporarily();
  }

  void _showControlsTemporarily() {
    if (!mounted) return;

    setState(() {
      _showControls = true;
    });

    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showSettings() {
    showMainSettingsSheet(
      context: context,
      controller: _controller,
      isLooping: _isLooping,
      onLoopChanged: (value) {
        setState(() {
          _isLooping = value;
        });
      },
    );
  }

  Future<void> _enterFullscreen() async {
    if (_isInFullscreen) return;

    setState(() {
      _isInFullscreen = true;
    });

    _progressTimer?.cancel();

    final currentPosition = _lastStablePosition;
    final wasPlaying = _controller.value.isPlaying;

    print('🔍 Entering fullscreen at: ${currentPosition.inSeconds}s');

    final fullscreenController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: false,
        controlsVisibleAtStart: false,
        disableDragSeek: true,
        hideThumbnail: false,
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
          startPosition: currentPosition,
          isLooping: _isLooping,
          onLoopChanged: (value) {
            setState(() {
              _isLooping = value;
            });
          },
        ),
      ),
    );

    fullscreenController.dispose();

    setState(() {
      _isInFullscreen = false;
    });

    if (!mounted) return;

    final returnedPosition = returnedData?['position'] as Duration?;
    final shouldPlay = returnedData?['wasPlaying'] as bool? ?? wasPlaying;

    print(
      '🔙 Returned from fullscreen at ${returnedPosition?.inSeconds ?? 0}s',
    );

    if (returnedPosition != null) {
      _controller.pause();
      await Future.delayed(const Duration(milliseconds: 200));

      _controller.seekTo(returnedPosition);
      _lastStablePosition = returnedPosition;

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
    _controlsTimer?.cancel();
    _controller.removeListener(_playerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showControlsTemporarily,
      child: Container(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: false,
                topActions: const [],
                bottomActions: const [],
              ),

              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                onPressed: _showSettings,
                              ),
                            ],
                          ),
                        ),

                        Center(
                          child: GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: ValueListenableBuilder<YoutubePlayerValue>(
                                valueListenable: _controller,
                                builder: (context, value, child) {
                                  return Icon(
                                    value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 36,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        if (_showProgressBar)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: SmoothProgressBar(
                                    controller: _controller,
                                    isFullscreen: false,
                                    onSeek: (position) {
                                      _lastStablePosition = position;
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    onPressed: _isInFullscreen
                                        ? null
                                        : _enterFullscreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> seekTo(Duration position) async {
    if (!_isInFullscreen) {
      _controller.seekTo(position);
      _lastStablePosition = position;
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

  Duration get currentPosition => _lastStablePosition;
}
