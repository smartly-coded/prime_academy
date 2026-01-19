import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SmoothProgressBar extends StatefulWidget {
  final YoutubePlayerController controller;
  final Function(Duration)? onSeek;
  final bool isFullscreen;

  const SmoothProgressBar({
    Key? key,
    required this.controller,
    this.onSeek,
    this.isFullscreen = false,
  }) : super(key: key);

  @override
  State<SmoothProgressBar> createState() => _SmoothProgressBarState();
}

class _SmoothProgressBarState extends State<SmoothProgressBar> {
  bool _isDragging = false;
  double _dragValue = 0.0;
  Duration _currentPosition = Duration.zero;
  bool _wasPlayingBeforeDrag = false;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '$minutes:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<YoutubePlayerValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        final duration = value.metaData.duration;
        final position = value.position;

        // Update position smoothly
        if (!_isDragging && mounted) {
          if ((position - _currentPosition).inMilliseconds.abs() > 1000 ||
              position > _currentPosition) {
            _currentPosition = position;
          }
        }

        final displayPosition = _isDragging
            ? Duration(
                milliseconds: (duration.inMilliseconds * _dragValue).round(),
              )
            : _currentPosition;

        final progress = duration.inMilliseconds > 0
            ? (displayPosition.inMilliseconds / duration.inMilliseconds).clamp(
                0.0,
                1.0,
              )
            : 0.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(displayPosition),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (_isDragging)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _formatDuration(displayPosition),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (details) {
                    if (!mounted) return;

                    setState(() {
                      _isDragging = true;
                      _wasPlayingBeforeDrag = widget.controller.value.isPlaying;

                      // Pause video when dragging starts
                      if (_wasPlayingBeforeDrag) {
                        widget.controller.pause();
                      }

                      final position =
                          details.localPosition.dx / constraints.maxWidth;
                      _dragValue = position.clamp(0.0, 1.0);
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    if (_isDragging && mounted) {
                      setState(() {
                        final position =
                            details.localPosition.dx / constraints.maxWidth;
                        _dragValue = position.clamp(0.0, 1.0);
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (!_isDragging || !mounted) return;

                    final seekPosition = Duration(
                      milliseconds: (duration.inMilliseconds * _dragValue)
                          .round(),
                    );

                    _currentPosition = seekPosition;

                    widget.controller.seekTo(seekPosition);
                    widget.onSeek?.call(seekPosition);

                    setState(() {
                      _isDragging = false;
                    });

                    // Resume playing if it was playing before
                    if (_wasPlayingBeforeDrag) {
                      Future.delayed(const Duration(milliseconds: 400), () {
                        if (mounted) {
                          widget.controller.play();
                        }
                      });
                    }
                  },
                  onTapDown: (details) {
                    if (!mounted) return;

                    final wasPlaying = widget.controller.value.isPlaying;
                    final position =
                        details.localPosition.dx / constraints.maxWidth;
                    final tapValue = position.clamp(0.0, 1.0);

                    final seekPosition = Duration(
                      milliseconds: (duration.inMilliseconds * tapValue)
                          .round(),
                    );

                    _currentPosition = seekPosition;

                    widget.controller.seekTo(seekPosition);
                    widget.onSeek?.call(seekPosition);

                    if (wasPlaying) {
                      Future.delayed(const Duration(milliseconds: 400), () {
                        if (mounted) {
                          widget.controller.play();
                        }
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    height: _isDragging ? 44 : 32,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Progress bar positioned at bottom
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: _isDragging ? 30 : 30,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Background track
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeOut,
                                height: _isDragging ? 8 : 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                    _isDragging ? 4 : 3,
                                  ),
                                ),
                              ),

                              // Progress track
                              Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: progress,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    curve: Curves.easeOut,
                                    height: _isDragging ? 8 : 6,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E3A8A),
                                      borderRadius: BorderRadius.circular(
                                        _isDragging ? 4 : 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Thumb/handle - only visible when dragging
                              if (_isDragging)
                                Positioned(
                                  left: (progress * constraints.maxWidth) - 10,
                                  top: -6,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E3A8A),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Time labels - NO space between bar and time
          ],
        );
      },
    );
  }
}
