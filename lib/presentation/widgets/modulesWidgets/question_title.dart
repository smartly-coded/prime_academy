import 'package:flutter/material.dart';

Widget questionTitle(String questionTitle) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.4),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Text(
      _cleanHtmlText(questionTitle),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Cairo',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

String _cleanHtmlText(String htmlText) {
  return htmlText
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
}
