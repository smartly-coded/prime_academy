import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';

class FileWidget extends StatelessWidget {
  final dynamic media;
  final String fullUrl;
  final FileManager fileManager;
  final DialogHelper dialogHelper;

  const FileWidget({
    super.key,
    required this.media,
    required this.fullUrl,
    required this.fileManager,
    required this.dialogHelper,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = media.mimeType?.contains('pdf') == true;
    final isDoc =
        media.mimeType?.contains('document') == true ||
        media.mimeType?.contains('word') == true;

    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = Colors.orange;

    if (isPdf) {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (isDoc) {
      fileIcon = Icons.description;
      iconColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(fileIcon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  media.filename ?? "ملف",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                if (media.size != null)
                  Text(
                    fileManager.formatFileSize(media.size!),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openFile(context),
            icon: const Icon(Icons.open_in_new, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Future<void> _openFile(BuildContext context) async {
    try {
      if (!fileManager.isValidUrl(fullUrl)) {
        throw 'رابط الملف غير صحيح';
      }

      if (fileManager.canOpenInBrowser(fullUrl)) {
        await fileManager.openInBrowser(fullUrl);
        return;
      }

      dialogHelper.showLoadingDialog();
      final filePath = await fileManager.downloadFile(fullUrl, media.filename);
      Navigator.pop(context);

      final resultType = await fileManager.openLocalFile(filePath);
      if (resultType == ResultType.done) {
        dialogHelper.showSuccess('تم فتح الملف بنجاح');
      } else if (resultType == ResultType.noAppToOpen) {
        dialogHelper.showFileOptionsDialog(filePath);
      } else {
        throw 'لا يمكن فتح الملف';
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      dialogHelper.showError('خطأ في فتح الملف: $e');
    }
  }
}