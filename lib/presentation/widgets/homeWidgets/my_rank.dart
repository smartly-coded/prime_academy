
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
  int currentPage = 1;
  int pageSize = 25;
  int totalPages = 1;

  bool sortByRank = true;
  bool sortCurrentPageByName = false;

  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";

    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";

    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }

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
                      var allRankings = List<RankingModel>.from(
                        rankState.ranks,
                      );

                      if (sortByRank) {
                        allRankings.sort((a, b) => a.rank.compareTo(b.rank));
                        sortCurrentPageByName = false;
                      }

                      totalPages = (allRankings.length / pageSize).ceil();

                      var currentPageItems = allRankings
                          .skip((currentPage - 1) * pageSize)
                          .take(pageSize)
                          .toList();

                      if (!sortByRank && sortCurrentPageByName) {
                        currentPageItems.sort(
                          (a, b) => "${a.firstname} ${a.lastname}".compareTo(
                            "${b.firstname} ${b.lastname}",
                          ),
                        );
                      }

                      final pagedRankings = currentPageItems;

                      return _buildRankingTable(pagedRankings, totalPages);
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

  Widget _buildRankingTable(List<RankingModel> pagedRankings, int totalPages) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161c29),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // PAGINATION
          if (totalPages > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: currentPage > 1
                          ? Colors.white
                          : Colors.white,
                      backgroundColor: const Color(0xFF161c29),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      disabledForegroundColor: Colors.white.withOpacity(0.5),
                    ),
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                    child: const Text("السابق"),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "صفحة $currentPage من $totalPages",
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: currentPage < totalPages
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      backgroundColor: const Color(0xFF151A28),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      disabledForegroundColor: Colors.white,
                    ),
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                    child: const Text("التالي"),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF161c29),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      sortByRank = true;
                      sortCurrentPageByName = false;
                      currentPage = 1;
                    });
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          "الترتيب",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB0B2B8),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        color: Color(0xFFB0B2B8),
                        size: 16,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        sortByRank = false;
                        sortCurrentPageByName = true;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "الاسم",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFB0B2B8),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_upward,
                          color: Color(0xFFB0B2B8),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                  child: Text(
                    "النقاط",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB0B2B8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ...pagedRankings.map((ranking) {
            final int rank = ranking.rank;
            final int points = ranking.points;
            final String name = "${ranking.firstname} ${ranking.lastname}";
            final String? imageUrl = buildImageUrl(ranking.image?.url);

            Color? trophyColor;
            Color? rankBadgeColor;

            if (rank == 1) {
              trophyColor = const Color(0xFFFFD700);
              rankBadgeColor = const Color(0xFFFFD700);
            }
            if (rank == 2) {
              trophyColor = Mycolors.silver;
              rankBadgeColor = Mycolors.silver;
            }
            if (rank == 3) {
              trophyColor = const Color(0xFFFF9933);
              rankBadgeColor = const Color(0xFFFF9933);
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  imageUrl != null && imageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            imageUrl,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.account_circle,
                              color: Colors.white54,
                              size: 26,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          color: Colors.white54,
                          size: 26,
                        ),

                  // const SizedBox(width: 4),
                  SizedBox(
                    width: 70,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: rankBadgeColor ?? Mycolors.lightgrey,
                      child: Text(
                        "$rank",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF2072e0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "$points",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (trophyColor != null)
                            Icon(
                              Icons.emoji_events,
                              color: trophyColor,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
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
        color: const Color(0xFF161c29),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          hint: Text(hint, style: const TextStyle(color: Colors.white70)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: const Color(0xFF2a2d34),
        ),
      ),
    );
  }
}
