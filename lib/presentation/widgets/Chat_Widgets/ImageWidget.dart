import 'package:flutter/material.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';

class ImageWidget extends StatelessWidget {
  final String fullUrl;
  final FileManager fileManager;
  final DialogHelper dialogHelper;
  final double containerWidth;

  const ImageWidget({
    super.key,
    required this.fullUrl,
    required this.fileManager,
    required this.dialogHelper,
    required this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (!fileManager.isValidUrl(fullUrl)) {
      return Container(
        width: containerWidth,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(top: 8, left: 10, right: 12),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.red, size: 50),
        ),
      );
    }

    return Container(
      width: containerWidth,
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(top: 8, left: 10, right: 12),
      child: GestureDetector(
        onTap: () => dialogHelper.showFullScreenImage(
          fullUrl,
          fileManager.buildImageUrl,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            fullUrl,
            width: containerWidth,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.red, size: 50),
              ),
            ),
          ),
        ),
      ),
    );
  }
}