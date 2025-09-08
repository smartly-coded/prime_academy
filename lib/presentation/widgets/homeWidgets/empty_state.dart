import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final bool isMobile;

  const EmptyState({
    super.key,
    required this.message,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1d24),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            color: Colors.white70,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
