import 'package:flutter/material.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 61, 65, 75) : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : const Color(0xFF2a2d34),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2d34),
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
