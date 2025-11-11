import 'package:flutter/material.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialsPage extends StatelessWidget {
  final List<MaterialData> materials;

  const MaterialsPage({Key? key, required this.materials}) : super(key: key);

  // دالة لفتح رابط PDF
  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = "https://cdn.primeacademy.education/primeacademy/";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // قيم responsive بناءً على حجم الشاشة
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الملازم الالكترونية',
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet
                ? 28
                : isSmallScreen
                ? 20
                : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            children: [
              Container(
                height: isTablet ? 3 : 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.orange],
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 20 : 16),

              
              Expanded(
                child: materials.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد ملازم متاحة حالياً 📂',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isTablet
                                ? 20
                                : isSmallScreen
                                ? 14
                                : 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemCount: materials.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: isTablet ? 12 : 8),
                        itemBuilder: (context, index) {
                          final file = materials[index].fileData;

                          // دمج الدومين مع المسار النسبي بشكل آمن
                          final fullUrl =
                              baseUrl +
                              file.url.replaceFirst(RegExp(r'^/+'), '');

                          return InkWell(
                            onTap: () => _openPdf(fullUrl),
                            borderRadius: BorderRadius.circular(
                              isTablet ? 12 : 8,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(isTablet ? 16 : 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF11162B),
                                borderRadius: BorderRadius.circular(
                                  isTablet ? 12 : 8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.redAccent,
                                    size: isTablet
                                        ? 28
                                        : isSmallScreen
                                        ? 18
                                        : 20,
                                  ),
                                  SizedBox(width: isTablet ? 12 : 8),
                                  Expanded(
                                    child: Text(
                                      file.filename,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet
                                            ? 18
                                            : isSmallScreen
                                            ? 12
                                            : 14,
                                        fontWeight: isTablet
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
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
      ),
    );
  }
}
