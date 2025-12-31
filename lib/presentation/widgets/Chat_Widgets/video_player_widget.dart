import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onDownload;

  const VideoPlayerWidget({super.key, required this.videoUrl, this.onDownload});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Auto-hide controls after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller!.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });

      // Listen to playback state
      _controller!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
      // Auto-hide controls
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _controller!.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
    setState(() {
      _showControls = true;
    });
  }

  void _onTapVideo() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 50),
              SizedBox(height: 8),
              Text(
                'خطأ في تحميل الفيديو',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        height: 200,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    final aspectRatio = _controller!.value.aspectRatio;
    final controller = _controller!;
    double position = _controller!.value.position.inSeconds.toDouble();
    double duration = _controller!.value.duration.inSeconds.toDouble();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: _onTapVideo,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                ),

                
                if (_showControls)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: IconButton(
                        iconSize: 64,
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                  ),

                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.75),
                            Colors.transparent,
                          ],
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDuration(
                                      _controller!.value.position,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _formatDuration(
                                          _controller!.value.duration,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                     
                                      Builder(
                                        builder: (menuContext) {
                                          return IconButton(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () =>
                                                _openOptionsMenu(menuContext),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white38,
                                thumbColor: Colors.white,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 5,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 10,
                                ),
                              ),
                              child: Slider(
                                min: 0,
                                max: duration > 0 ? duration : 1,
                                value: position.clamp(
                                  0,
                                  duration > 0 ? duration : 1,
                                ),
                                onChanged: (value) {
                                  _controller!.seekTo(
                                    Duration(seconds: value.toInt()),
                                  );
                                },
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
      ),
    );
  }

  void _openOptionsMenu(BuildContext buttonContext) async {
    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final result = await showMenu<String>(
      context: buttonContext,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      items: [
        PopupMenuItem(
          value: 'download',
          child: Row(
            children: const [
              Icon(Icons.download, color: Colors.black, size: 18),
              SizedBox(width: 8),
              Text('تنزيل', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'speed',
          child: Row(
            children: const [
              Icon(Icons.speed, color: Colors.black, size: 18),
              SizedBox(width: 8),
              Text('سرعة التشغيل', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ],
    );

    if (result == 'download') {
      _downloadVideo();
    } else if (result == 'speed') {
      _openSpeedMenu(buttonContext);
    }
  }

  void _openSpeedMenu(BuildContext buttonContext) async {
    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final speeds = [0.25, 0.5, 1.0, 1.25, 1.5, 2.0];

    final result = await showMenu<double>(
      context: buttonContext,
      position: position,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: speeds.map((speed) {
        final isSelected = _controller!.value.playbackSpeed == speed;

        return PopupMenuItem<double>(
          value: speed,
          child: Container(
            width: 120,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '${speed}x',
              style: TextStyle(
                color: isSelected ? Colors.grey : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );

    if (result != null) {
      _controller!.setPlaybackSpeed(result);
    }
  }

  void _downloadVideo() {
    if (widget.onDownload != null) {
      widget.onDownload!();
    }
  }
}
