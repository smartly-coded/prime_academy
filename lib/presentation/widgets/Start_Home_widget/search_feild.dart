import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class GradientSearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const GradientSearchField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<GradientSearchField> createState() => _GradientSearchFieldState();
}

class _GradientSearchFieldState extends State<GradientSearchField> {
  bool _isFocused = false;

  final Gradient primaryGradient = const LinearGradient(
    colors: [Color(0xff450486), Color(0xffa76433)],
  );

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _isFocused
              ? const LinearGradient(
                  colors: [Color(0xffa76433), Color(0xff450486)],
                )
              : primaryGradient,
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: Mycolors.cardColor1,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "البحث عن طلاب",
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              hintTextDirection: TextDirection.rtl,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
