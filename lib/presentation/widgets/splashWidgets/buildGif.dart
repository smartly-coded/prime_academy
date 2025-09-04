import 'package:flutter/material.dart';

Widget buildGifSection(
  BoxConstraints constraints,
  bool isMobile,
  String assetPath,
) {
  return SizedBox(
    height: isMobile ? constraints.maxHeight * 0.7 : 300,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.red[100],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(height: 8),
                  Text(
                    'خطأ في تحميل الصورة',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}
