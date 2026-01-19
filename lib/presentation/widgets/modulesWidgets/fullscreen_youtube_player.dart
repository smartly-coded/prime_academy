import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/stable_progress_bar.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/settings_bottom_sheets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullscreenYouTubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool wasPlaying;
  final Duration startPosition;
  final bool isLooping;
  final Function(bool) onLoopChanged;

  const FullscreenYouTubePlayer({
    Key? key,
    required this.controller,
    required this.wasPlaying,
    required this.startPosition,
    required this.isLooping,
    required this.onLoopChanged,
  }) : super(key: key);

  @override
  State<FullscreenYouTubePlayer> createState() =>
      _FullscreenYouTubePlayerState();
}

class _FullscreenYouTubePlayerState extends State<FullscreenYouTubePlayer> {
  bool _isInitialized = false;
  Duration? _lastStablePosition;
  bool _hasSeekedToStart = false;
  bool _showControls = true;
  Timer? _controlsTimer;
  late bool _isLooping;

  @override
  void initState() {
    super.initState();
    _isLooping = widget.isLooping;
    print('🖥️ Entering fullscreen mode');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    widget.controller.addListener(_onPlayerReady);
    widget.controller.addListener(_checkVideoEnd);
  }

  void _checkVideoEnd() {
    if (!mounted) return;

    if (widget.controller.value.playerState == PlayerState.ended) {
      if (_isLooping && mounted) {
        print('🔁 Fullscreen Looping: Video ended, restarting...');
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            widget.controller.seekTo(Duration.zero);
            _lastStablePosition = Duration.zero;
            widget.controller.play();
          }
        });
      }
    }
  }

  void _onPlayerReady() {
    if (!mounted || _isInitialized) return;

    if (widget.controller.value.isReady) {
      _isInitialized = true;
      print('✅ Fullscreen player ready');

      if (!_hasSeekedToStart && widget.startPosition.inSeconds > 0) {
        print(
          '⏩ Seeking to start position: ${widget.startPosition.inSeconds}s',
        );
        widget.controller.seekTo(widget.startPosition);
        _lastStablePosition = widget.startPosition;
        _hasSeekedToStart = true;
      }

      if (widget.wasPlaying) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.controller.play();
            print('▶️ Playing in fullscreen');
            _hideControlsAfterDelay();
          }
        });
      }

      widget.controller.removeListener(_onPlayerReady);
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
      } else {
        widget.controller.play();
      }
    });
    _showControlsTemporarily();
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.controller.value.isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showSettings() {
    showMainSettingsSheet(
      context: context,
      controller: widget.controller,
      isLooping: _isLooping,
      onLoopChanged: (value) {
        setState(() {
          _isLooping = value;
        });
        widget.onLoopChanged(value);
      },
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPlayerReady);
    widget.controller.removeListener(_checkVideoEnd);
    _controlsTimer?.cancel();

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
    final currentPos = _lastStablePosition ?? widget.controller.value.position;
    final isPlaying = widget.controller.value.isPlaying;

    print('🔙 Exiting at ${currentPos.inSeconds}s, playing: $isPlaying');

    Navigator.pop(context, {'position': currentPos, 'wasPlaying': isPlaying});
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
        body: GestureDetector(
          onTap: _showControlsTemporarily,
          child: Stack(
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

              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: _showSettings,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.fullscreen_exit,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: _exitFullscreen,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      Center(
                        child: GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14),
                            child: ValueListenableBuilder<YoutubePlayerValue>(
                              valueListenable: widget.controller,
                              builder: (context, value, child) {
                                return Icon(
                                  value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 42,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: SmoothProgressBar(
                            controller: widget.controller,
                            isFullscreen: true,
                            onSeek: (position) {
                              _lastStablePosition = position;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}