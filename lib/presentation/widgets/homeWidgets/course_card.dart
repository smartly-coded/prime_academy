// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:prime_academy/core/helpers/constants.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class CourseCard extends StatelessWidget {
  final String courseName;
  final bool isMobile;
  final String? image;

  const CourseCard({
    Key? key,
    required this.courseName,
    required this.isMobile,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Mycolors.cardColor1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: isMobile ? 80 : 100,
            decoration: BoxDecoration(
              color: Mycolors.darkblue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: (image != null && image!.isNotEmpty)
                ? Center(child: Image.network(image!))
                : const Center(
                    child: Icon(
                      Icons.menu_book,
                      color: Color.fromARGB(224, 255, 170, 0),
                      size: 40,
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffa76433), Color(0xff4f2349)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              courseName,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffa76433), Color(0xff4f2349)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "الذهاب للدورة",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
