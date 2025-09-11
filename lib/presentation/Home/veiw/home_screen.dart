import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/constants.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_cubit.dart';
import 'package:prime_academy/features/profileScreen/logic/profile_state.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/category_tabs.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/course_card.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/empty_state.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/logout_button.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/my_rank.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/profile_header.dart';
import 'package:prime_academy/presentation/widgets/homeWidgets/reward_box.dart';

class HomePage extends StatefulWidget {
  final LoginResponse user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  void initState() {
    context.read<ProfileCubit>().emitprofileState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Mycolors.backgroundColor,
        elevation: 0,
        title: Image.asset("assets/images/footer-logo.webp", height: 40),
        actions: [
          Container(
            padding: EdgeInsets.all(2),
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: 50,
              height: 30,

              decoration: BoxDecoration(
                color: Color(0XFF0f1217),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "حسابي",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
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
              ProfileHeader(user: widget.user),
              SizedBox(height: isMobile ? 20 : 30),
              LogoutButton(isMobile: isMobile),
              SizedBox(height: isMobile ? 20 : 30),

              CategoryTabs(
                isMobile: isMobile,
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              SizedBox(height: isMobile ? 20 : 30),

              if (selectedIndex == 0) ...[
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox(),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      success: (data) {
                        final profile = data as StudentProfileResponse;

                        if (profile.courses == null ||
                            profile.courses!.isEmpty) {
                          return EmptyState(
                            message: "لا توجد دورات",
                            isMobile: isMobile,
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isMobile ? 1 : 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: isMobile ? 0.9 : 0.8,
                              ),
                          itemCount: profile.courses!.length,
                          itemBuilder: (context, index) {
                            final course = profile.courses![index];
                            final imageUrl = buildImageUrl(
                              course.featuredImage?.url,
                            );
                            return CourseCard(
                              image: imageUrl,
                              courseName: course.title ?? '',
                              isMobile: isMobile,
                            );
                          },
                        );
                      },
                      error: (error) => EmptyState(
                        message: "خطأ: $error",
                        isMobile: isMobile,
                      ),
                    );
                  },
                ),
              ] else if (selectedIndex == 1) ...[
                RewardBox(isMobile: isMobile),
              ],

            ],
          ),
        ),
      ),
    );
  }
}

String buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return "";

  if (imagePath.startsWith('http')) {
    return imagePath;
  }

  return imagePath.startsWith('/')
      ? Constants.baseUrl + imagePath
      : Constants.baseUrl + '/' + imagePath;
}
