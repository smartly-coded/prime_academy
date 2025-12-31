// import 'package:audioplayers/audioplayers.dart';

// class AudioPlayerManager {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final Function() onStateChanged;

//   String? _playingAudioUrl;
//   bool _isPlaying = false;
//   Duration _audioDuration = Duration.zero;
//   Duration _audioPosition = Duration.zero;

//   AudioPlayerManager({required this.onStateChanged}) {
//     _setupListeners();
//   }

//   void _setupListeners() {
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       _isPlaying = state == PlayerState.playing;
//       onStateChanged();
//     });

//     _audioPlayer.onDurationChanged.listen((duration) {
//       _audioDuration = duration;
//       onStateChanged();
//     });

//     _audioPlayer.onPositionChanged.listen((position) {
//       _audioPosition = position;
//       onStateChanged();
//     });

//     _audioPlayer.onPlayerComplete.listen((event) {
//       _isPlaying = false;
//       _playingAudioUrl = null;
//       _audioPosition = Duration.zero;
//       onStateChanged();
//     });
//   }

//   bool get isPlaying => _isPlaying;
//   String? get playingAudioUrl => _playingAudioUrl;
//   Duration get audioDuration => _audioDuration;
//   Duration get audioPosition => _audioPosition;

//   bool isCurrentlyPlaying(String url) {
//     return _playingAudioUrl == url && _isPlaying;
//   }

//   double getProgress(String url) {
//     if (_playingAudioUrl == url && _audioDuration.inSeconds > 0) {
//       return _audioPosition.inSeconds / _audioDuration.inSeconds;
//     }
//     return 0.0;
//   }

//   Future<void> togglePlayback(String url) async {
//     if (_playingAudioUrl == url && _isPlaying) {
//       await _audioPlayer.pause();
//     } else if (_playingAudioUrl == url && !_isPlaying) {
//       await _audioPlayer.resume();
//     } else {
//       await _audioPlayer.stop();
//       _playingAudioUrl = url;
//       onStateChanged();
//       await _audioPlayer.play(UrlSource(url));
//     }
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   void dispose() {
//     _audioPlayer.dispose();
//   }
// }

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerManager {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Function() onStateChanged;

  String? _playingAudioUrl;
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  AudioPlayerManager({required this.onStateChanged}) {
    _setupListeners();
  }

  void _setupListeners() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      onStateChanged();
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _audioDuration = duration;
      onStateChanged();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _audioPosition = position;
      onStateChanged();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _playingAudioUrl = null;
      _audioPosition = Duration.zero;
      onStateChanged();
    });
  }

  bool get isPlaying => _isPlaying;
  String? get playingAudioUrl => _playingAudioUrl;
  Duration get audioDuration => _audioDuration;
  Duration get audioPosition => _audioPosition;

  bool isCurrentlyPlaying(String url) {
    return _playingAudioUrl == url && _isPlaying;
  }

  // ⭐ عدلنا الـ progress عشان يحسبها bar-by-bar
  double getProgress(String url, {int? totalBars}) {
    if (_playingAudioUrl != url || _audioDuration.inMilliseconds == 0) {
      return 0.0;
    }
    
    // Calculate progress as percentage
    final progressRatio = _audioPosition.inMilliseconds / _audioDuration.inMilliseconds;
    
    // If we have totalBars, snap to bar boundaries for smoother bar-by-bar animation
    if (totalBars != null && totalBars > 0) {
      final currentBar = (progressRatio * totalBars).floor();
      return currentBar / totalBars;
    }
    
    return progressRatio.clamp(0.0, 1.0);
  }

  Future<void> togglePlayback(String url) async {
    if (_playingAudioUrl == url && _isPlaying) {
      await _audioPlayer.pause();
    } else if (_playingAudioUrl == url && !_isPlaying) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.stop();
      _playingAudioUrl = url;
      onStateChanged();
      await _audioPlayer.play(UrlSource(url));
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}