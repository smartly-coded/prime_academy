// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/build_text.dart';
// import 'package:prime_academy/presentation/widgets/homeWidgets/three_tabs_widget.dart';

// class HomeScreen extends StatelessWidget {
//   final LoginResponse? user;
//   const HomeScreen({super.key, this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0XFF0f1217),
//       appBar: AppBar(
//         backgroundColor: const Color(0XFF0f1217),
//         title: const Text("Home", style: TextStyle(color: Colors.white)),
//         actions: [
//           Container(
//             padding: EdgeInsets.all(2),
//             width: 100,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xff4f2349), Color(0xffa76433)],
//               ),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Container(
//               width: 80,

//               decoration: BoxDecoration(
//                 color: Color(0XFF0f1217),
//                 borderRadius: BorderRadius.circular(
//                   15,
//                 ),
//               ),
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, AppRoutes.login);
//                 },
//                 child: const Text(
//                   "تسجيل الخروج",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           buildText("مرحبا", "${user!.firstname} ${user!.lastname}", context),
//           ThreeTabsWidget(),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  Future<void> _openGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0f1217),
      appBar: AppBar(backgroundColor: const Color(0xFF0f1217), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isMobile ? 15 : width * 0.1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _openGallery(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: _image == null
                        ? const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          )
                        : ClipOval(
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "مرحبا",
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white70,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      "Student User",
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: isMobile ? 20 : 30),

            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffa76433), Color(0xff4f2349)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout, color: Colors.white, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 30),

            Container(
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
                    _buildCategoryItem(" الدورات الملتحق بها", true, isMobile),
                    _buildCategoryItem("الجوائز", false, isMobile),
                    _buildCategoryItem("تصنيفي الحالي", false, isMobile),
                  ],
                ),
              ),
            ),

            SizedBox(height: isMobile ? 20 : 30),

            _buildSelectedCategoryContent(true, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, bool isSelected, bool isMobile) {
    return GestureDetector(
      onTap: () {},
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

  Widget _buildSelectedCategoryContent(bool isCoursesSelected, bool isMobile) {
    if (isCoursesSelected) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: isMobile ? 0.9 : 0.8,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildCourseCard(
            courseName: "math course ${index + 1}",
            isMobile: isMobile,
          );
        },
      );
    } else {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1d24),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            isCoursesSelected ? "لا توجد دورات" : "لا توجد جوائز",
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

  Widget _buildCourseCard({
    required String courseName,
    required bool isMobile,
  }) {
    return Container(
      //margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 50, 55, 68),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min, // 👈 يخلي الكارد على قد المحتوى
        children: [
          Container(
            width: double.infinity,
            height: isMobile ? 80 : 100,
            decoration: BoxDecoration(
              color: const Color(0xFF2a2d34),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.menu_book, color: Colors.white, size: 35),
            ),
          ),
          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffa76433), Color(0xff4f2349)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
            onTap: () {
              // هنا تفتح صفحة الدورة
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffa76433), Color(0xff4f2349)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "الذهاب للدورة",
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 15,
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
