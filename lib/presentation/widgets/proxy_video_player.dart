import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prime_academy/services/video_proxy_service.dart';
import 'package:video_player/video_player.dart';
import 'package:prime_academy/core/config/api_config.dart';

class ProxyVideoPlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final VoidCallback? onReady;
  final VoidCallback? onEnded;
  final Function(int)? onTimeUpdate;
  final Function(String)? onError;

  const ProxyVideoPlayer({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.onReady,
    this.onEnded,
    this.onTimeUpdate,
    this.onError,
  }) : super(key: key);

  @override
  State<ProxyVideoPlayer> createState() => ProxyVideoPlayerState();
}

class ProxyVideoPlayerState extends State<ProxyVideoPlayer> {
  VideoPlayerController? _controller;
  final VideoProxyService _proxyService = VideoProxyService(
    baseUrl: ApiConfig.baseUrl,
  );

  bool _isLoading = true;
  bool _showControls = true;
  bool _isInitialized = false;
  bool _isFullScreen = false;
  String? _error;

  Timer? _hideControlsTimer;
  Timer? _progressTimer;
  Timer? _metadataCheckTimer;

  bool _isSeeking = false;
  int _metadataCheckAttempts = 0;
  static const int MAX_METADATA_ATTEMPTS = 20; // 10 seconds max

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
        _metadataCheckAttempts = 0;
      });

      print('🎬 Initializing player for video: ${widget.videoId}');

      // Check server health
      final isHealthy = await _proxyService.checkHealth();
      if (!isHealthy) {
        throw Exception('خطأ: لا يمكن الاتصال بخادم الفيديو');
      }
      print('✅ Server health check passed');

      // Get stream URL (proxy server endpoint)
      final streamUrl = _proxyService.getStreamUrl(
        widget.videoId,
        quality: '720',
      );
      print('📡 Stream URL: $streamUrl');

      // Initialize video player
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(streamUrl),
        httpHeaders: {
          'Accept': '*/*',
          'User-Agent': 'DartFlutterVideoPlayer/1.0',
        },
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      // Add listener
      _controller!.addListener(_videoListener);

      print('⏳ Initializing video controller...');
      await _controller!.initialize();

      if (!mounted) return;

      print('✅ Video controller initialized');
      print('📊 Duration: ${_controller!.value.duration}');
      print('📐 Aspect ratio: ${_controller!.value.aspectRatio}');

      if (_controller!.value.duration.inSeconds == 0) {
        print('⚠️ Waiting for metadata...');
        _waitForMetadata();
      } else {
        _onInitializationSuccess();
      }
    } catch (e) {
      print('❌ Error: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString().replaceAll('Exception: ', '');
      });

      widget.onError?.call(_error ?? 'خطأ غير معروف');
    }
  }

  void _waitForMetadata() {
    _metadataCheckTimer?.cancel();
    _metadataCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      _metadataCheckAttempts++;

      if (!mounted || _controller == null) {
        timer.cancel();
        return;
      }

      print(
        '🔍 Checking metadata... Attempt ${_metadataCheckAttempts}/${MAX_METADATA_ATTEMPTS}',
      );
      print('   Duration: ${_controller!.value.duration}');
      print('   Is buffering: ${_controller!.value.isBuffering}');
      print('   Position: ${_controller!.value.position}');

      if (_controller!.value.duration.inSeconds > 0) {
        print('✅ Metadata received! Duration: ${_controller!.value.duration}');
        timer.cancel();
        _onInitializationSuccess();
      } else if (_metadataCheckAttempts >= MAX_METADATA_ATTEMPTS) {
        print('⚠️ Metadata timeout after ${MAX_METADATA_ATTEMPTS} attempts');
        timer.cancel();
        // Proceed anyway, some streams might work without duration
        _onInitializationSuccess();
      }
    });
  }

  void _onInitializationSuccess() {
    if (!mounted) return;

    setState(() {
      _isInitialized = true;
      _isLoading = false;
    });

    print('🎉 Player ready!');
    print('   Duration: ${_controller!.value.duration}');
    print('   Auto-play: ${widget.autoPlay}');

    // Auto play if requested
    if (widget.autoPlay) {
      _controller!.play();
      print('▶️ Auto-playing video');
    }

    // Start progress tracking
    _startProgressTracking();

    // Notify ready
    widget.onReady?.call();
  }

  void _videoListener() {
    if (!mounted || _controller == null || !_isInitialized) return;

    // Force UI update every frame
    if (!_isSeeking) {
      setState(() {});
    }

    // Check if video ended
    final duration = _controller!.value.duration;
    final position = _controller!.value.position;

    if (duration.inSeconds > 0 &&
        position >= duration - const Duration(seconds: 1)) {
      if (_controller!.value.isPlaying) {
        print('🏁 Video ended');
        widget.onEnded?.call();
      }
    }
  }

  void _startProgressTracking() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_controller != null && _isInitialized && !_isSeeking && mounted) {
        final currentSeconds = _controller!.value.position.inSeconds;
        widget.onTimeUpdate?.call(currentSeconds);
      }
    });
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) {
      print('⚠️ Cannot toggle play/pause - controller not ready');
      return;
    }

    if (_controller!.value.isPlaying) {
      _controller!.pause();
      print('⏸️ Video paused');
    } else {
      _controller!.play();
      print('▶️ Video playing');
    }

    _showControlsTemporarily();
  }

  void _showControlsTemporarily() {
    if (!mounted) return;

    setState(() {
      _showControls = true;
    });

    _hideControlsTimer?.cancel();
    if (_controller?.value.isPlaying ?? false) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isSeeking) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _onSeekStart(double value) {
    if (_controller == null || !_isInitialized) return;

    print('🎯 Seek started at: ${value.toInt()}s');

    _hideControlsTimer?.cancel();

    setState(() {
      _isSeeking = true;
      _showControls = true;
    });
  }

  void _onSeekUpdate(double value) {
    if (_controller == null || !_isInitialized) return;

    // Just update UI, don't actually seek yet
    setState(() {});
  }

  Future<void> _onSeekEnd(double value) async {
    if (_controller == null || !_isInitialized) return;

    print('🎯 Seeking to: ${value.toInt()}s');

    final position = Duration(seconds: value.toInt());

    try {
      await _controller!.seekTo(position);
      print('✅ Seek completed to: ${value.toInt()}s');
    } catch (e) {
      print('❌ Seek error: $e');
    }

    setState(() {
      _isSeeking = false;
    });

    _showControlsTemporarily();
  }

  Future<void> _toggleFullScreen() async {
    if (_isFullScreen) {
      // Exit fullscreen
      Navigator.of(context).pop();

      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      setState(() {
        _isFullScreen = false;
      });
    } else {
      // Enter fullscreen
      setState(() {
        _isFullScreen = true;
      });

      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      // Navigate to fullscreen page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _FullScreenPlayer(
            controller: _controller!,
            onClose: () {
              _toggleFullScreen();
            },
            onPlayPause: _togglePlayPause,
            onSeekStart: _onSeekStart,
            onSeekUpdate: _onSeekUpdate,
            onSeekEnd: _onSeekEnd,
            isSeeking: _isSeeking,
          ),
        ),
      );
    }

    _showControlsTemporarily();
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds == 0) return '00:00';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Duration _getCurrentPosition() {
    if (_controller == null || !_isInitialized) return Duration.zero;
    return _controller!.value.position;
  }

  Duration _getTotalDuration() {
    if (_controller == null || !_isInitialized) return Duration.zero;
    return _controller!.value.duration;
  }

  bool _isPlaying() {
    if (_controller == null || !_isInitialized) return false;
    return _controller!.value.isPlaying;
  }

  Future<void> play() async {
    if (_controller != null && _isInitialized) {
      await _controller!.play();
      print('▶️ Play called externally');
      if (mounted) setState(() {});
    }
  }

  Future<void> pause() async {
    if (_controller != null && _isInitialized) {
      await _controller!.pause();
      print('⏸️ Pause called externally');
      if (mounted) setState(() {});
    }
  }

  Future<void> seekTo(int seconds) async {
    if (_controller != null && _isInitialized) {
      await _controller!.seekTo(Duration(seconds: seconds));
      print('🎯 Seek called externally to: ${seconds}s');
      if (mounted) setState(() {});
    }
  }

  int getCurrentTime() {
    return _getCurrentPosition().inSeconds;
  }

  @override
  void dispose() {
    print('🗑️ Disposing video player');
    _hideControlsTimer?.cancel();
    _progressTimer?.cancel();
    _metadataCheckTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();

    // Reset orientation when disposing
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlayerContent();
  }

  Widget _buildPlayerContent() {
    return GestureDetector(
      onTap: _showControlsTemporarily,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video Player
            if (_isInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),

            // Loading Indicator
            if (_isLoading)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _metadataCheckAttempts > 0
                          ? 'جاري تحميل البيانات... (${_metadataCheckAttempts}/$MAX_METADATA_ATTEMPTS)'
                          : 'جاري تحميل الفيديو...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

            // Buffering Indicator
            if (_isInitialized && _controller!.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),

            // Error Display
            if (_error != null)
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(20),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'خطأ في تشغيل الفيديو',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!.length > 200
                              ? '${_error!.substring(0, 200)}...'
                              : _error!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _error = null;
                            });
                            _initializePlayer();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Custom Controls
            if (_showControls && _isInitialized && _error == null)
              _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    final currentPos = _getCurrentPosition();
    final totalDur = _getTotalDuration();
    final isPlaying = _isPlaying();

    return AnimatedOpacity(
      opacity: _showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.8),
            ],
            stops: const [0.0, 0.2, 0.7, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Bar - Fullscreen button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _toggleFullScreen,
                    icon: Icon(
                      _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            // Center Play/Pause Button
            Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _togglePlayPause,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Progress Bar
                  Row(
                    children: [
                      Text(
                        _formatDuration(currentPos),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 3,
                            activeTrackColor: Colors.red,
                            inactiveTrackColor: Colors.white.withOpacity(0.3),
                            thumbColor: Colors.red,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayColor: Colors.red.withOpacity(0.3),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),
                          child: Slider(
                            value: totalDur.inSeconds > 0
                                ? currentPos.inSeconds.toDouble().clamp(
                                    0.0,
                                    totalDur.inSeconds.toDouble(),
                                  )
                                : 0.0,
                            min: 0,
                            max: totalDur.inSeconds > 0
                                ? totalDur.inSeconds.toDouble()
                                : 1.0,
                            onChangeStart: _onSeekStart,
                            onChanged: _onSeekUpdate,
                            onChangeEnd: _onSeekEnd,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(totalDur),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fullscreen Player Widget
class _FullScreenPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback onClose;
  final VoidCallback onPlayPause;
  final Function(double) onSeekStart;
  final Function(double) onSeekUpdate;
  final Function(double) onSeekEnd;
  final bool isSeeking;

  const _FullScreenPlayer({
    required this.controller,
    required this.onClose,
    required this.onPlayPause,
    required this.onSeekStart,
    required this.onSeekUpdate,
    required this.onSeekEnd,
    required this.isSeeking,
  });

  @override
  State<_FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<_FullScreenPlayer> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_videoListener);
    _showControlsTemporarily();
  }

  void _videoListener() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });

    _hideControlsTimer?.cancel();
    if (widget.controller.value.isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !widget.isSeeking) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inSeconds == 0) return '00:00';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    widget.controller.removeListener(_videoListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _showControlsTemporarily,
        child: Stack(
          children: [
            // Video Player - Full Screen
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),

            // Buffering Indicator
            if (widget.controller.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),

            // Controls Overlay
            if (_showControls)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.2, 0.7, 1.0],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Bar
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: widget.onClose,
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              IconButton(
                                onPressed: widget.onClose,
                                icon: const Icon(
                                  Icons.fullscreen_exit,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Center Play/Pause
                      Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: widget.onPlayPause,
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bottom Controls
                      SafeArea(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Text(
                                _formatDuration(
                                  widget.controller.value.position,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 4,
                                    activeTrackColor: Colors.red,
                                    inactiveTrackColor: Colors.white
                                        .withOpacity(0.3),
                                    thumbColor: Colors.red,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8,
                                    ),
                                    overlayColor: Colors.red.withOpacity(0.3),
                                    overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 16,
                                    ),
                                  ),
                                  child: Slider(
                                    value:
                                        widget
                                                .controller
                                                .value
                                                .duration
                                                .inSeconds >
                                            0
                                        ? widget
                                              .controller
                                              .value
                                              .position
                                              .inSeconds
                                              .toDouble()
                                              .clamp(
                                                0.0,
                                                widget
                                                    .controller
                                                    .value
                                                    .duration
                                                    .inSeconds
                                                    .toDouble(),
                                              )
                                        : 0.0,
                                    min: 0,
                                    max:
                                        widget
                                                .controller
                                                .value
                                                .duration
                                                .inSeconds >
                                            0
                                        ? widget
                                              .controller
                                              .value
                                              .duration
                                              .inSeconds
                                              .toDouble()
                                        : 1.0,
                                    onChangeStart: widget.onSeekStart,
                                    onChanged: widget.onSeekUpdate,
                                    onChangeEnd: widget.onSeekEnd,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _formatDuration(
                                  widget.controller.value.duration,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}
