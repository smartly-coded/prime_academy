import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  final bool isMobile;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CategoryTabs({
    super.key,
    required this.isMobile,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  Widget _buildCategoryItem(String title, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Mycolors.darkblue : Mycolors.cardColor1,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Color(0xFFF1E6EE) : Color(0xFF817F6B),
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Mycolors.cardColor1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryItem("الدورات الملتحق بها", selectedIndex == 0, 0),
            _buildCategoryItem("الجوائز", selectedIndex == 1, 1),
            _buildCategoryItem("تصنيفي الحالي", selectedIndex == 2, 2),
          ],
        ),
      ),
    );
  }
}
