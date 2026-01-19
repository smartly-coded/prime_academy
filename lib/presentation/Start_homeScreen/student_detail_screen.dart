
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/startScreen/data/models/student_preview_response.dart';
import 'package:prime_academy/features/startScreen/logic/student_preview_cubit.dart';
import 'package:prime_academy/features/startScreen/logic/student_preview_state.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/widgets/Start_Home_widget/preview_header.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';

class StudentDetailScreen extends StatefulWidget {
  final int studentId;
  const StudentDetailScreen({super.key, required this.studentId});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late PageController _pageController;
  Timer? _autoScrollTimer;

  int trophiesLength = 1;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    context.read<StudentPreviewCubit>().emitProfilePreviewState(
      widget.studentId,
    );

    _pageController = PageController(viewportFraction: 0.7);

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients && trophiesLength > 1) {
        _currentPage++;
        final nextPage = _currentPage % trophiesLength;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: CustomAppBar(
        user: null,
        showNotificationIcon: false,
        onLogoPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppLayout(user: null)),
          (route) => false,
        ), showBackArrow: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: isMobile ? 15 : width * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isMobile ? 20 : 30),

              BlocBuilder<StudentPreviewCubit, StudentPreviewState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox(),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error) =>
                        EmptyState(message: "خطأ: $error", isMobile: isMobile),
                    success: (data) {
                      final profile = data as StudentPreviewResponse;
                      final trophies = profile.trophies ?? [];

                     
                      trophiesLength = trophies.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PreviewHeader(response: profile),
                          const SizedBox(height: 100),

                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: trophies.isEmpty
                                  ? Mycolors.backgroundColor
                                  : Mycolors.cardColor1,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: trophies.isEmpty
                                ? Container(color: Mycolors.backgroundColor)
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 120,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xff3D57E9),
                                              Color(0xffff9933),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.emoji_events,
                                              color: Colors.amber,
                                              size: 30,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "عدد الجوائز : ${trophies.length}",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 50),

                                      SizedBox(
                                        height: isMobile ? 220 : 250,
                                        child: PageView.builder(
                                          controller: _pageController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: trophies.length,
                                          itemBuilder: (context, index) {
                                            final trophy = trophies[index];
                                            final imageUrl = _buildImageUrl(
                                              trophy.image.url,
                                            );

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Mycolors.cardColor1,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    16,
                                                                  ),
                                                              topRight:
                                                                  Radius.circular(
                                                                    16,
                                                                  ),
                                                            ),
                                                        child:
                                                            imageUrl.isNotEmpty
                                                            ? Image.network(
                                                                imageUrl,
                                                                fit: BoxFit
                                                                    .cover,
                                                                width: double
                                                                    .infinity,
                                                                errorBuilder: (_, __, ___) => Container(
                                                                  color: Colors
                                                                      .grey[200],
                                                                  child: const Icon(
                                                                    Icons
                                                                        .broken_image,
                                                                    size: 40,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                color: Colors
                                                                    .grey[200],
                                                                child: const Icon(
                                                                  Icons
                                                                      .emoji_events,
                                                                  size: 40,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8,
                                                            ),
                                                        child: Center(
                                                          child: Text(
                                                            trophy.name ??
                                                                "بدون اسم",
                                                            style: TextStyle(
                                                              color:
                                                                  Mycolors.gold,
                                                              fontSize: isMobile
                                                                  ? 14
                                                                  : 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return "";
  if (imagePath.startsWith('http')) return imagePath;
  const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
  return imagePath.startsWith('/')
      ? "$cdnPrefix$imagePath"
      : "$cdnPrefix/$imagePath";
}
