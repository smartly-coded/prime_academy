// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

// class MessageInputWidget extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onSend;
//   final VoidCallback onStartRecording;
//   final VoidCallback onPickFile;

//   const MessageInputWidget({
//     super.key,
//     required this.controller,
//     required this.onSend,
//     required this.onStartRecording,
//     required this.onPickFile,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 8.0),
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.blue, width: 2),
//             ),
//             child: CircleAvatar(
//               radius: 20,
//               backgroundColor: Mycolors.darkblue,
//               child: IconButton(
//                 icon: const Icon(Icons.send, color: Colors.white),
//                 onPressed: onSend,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.blue, width: 2),
//           ),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundColor: Mycolors.darkblue,
//             child: IconButton(
//               icon: const Icon(Icons.mic, color: Colors.white),
//               onPressed: onStartRecording,
//             ),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Container(
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.blue, width: 2),
//           ),
//           child: CircleAvatar(
//             radius: 20,
//             backgroundColor: Mycolors.darkblue,
//             child: IconButton(
//               icon: const Icon(Icons.attach_file, color: Colors.white),
//               onPressed: onPickFile,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: TextField(
//             controller: controller,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: "اكتب رسالتك...",
//               hintStyle: const TextStyle(color: Colors.grey),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 10,
//               ),
//               filled: true,
//               fillColor: const Color(0xff0d1117),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: const BorderSide(color: Colors.blue),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(20),
//                 borderSide: const BorderSide(color: Colors.blue, width: 2),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class MessageInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onStartRecording;
  final VoidCallback onPickFile;

  const MessageInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onStartRecording,
    required this.onPickFile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, left: 10, right: 10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20),

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

          const SizedBox(width: 5),
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
                icon: const Icon(Icons.mic, color: Colors.white, size: 20),
                onPressed: onStartRecording,
              ),
            ),
          ),
          const SizedBox(width: 5),
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
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: onPickFile,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xff0d1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 1),
              ),
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  // hintText: "اكتب رسالتك...",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
