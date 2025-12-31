
// // import 'package:flutter/material.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioWaveformPainter.dart';

// // class AudioWidget extends StatefulWidget {
// //   final dynamic media;
// //   final String fullUrl;
// //   final AudioPlayerManager audioPlayerManager;

// //   const AudioWidget({
// //     super.key,
// //     required this.media,
// //     required this.fullUrl,
// //     required this.audioPlayerManager,
// //   });

// //   @override
// //   State<AudioWidget> createState() => _AudioWidgetState();
// // }

// // class _AudioWidgetState extends State<AudioWidget> {
// //   Duration? _cachedDuration;
// //   bool _isLoadingDuration = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadAudioDuration();
// //   }

// //   Future<void> _loadAudioDuration() async {
// //     if (_cachedDuration != null) return;
// //     if (_isLoadingDuration) return;
    
// //     setState(() {
// //       _isLoadingDuration = true;
// //     });

// //     try {
// //       final player = AudioPlayer();
// //       await player.setSource(UrlSource(widget.fullUrl));
      
// //       // Wait for duration to be available
// //       await Future.delayed(const Duration(milliseconds: 500));
      
// //       final duration = await player.getDuration();
// //       if (duration != null && mounted) {
// //         setState(() {
// //           _cachedDuration = duration;
// //         });
// //       }
      
// //       await player.dispose();
// //     } catch (e) {
// //       print('Error loading audio duration: $e');
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           _isLoadingDuration = false;
// //         });
// //       }
// //     }
// //   }

// //   Duration _getAudioDuration() {
// //     // If we have cached duration, use it
// //     if (_cachedDuration != null) {
// //       return _cachedDuration!;
// //     }
    
// //     // If this audio is currently playing, use player's duration
// //     if (widget.audioPlayerManager.playingAudioUrl == widget.fullUrl && 
// //         widget.audioPlayerManager.audioDuration.inSeconds > 0) {
// //       // Cache it for future use
// //       _cachedDuration = widget.audioPlayerManager.audioDuration;
// //       return widget.audioPlayerManager.audioDuration;
// //     }
    
// //     // Default fallback
// //     return Duration.zero;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isCurrentlyPlaying = widget.audioPlayerManager.isCurrentlyPlaying(widget.fullUrl);
// //     final progress = widget.audioPlayerManager.getProgress(widget.fullUrl);
    
// //     // Use 70% of screen width for audio widget
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final audioWidth = screenWidth * 0.7;
    
// //     final actualDuration = _getAudioDuration();

// //     return Container(
// //       width: audioWidth,
// //       margin: const EdgeInsets.only(top: 8),
// //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.black87,
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
// //       ),
// //       child: Row(
// //         children: [
// //           GestureDetector(
// //             onTap: () => _togglePlayback(context),
// //             child: Container(
// //               width: 40,
// //               height: 40,
// //               decoration: const BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.blue,
// //               ),
// //               child: Icon(
// //                 isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
// //                 color: Colors.white,
// //                 size: 24,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(width: 12),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(
// //                   height: 30,
// //                   child: CustomPaint(
// //                     size: Size.infinite,
// //                     painter: AudioWaveformPainter(progress: progress),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   _getTimeDisplay(actualDuration),
// //                   style: const TextStyle(color: Colors.grey, fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   String _getTimeDisplay(Duration actualDuration) {
// //     // If this audio is currently playing
// //     if (widget.audioPlayerManager.playingAudioUrl == widget.fullUrl) {
// //       return '${widget.audioPlayerManager.formatDuration(widget.audioPlayerManager.audioPosition)} / ${widget.audioPlayerManager.formatDuration(widget.audioPlayerManager.audioDuration)}';
// //     }
    
// //     // If we're loading duration
// //     if (_isLoadingDuration) {
// //       return '...';
// //     }
    
// //     // If we have actual duration, show it
// //     if (actualDuration.inSeconds > 0) {
// //       return widget.audioPlayerManager.formatDuration(actualDuration);
// //     }
    
// //     // Default
// //     return '0:00';
// //   }

// //   Future<void> _togglePlayback(BuildContext context) async {
// //     try {
// //       await widget.audioPlayerManager.togglePlayback(widget.fullUrl);
      
// //       // After playing, cache the duration
// //       if (_cachedDuration == null && 
// //           widget.audioPlayerManager.audioDuration.inSeconds > 0) {
// //         setState(() {
// //           _cachedDuration = widget.audioPlayerManager.audioDuration;
// //         });
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text('خطأ في تشغيل الصوت: $e'),
// //           backgroundColor: Colors.red,
// //         ),
// //       );
// //     }
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioWaveformPainter.dart';

// class AudioWidget extends StatefulWidget {
//   final dynamic media;
//   final String fullUrl;
//   final AudioPlayerManager audioPlayerManager;

//   const AudioWidget({
//     super.key,
//     required this.media,
//     required this.fullUrl,
//     required this.audioPlayerManager,
//   });

//   @override
//   State<AudioWidget> createState() => _AudioWidgetState();
// }

// class _AudioWidgetState extends State<AudioWidget> {
//   Duration? _cachedDuration;
//   bool _isLoadingDuration = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadAudioDuration();
//   }

//   Future<void> _loadAudioDuration() async {
//     if (_cachedDuration != null) return;
//     if (_isLoadingDuration) return;
    
//     setState(() {
//       _isLoadingDuration = true;
//     });

//     try {
//       final player = AudioPlayer();
//       await player.setSource(UrlSource(widget.fullUrl));
      
//       // Wait for duration to be available
//       await Future.delayed(const Duration(milliseconds: 500));
      
//       final duration = await player.getDuration();
//       if (duration != null && mounted) {
//         setState(() {
//           _cachedDuration = duration;
//         });
//       }
      
//       await player.dispose();
//     } catch (e) {
//       print('Error loading audio duration: $e');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingDuration = false;
//         });
//       }
//     }
//   }

//   Duration _getAudioDuration() {
//     // If we have cached duration, use it
//     if (_cachedDuration != null) {
//       return _cachedDuration!;
//     }
    
//     // If this audio is currently playing, use player's duration
//     if (widget.audioPlayerManager.playingAudioUrl == widget.fullUrl && 
//         widget.audioPlayerManager.audioDuration.inSeconds > 0) {
//       // Cache it for future use
//       _cachedDuration = widget.audioPlayerManager.audioDuration;
//       return widget.audioPlayerManager.audioDuration;
//     }
    
//     // Default fallback
//     return Duration.zero;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isCurrentlyPlaying = widget.audioPlayerManager.isCurrentlyPlaying(widget.fullUrl);
//     final progress = widget.audioPlayerManager.getProgress(widget.fullUrl);
    
//     // Use 70% of screen width for audio widget
//     final screenWidth = MediaQuery.of(context).size.width;
//     final audioWidth = screenWidth * 0.7;
    
//     final actualDuration = _getAudioDuration();

//     return Container(
//       width: audioWidth,
//       margin: const EdgeInsets.only(top: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.black87,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => _togglePlayback(context),
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.blue,
//               ),
//               child: Icon(
//                 isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 30,
//                   child: CustomPaint(
//                     size: Size.infinite,
//                     painter: AudioWaveformPainter(progress: progress),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _getTimeDisplay(actualDuration),
//                   style: const TextStyle(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _getTimeDisplay(Duration actualDuration) {
//     // If this audio is currently playing
//     if (widget.audioPlayerManager.playingAudioUrl == widget.fullUrl) {
//       return '${widget.audioPlayerManager.formatDuration(widget.audioPlayerManager.audioPosition)} / ${widget.audioPlayerManager.formatDuration(widget.audioPlayerManager.audioDuration)}';
//     }
    
//     // If we're loading duration
//     if (_isLoadingDuration) {
//       return '...';
//     }
    
//     // If we have actual duration, show it
//     if (actualDuration.inSeconds > 0) {
//       return widget.audioPlayerManager.formatDuration(actualDuration);
//     }
    
//     // Default
//     return '0:00';
//   }

//   Future<void> _togglePlayback(BuildContext context) async {
//     try {
//       await widget.audioPlayerManager.togglePlayback(widget.fullUrl);
      
//       // After playing, cache the duration
//       if (_cachedDuration == null && 
//           widget.audioPlayerManager.audioDuration.inSeconds > 0) {
//         setState(() {
//           _cachedDuration = widget.audioPlayerManager.audioDuration;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('خطأ في تشغيل الصوت: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioWaveformPainter.dart';

class AudioWidget extends StatefulWidget {
  final dynamic media;
  final String fullUrl;
  final AudioPlayerManager audioPlayerManager;

  const AudioWidget({
    super.key,
    required this.media,
    required this.fullUrl,
    required this.audioPlayerManager,
  });

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  Duration? _cachedDuration;
  bool _isLoadingDuration = false;
  List<double>? _waveformData;

  @override
  void initState() {
    super.initState();
    _loadAudioDuration();
    _loadWaveformData();
  }

  Future<void> _loadAudioDuration() async {
    if (_cachedDuration != null) return;
    if (_isLoadingDuration) return;
    
    setState(() {
      _isLoadingDuration = true;
    });

    try {
      final player = AudioPlayer();
      await player.setSource(UrlSource(widget.fullUrl));
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final duration = await player.getDuration();
      if (duration != null && mounted) {
        setState(() {
          _cachedDuration = duration;
        });
      }
      
      await player.dispose();
    } catch (e) {
      print('Error loading audio duration: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDuration = false;
        });
      }
    }
  }

  // Future<void> _loadWaveformData() async {
  //   // ⭐ Try to get waveform data from media metadata
  //   try {
  //     if (widget.media.metadata != null) {
  //       final metadata = widget.media.metadata;
  //       if (metadata is Map && metadata.containsKey('amplitudes')) {
  //         setState(() {
  //           _waveformData = List<double>.from(metadata['amplitudes']);
  //         });
  //         return;
  //       }
  //     }
      
  //     // Check if amplitudes are stored directly
  //     if (widget.media.amplitudes != null) {
  //       setState(() {
  //         _waveformData = List<double>.from(widget.media.amplitudes);
  //       });
  //     }
  //   } catch (e) {
  //     print('Error loading waveform data: $e');
  //   }
  // }
Future<void> _loadWaveformData() async {
  try {
    // حاول من media أولًا
    if (widget.media?.amplitudes != null) {
      setState(() {
        _waveformData = widget.media!.amplitudes;
        _cachedDuration = Duration(seconds: widget.media!.duration ?? 0);
      });
      return;
    }

    // لو مش موجودة → JSON محلي
    final jsonFile = File(widget.fullUrl.replaceAll('.m4a', '.json'));
    if (await jsonFile.exists()) {
      final content = await jsonFile.readAsString();
      final data = jsonDecode(content);
      setState(() {
        _waveformData = List<double>.from(data['amplitudes']);
        _cachedDuration = Duration(seconds: data['duration']);
      });
    }
  } catch (e) {
    print('Error loading local waveform data: $e');
  }
}

  Duration _getAudioDuration() {
    if (_cachedDuration != null) {
      return _cachedDuration!;
    }
    
    if (widget.audioPlayerManager.playingAudioUrl == widget.fullUrl && 
        widget.audioPlayerManager.audioDuration.inSeconds > 0) {
      _cachedDuration = widget.audioPlayerManager.audioDuration;
      return widget.audioPlayerManager.audioDuration;
    }
    
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentlyPlaying = widget.audioPlayerManager.isCurrentlyPlaying(widget.fullUrl);
   
    final screenWidth = MediaQuery.of(context).size.width;
    final audioWidth = screenWidth * 0.7;
    final barWidth = 2.5;
    final spacing = 3.0;
    final totalBars = ((audioWidth - 32) / (barWidth + spacing)).floor(); 
    
    final progress = widget.audioPlayerManager.getProgress(widget.fullUrl, totalBars: totalBars);
    final actualDuration = _getAudioDuration();

    return Container(
      width: audioWidth,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _togglePlayback(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: AudioWaveformPainter(
                      progress: progress,
                      waveformData: _waveformData, 
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTimeDisplay(actualDuration),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeDisplay(Duration actualDuration) {
    if (widget.audioPlayerManager.playingAudioUrl == widget.fullUrl) {
      return '${widget.audioPlayerManager.formatDuration(widget.audioPlayerManager.audioPosition)} / ${widget.audioPlayerManager.formatDuration(widget.audioPlayerManager.audioDuration)}';
    }
    
    if (_isLoadingDuration) {
      return '...';
    }
    
    if (actualDuration.inSeconds > 0) {
      return widget.audioPlayerManager.formatDuration(actualDuration);
    }
    
    return '0:00';
  }

  Future<void> _togglePlayback(BuildContext context) async {
    try {
      await widget.audioPlayerManager.togglePlayback(widget.fullUrl);
      
      if (_cachedDuration == null && 
          widget.audioPlayerManager.audioDuration.inSeconds > 0) {
        setState(() {
          _cachedDuration = widget.audioPlayerManager.audioDuration;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تشغيل الصوت: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}