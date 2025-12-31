import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/WaveformPainter.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/media_file_record.dart';

class RecordingUIWidget extends StatelessWidget {
  final int recordingTime;
  final bool isPaused;
  final Animation<double> pulseAnimation;
  final VoidCallback onSend;
  final VoidCallback onTogglePause;
  final VoidCallback onCancel;

  const RecordingUIWidget({
    super.key,
    required this.recordingTime,
    required this.isPaused,
    required this.pulseAnimation,
    required this.onSend,
    required this.onTogglePause,
    required this.onCancel,
  });

  String get _formattedTime {
    final minutes = (recordingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (recordingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          const SizedBox(width: 12),
          // Send button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Mycolors.darkblue,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: onSend,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Recording UI container
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xff0d1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: Row(
                children: [
                  Text(
                    _formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: ValueListenableBuilder<List<double>>(
                        valueListenable:
                            AudioRecorderManager.amplitudesNotifier,
                        builder: (context, amps, _) {
                          return CustomPaint(
                            painter: WaveformPainter(
                              amplitudes: amps,
                              progress: 1.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!isPaused)
                    AnimatedBuilder(
                      animation: pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: pulseAnimation.value,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.3),
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.red,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  if (isPaused)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: const Icon(
                        Icons.mic_off,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Pause/Resume button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: isPaused ? Colors.green : Colors.red,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isPaused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: onTogglePause,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Delete button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[800],
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                onPressed: onCancel,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/live_waveform_painter.dart';

// class RecordingUIWidget extends StatelessWidget {
//   final int recordingTime;
//   final bool isPaused;
//   final List<double> amplitudes;
//   final Animation<double> pulseAnimation;
//   final VoidCallback onSend;
//   final VoidCallback onTogglePause;
//   final VoidCallback onCancel;

//   const RecordingUIWidget({
//     super.key,
//     required this.recordingTime,
//     required this.isPaused,
//     required this.amplitudes,
//     required this.pulseAnimation,
//     required this.onSend,
//     required this.onTogglePause,
//     required this.onCancel,
//   });

//   String get _formattedTime {
//     final minutes = (recordingTime ~/ 60).toString().padLeft(2, '0');
//     final seconds = (recordingTime % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         children: [
//           const SizedBox(width: 12),
//           // Send button
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             child: CircleAvatar(
//               radius: 20,
//               backgroundColor: Mycolors.darkblue,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: const Icon(Icons.send, color: Colors.white, size: 20),
//                 onPressed: onSend,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
          
//           // Recording UI container
//           Expanded(
//             child: Container(
//               height: 45,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: const Color(0xff0d1117),
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue, width: 1),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     _formattedTime,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: SizedBox(
//                       height: 30,
//                       child: CustomPaint(
//                         painter: LiveWaveformPainter(
//                           amplitudes: amplitudes,
//                           isPaused: isPaused,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   if (!isPaused)
//                     AnimatedBuilder(
//                       animation: pulseAnimation,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: pulseAnimation.value,
//                           child: Container(
//                             width: 32,
//                             height: 32,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.red.withOpacity(0.3),
//                             ),
//                             child: const Icon(
//                               Icons.mic,
//                               color: Colors.red,
//                               size: 18,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   if (isPaused)
//                     Container(
//                       width: 32,
//                       height: 32,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.grey.withOpacity(0.3),
//                       ),
//                       child: const Icon(
//                         Icons.mic_off,
//                         color: Colors.grey,
//                         size: 18,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
          
//           // Pause/Resume button
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             child: CircleAvatar(
//               radius: 20,
//               backgroundColor: isPaused ? Colors.green : Colors.red,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: Icon(
//                   isPaused ? Icons.play_arrow : Icons.pause,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 onPressed: onTogglePause,
//               ),
//             ),
//           ),
//           const SizedBox(width: 6),
          
//           // Delete button
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             child: CircleAvatar(
//               radius: 20,
//               backgroundColor: Colors.grey[800],
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 icon: const Icon(Icons.delete, color: Colors.white, size: 20),
//                 onPressed: onCancel,
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//         ],
//       ),
//     );
//   }
// }