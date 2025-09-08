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
      child: Image.asset(assetPath, fit: BoxFit.cover),
    ),
  );
}
