
// class RecordingBottomSheet extends StatefulWidget {
//   const RecordingBottomSheet({Key? key}) : super(key: key);

//   @override
//   State<RecordingBottomSheet> createState() => _RecordingBottomSheetState();
// }

// class _RecordingBottomSheetState extends State<RecordingBottomSheet> {
//   bool _isRecording = false;
//   int _recordingTime = 0;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted && _isRecording) {
//         setState(() {
//           _recordingTime++;
//         });
//         _startTimer();
//       }
//     });
//   }

//   String get _formattedTime {
//     final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
//     final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Color(0xff1c2128),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.mic,
//             size: 64,
//             color: _isRecording ? Colors.red : Colors.grey,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _isRecording ? _formattedTime : '00:00',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.red,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context, null);
//                   },
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: _isRecording ? Colors.red : Colors.blue,
//                 child: IconButton(
//                   icon: Icon(
//                     _isRecording ? Icons.stop : Icons.mic,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                   onPressed: () async {
//                     if (_isRecording) {
//                       // إيقاف التسجيل وإنشاء ملف
//                       final directory = await getTemporaryDirectory();
//                       final timestamp = DateTime.now().millisecondsSinceEpoch;
//                       final filePath =
//                           '${directory.path}/recording_$timestamp.m4a';
//                       final file = File(filePath);
//                       await file.writeAsBytes(
//                         List.generate(1000, (index) => index % 256),
//                       );
//                       Navigator.pop(context, file);
//                     } else {
//                       setState(() {
//                         _isRecording = true;
//                       });
//                     }
//                   },
//                 ),
//               ),
//               CircleAvatar(
//                 radius: 25,
//                 backgroundColor: _isRecording ? Colors.green : Colors.grey,
//                 child: IconButton(
//                   icon: const Icon(Icons.send, color: Colors.white),
//                   onPressed: _isRecording
//                       ? () async {
//                           final directory = await getTemporaryDirectory();
//                           final timestamp =
//                               DateTime.now().millisecondsSinceEpoch;
//                           final filePath =
//                               '${directory.path}/recording_$timestamp.m4a';
//                           final file = File(filePath);
//                           await file.writeAsBytes(
//                             List.generate(1000, (index) => index % 256),
//                           );
//                           Navigator.pop(context, file);
//                         }
//                       : null,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
class RecordingBottomSheet extends StatefulWidget {
  const RecordingBottomSheet({super.key});

  @override
  State<RecordingBottomSheet> createState() => _RecordingBottomSheetState();
}

class _RecordingBottomSheetState extends State<RecordingBottomSheet> {
  bool _isRecording = false;
  int _recordingTime = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRecording) {
        setState(() {
          _recordingTime++;
        });
        _startTimer();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xff1c2128),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mic,
            size: 64,
            color: _isRecording ? Colors.red : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _isRecording ? _formattedTime : '00:00',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
                child: IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (_isRecording) {
                      // إيقاف التسجيل وإنشاء ملف
                      final directory = await getTemporaryDirectory();
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final filePath =
                          '${directory.path}/recording_$timestamp.m4a';
                      final file = File(filePath);
                      await file.writeAsBytes(
                        List.generate(1000, (index) => index % 256),
                      );
                      Navigator.pop(context, file);
                    } else {
                      setState(() {
                        _isRecording = true;
                      });
                    }
                  },
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: _isRecording ? Colors.green : Colors.grey,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _isRecording
                      ? () async {
                          final directory = await getTemporaryDirectory();
                          final timestamp =
                              DateTime.now().millisecondsSinceEpoch;
                          final filePath =
                              '${directory.path}/recording_$timestamp.m4a';
                          final file = File(filePath);
                          await file.writeAsBytes(
                            List.generate(1000, (index) => index % 256),
                          );
                          Navigator.pop(context, file);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}