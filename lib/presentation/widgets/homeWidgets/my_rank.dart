import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';

import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
import 'package:prime_academy/features/ranckingScreen/logic/rank_cubit.dart';
import 'package:prime_academy/features/ranckingScreen/logic/rank_state.dart';
import 'package:prime_academy/features/ranckingScreen/data/models/rankingModel.dart';

class RankingWidget extends StatefulWidget {
  final bool isMobile;
  const RankingWidget({super.key, required this.isMobile});

  @override
  State<RankingWidget> createState() => _RankingWidgetState();
}

class _RankingWidgetState extends State<RankingWidget> {
  String? selectedCourse;
  int? selectedCourseId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error) => Center(child: Text(error)),
          success: (data) {
            final profile = data as StudentProfileResponse;
            final courses = profile.courses ?? [];

            if (selectedCourseId == null && courses.isNotEmpty) {
              selectedCourseId = courses.first.id;
              selectedCourse = courses.first.title ?? "غير معروف";

              context.read<RankCubit>().fetchRanks(selectedCourseId!);
            }

            return Column(
              children: [
                _buildDropdown(
                  value: selectedCourse,
                  items: courses.map((c) => c.title ?? "غير معروف").toList(),
                  hint: "اختر الدورة",
                  onChanged: (value) {
                    setState(() {
                      selectedCourse = value;
                      selectedCourseId = courses
                          .firstWhere((c) => c.title == value)
                          .id;
                    });

                    if (selectedCourseId != null) {
                      context.read<RankCubit>().fetchRanks(selectedCourseId!);
                    }
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<RankCubit, RankState>(
                  builder: (context, rankState) {
                    if (rankState is RankLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (rankState is RankError) {
                      return Center(
                        child: Text(
                          rankState.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (rankState is RankSuccess) {
                      final rankings = rankState.ranks;
                      return _buildRankingTable(rankings);
                    }
                    return const SizedBox();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRankingTable(List<RankingModel> rankings) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Mycolors.cardColor1,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          // رأس الجدول
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Mycolors.cardColor1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40),
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        "الترتيب",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Mycolors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_upward, color: Mycolors.grey, size: 16),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "الاسم",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Mycolors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        color: Mycolors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    "النقاط",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Mycolors.grey,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // محتوى الجدول
          Column(
            children: rankings.map((ranking) {
              final int rank = ranking.rank;
              final int points = ranking.points;
              final String name = "${ranking.firstname} ${ranking.lastname}";
              final String? image = ranking.image?.url;

              // ألوان الكؤوس
              Color? trophyColor;
              if (rank == 1) trophyColor = Mycolors.gold;
              if (rank == 2) trophyColor = Mycolors.silver;
              if (rank == 3) trophyColor = const Color(0xFFcd7f32);

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.06),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[800],
                      child: ClipOval(
                        child: image != null
                            ? Image.network(
                                image,
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  );
                                },
                              )
                            : const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 70,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: (rank == 1)
                            ? Mycolors.gold
                            : (rank == 2)
                            ? Mycolors.silver
                            : (rank == 3)
                            ? const Color(0xFFcd7f32)
                            : Mycolors.lightgrey,
                        child: Text(
                          "$rank",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontWeight: rank == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Mycolors.blue,
                              child: Text(
                                "$points",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (trophyColor != null) ...[
                              Icon(
                                Icons.emoji_events,
                                color: trophyColor,
                                size: 22,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 48,
      decoration: BoxDecoration(
        color: Mycolors.cardColor1,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2a2d34),
        ),
      ),
    );
  }
}
