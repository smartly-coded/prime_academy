import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/video_player_widget.dart';

class VideoWidget extends StatelessWidget {
  final dynamic media;
  final String fullUrl;
  final FileManager fileManager;
  final DialogHelper dialogHelper;

  const VideoWidget({
    super.key,
    required this.media,
    required this.fullUrl,
    required this.fileManager,
    required this.dialogHelper,
  });

  @override
  Widget build(BuildContext context) {
    if (!fileManager.isValidUrl(fullUrl)) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "رابط الفيديو غير صحيح",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    // return VideoPlayerWidget(videoUrl: fullUrl);
    return Center(
      child: SizedBox(
        height: 200,
       
        child: VideoPlayerWidget(
          videoUrl: fullUrl,
          onDownload: () async {
            final filePath = await fileManager.downloadFile(fullUrl, null);

            await fileManager.openLocalFile(filePath);
          },
        ),
      ),
    );
  }
}
