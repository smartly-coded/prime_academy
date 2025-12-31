// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// import 'package:intl/intl.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/ImageWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/VideoWidget.dart';

// class MessageCardWidget extends StatelessWidget {
//   final MessageModel message;
//   final ChatInfoModel chatInfo;
//   final AudioPlayerManager audioPlayerManager;
//   final FileManager fileManager;
//   final DialogHelper dialogHelper;
//   final Function(MessageModel) onEdit;
//   final Function(int) onDelete;

//   const MessageCardWidget({
//     super.key,
//     required this.message,
//     required this.chatInfo,
//     required this.audioPlayerManager,
//     required this.fileManager,
//     required this.dialogHelper,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   String _formatDateTime(DateTime dateTime) {
//   final localDateTime = dateTime.toLocal();

//   final monthNames = [
//     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//   ];

//   final month = monthNames[localDateTime.month - 1];
//   final day = localDateTime.day;
//   final year = localDateTime.year;

//   final hour = localDateTime.hour == 0
//       ? 12
//       : (localDateTime.hour > 12
//           ? localDateTime.hour - 12
//           : localDateTime.hour);

//   final minute = localDateTime.minute.toString().padLeft(2, '0');
//   final period = localDateTime.hour >= 12 ? 'PM' : 'AM';

//   return '$month $day, $year, $hour:$minute $period';
// }

//   @override
//   Widget build(BuildContext context) {
//     bool isStudent = message.senderRole == 1;
//     String userName = isStudent ? chatInfo.name : "معلم";
//     String role = isStudent ? "طالب" : "معلم";

//     double containerWidth = MediaQuery.of(context).size.width * 0.7;

//     if (message.message.length > 100) {
//       containerWidth = MediaQuery.of(context).size.width * 0.8;
//     }

//     return Align(
//       alignment: isStudent ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(maxWidth: containerWidth),
//         margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Mycolors.cardColor1,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(isStudent, userName, role, context),
//             const SizedBox(height: 6),
//             if (message.message.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: Container(
//                   alignment: isStudent
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//                   height: containerWidth * 0.23,
//                   padding: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     message.message,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             if (message.mediaUrl != null) _buildMedia(containerWidth),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.all(8),
//               alignment: Alignment.centerRight,
//               child: Text(
//                 _formatDateTime(message.createdAt!),
//                 style: const TextStyle(
//                   color: Color.fromARGB(255, 230, 230, 230),
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(
//     bool isStudent,
//     String userName,
//     String role,
//     BuildContext context,
//   ) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: isStudent
//           ? CrossAxisAlignment.end
//           : CrossAxisAlignment.start,
//       children: [
//         if (isStudent)
//           Container(
//             alignment: Alignment.topLeft,
//             height: 10,
//             child: PopupMenuButton<String>(
//               onSelected: (value) {
//                 if (value == 'edit') {
//                   onEdit(message);
//                 } else if (value == 'delete') {
//                   onDelete(message.id!);
//                 }
//               },
//               itemBuilder: (context) => [
//                 const PopupMenuItem(value: 'edit', child: Text("تعديل")),
//                 const PopupMenuItem(value: 'delete', child: Text("حذف")),
//               ],
//               icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
//             ),
//           ),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Row(
//                   children: [
//                     Text(userName, style: const TextStyle(color: Colors.white)),
//                     const SizedBox(width: 6),
//                   ],
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 4,
//                     vertical: 2,
//                   ),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: Mycolors.primary_color.colors,
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     role,
//                     style: const TextStyle(color: Colors.white, fontSize: 13),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 6),
//             if (isStudent)
//               CircleAvatar(
//                 radius: 32,
//                 backgroundImage: _buildProfileImage(chatInfo.imageUrl),
//                 backgroundColor: Colors.grey[800],
//                 child: chatInfo.imageUrl == null || chatInfo.imageUrl!.isEmpty
//                     ? const Icon(Icons.person, color: Colors.white, size: 20)
//                     : null,
//               ),
//           ],
//         ),
//       ],
//     );
//   }

//   ImageProvider? _buildProfileImage(String? imageUrl) {
//     if (imageUrl == null || imageUrl.isEmpty) return null;
//     final fullUrl = fileManager.buildImageUrl(imageUrl);
//     return fileManager.isValidUrl(fullUrl) ? NetworkImage(fullUrl) : null;
//   }

//   Widget _buildMedia(double containerWidth) {
//     if (message.media == null) return const SizedBox.shrink();
//     final media = message.media!;
//     final fullUrl = fileManager.buildImageUrl(media.url);

//     if (media.mimeType?.startsWith('audio/') == true) {
//       return AudioWidget(
//         media: media,
//         fullUrl: fullUrl,
//         audioPlayerManager: audioPlayerManager,
//       );
//     } else if (media.mimeType?.startsWith('image/') == true) {
//       return ImageWidget(
//         fullUrl: fullUrl,
//         fileManager: fileManager,
//         dialogHelper: dialogHelper,
//         containerWidth: containerWidth,
//       );
//     } else if (media.mimeType?.startsWith('video/') == true) {
//       return VideoWidget(
//         media: media,
//         fullUrl: fullUrl,
//         fileManager: fileManager,
//         dialogHelper: dialogHelper,
//       );
//     } else {
//       return FileWidget(
//         media: media,
//         fullUrl: fullUrl,
//         fileManager: fileManager,
//         dialogHelper: dialogHelper,
//       );
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
import 'package:intl/intl.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/ImageWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/VideoWidget.dart';

class MessageCardWidget extends StatelessWidget {
  final MessageModel message;
  final ChatInfoModel chatInfo;
  final AudioPlayerManager audioPlayerManager;
  final FileManager fileManager;
  final DialogHelper dialogHelper;
  final Function(MessageModel) onEdit;
  final Function(int) onDelete;

  const MessageCardWidget({
    super.key,
    required this.message,
    required this.chatInfo,
    required this.audioPlayerManager,
    required this.fileManager,
    required this.dialogHelper,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDateTime(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final month = monthNames[localDateTime.month - 1];
    final day = localDateTime.day;
    final year = localDateTime.year;

    final hour = localDateTime.hour == 0
        ? 12
        : (localDateTime.hour > 12
              ? localDateTime.hour - 12
              : localDateTime.hour);

    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final period = localDateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year, $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    bool isStudent = message.senderRole == 1;

    String userName = isStudent
        ? chatInfo.name
        : (chatInfo.teacherName ?? "Belal Maghraby");
    String? userImageUrl = isStudent
        ? chatInfo.imageUrl
        : chatInfo.teacherImageUrl;
    String role = isStudent ? "طالب" : "معلم";

    double containerWidth = MediaQuery.of(context).size.width * 0.7;

    if (message.message.length > 100) {
      containerWidth = MediaQuery.of(context).size.width * 0.8;
    }

    return Align(
      alignment: isStudent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: containerWidth),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Mycolors.cardColor1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildHeader(isStudent, userName, userImageUrl, role, context),
            const SizedBox(height: 6),
            if (message.message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  alignment: isStudent
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  height: containerWidth * 0.23,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (message.mediaUrl != null) _buildMedia(containerWidth),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: Text(
                _formatDateTime(message.createdAt!),
                style: const TextStyle(
                  color: Color.fromARGB(255, 230, 230, 230),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader(
    bool isStudent,
    String userName,
    String? userImageUrl,
    String role,
    BuildContext context,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end, 
      children: [
        if (isStudent)
          Container(
            alignment: Alignment.topLeft,
            height: 10,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(message);
                } else if (value == 'delete') {
                  onDelete(message.id!);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text("تعديل")),
                const PopupMenuItem(value: 'delete', child: Text("حذف")),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(userName, style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 6),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    SizedBox(width: 40),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: Mycolors.primary_color.colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(width: 6),
            CircleAvatar(
              radius: 32,
              backgroundImage: _buildProfileImage(userImageUrl),
              backgroundColor: Colors.grey[800],
              child:
               userImageUrl == null || userImageUrl.isEmpty
                  ? isStudent
                      ? const Icon(Icons.person, color: Colors.white, size: 20)
                      :  Image.asset('assets/images/teacher.jpeg')
                  //  const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  ImageProvider? _buildProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final fullUrl = fileManager.buildImageUrl(imageUrl);
    return fileManager.isValidUrl(fullUrl) ? NetworkImage(fullUrl) : null;
  }

  Widget _buildMedia(double containerWidth) {
    if (message.media == null) return const SizedBox.shrink();
    final media = message.media!;
    final fullUrl = fileManager.buildImageUrl(media.url);

    if (media.mimeType?.startsWith('audio/') == true) {
      return AudioWidget(
        media: media,
        fullUrl: fullUrl,
        audioPlayerManager: audioPlayerManager,
      );
    } else if (media.mimeType?.startsWith('image/') == true) {
      return ImageWidget(
        fullUrl: fullUrl,
        fileManager: fileManager,
        dialogHelper: dialogHelper,
        containerWidth: containerWidth,
      );
    } else if (media.mimeType?.startsWith('video/') == true) {
      return VideoWidget(
        media: media,
        fullUrl: fullUrl,
        fileManager: fileManager,
        dialogHelper: dialogHelper,
      );
    } else {
      return FileWidget(
        media: media,
        fullUrl: fullUrl,
        fileManager: fileManager,
        dialogHelper: dialogHelper,
      );
    }
  }
}
