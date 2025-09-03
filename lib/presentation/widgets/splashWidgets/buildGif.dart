import 'package:flutter/material.dart';

Widget buildGifSection(
  BoxConstraints constraints,
  bool isMobile,
  String gifUrl,
) {
  return SizedBox(
    height: isMobile ? constraints.maxHeight * 0.7 : 300,
    width: double.infinity,

    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        gifUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.red[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  Text(
                    'خطأ في تحميل الصورة',
                    style: TextStyle(color: Colors.red),
                  ),
                  Text('URL: $gifUrl', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
