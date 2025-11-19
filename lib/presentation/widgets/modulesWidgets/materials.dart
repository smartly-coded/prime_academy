// import 'package:flutter/material.dart';
// import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MaterialsPage extends StatelessWidget {
//   final List<MaterialData> materials;

//   const MaterialsPage({Key? key, required this.materials}) : super(key: key);

//   // دالة لفتح رابط PDF
//   Future<void> _openPdf(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('Could not launch $url');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final baseUrl = "https://cdn.primeacademy.education/primeacademy/";
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     // قيم responsive بناءً على حجم الشاشة
//     final isSmallScreen = screenWidth < 360;
//     final isTablet = screenWidth > 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFF0B0E1A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B0E1A),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.close,
//             color: Colors.white,
//             size: isTablet ? 28 : 24,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'الملازم الالكترونية',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isTablet
//                 ? 28
//                 : isSmallScreen
//                 ? 20
//                 : 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(isTablet ? 24 : 16),
//           child: Column(
//             children: [
//               Container(
//                 height: isTablet ? 3 : 2,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple, Colors.orange],
//                   ),
//                 ),
//               ),
//               SizedBox(height: isTablet ? 20 : 16),

//               Expanded(
//                 child: materials.isEmpty
//                     ? Center(
//                         child: Text(
//                           'لا توجد ملازم متاحة حالياً 📂',
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: isTablet
//                                 ? 20
//                                 : isSmallScreen
//                                 ? 14
//                                 : 16,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                     : ListView.separated(
//                         itemCount: materials.length,
//                         separatorBuilder: (_, __) =>
//                             SizedBox(height: isTablet ? 12 : 8),
//                         itemBuilder: (context, index) {
//                           final file = materials[index].fileData;

//                           // دمج الدومين مع المسار النسبي بشكل آمن
//                           final fullUrl =
//                               baseUrl +
//                               file.url.replaceFirst(RegExp(r'^/+'), '');

//                           return InkWell(
//                             onTap: () => _openPdf(fullUrl),
//                             borderRadius: BorderRadius.circular(
//                               isTablet ? 12 : 8,
//                             ),
//                             child: Container(
//                               padding: EdgeInsets.all(isTablet ? 16 : 12),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF11162B),
//                                 borderRadius: BorderRadius.circular(
//                                   isTablet ? 12 : 8,
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.picture_as_pdf,
//                                     color: Colors.redAccent,
//                                     size: isTablet
//                                         ? 28
//                                         : isSmallScreen
//                                         ? 18
//                                         : 20,
//                                   ),
//                                   SizedBox(width: isTablet ? 12 : 8),
//                                   Expanded(
//                                     child: Text(
//                                       file.filename,
//                                       textAlign: TextAlign.right,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: isTablet
//                                             ? 18
//                                             : isSmallScreen
//                                             ? 12
//                                             : 14,
//                                         fontWeight: isTablet
//                                             ? FontWeight.w500
//                                             : FontWeight.normal,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
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

  // دالة لتحديد نوع الجهاز
  DeviceType _getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 360) {
      return DeviceType.smallMobile;
    } else if (screenWidth < 600) {
      return DeviceType.mobile;
    } else if (screenWidth < 900) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // دالة للحصول على الأبعاد بناءً على نوع الجهاز
  _MaterialsDimensions _getDimensions(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    switch (deviceType) {
      case DeviceType.smallMobile:
        return _MaterialsDimensions(
          horizontalPadding: 12,
          verticalPadding: 30,
          titleFontSize: 18,
          itemFontSize: 12,
          iconSize: 18,
          itemHeight: 50,
          itemPadding: 10,
          borderRadius: 6,
          spacing: 16,
          dividerHeight: 2,
        );
      case DeviceType.mobile:
        return _MaterialsDimensions(
          horizontalPadding: 16,
          verticalPadding: 20,
          titleFontSize: 20,
          itemFontSize: 14,
          iconSize: 20,
          itemHeight: 70,
          itemPadding: 10,
          borderRadius: 8,
          spacing: 20,
          dividerHeight: 2,
        );
      case DeviceType.tablet:
        return _MaterialsDimensions(
          horizontalPadding: 24,
          verticalPadding: 30,
          titleFontSize: 24,
          itemFontSize: 16,
          iconSize: 24,
          itemHeight: 100,
          itemPadding: 16,
          borderRadius: 12,
          spacing: 12,
          dividerHeight: 3,
        );
      case DeviceType.desktop:
        return _MaterialsDimensions(
          horizontalPadding: 32,
          verticalPadding: 28,
          titleFontSize: 28,
          itemFontSize: 18,
          iconSize: 28,
          itemHeight: 120,
          itemPadding: 20,
          borderRadius: 16,
          spacing: 16,
          dividerHeight: 4,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions(context);
    final baseUrl = "https://cdn.primeacademy.education/primeacademy/";

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0E1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: dimensions.iconSize,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الملازم الالكترونية',
          style: TextStyle(
            color: Colors.white,
            fontSize: dimensions.titleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.horizontalPadding,
            vertical: dimensions.verticalPadding,
          ),
          child: Column(
            children: [
              // الخط الملون
              Container(
                height: dimensions.dividerHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Mycolors.primary_color.colors,
                  ),
                ),
              ),
              SizedBox(height: dimensions.spacing),

              // قائمة الملازم
              Expanded(
                child: materials.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              color: Colors.white70,
                              size: dimensions.iconSize * 2,
                            ),
                            SizedBox(height: dimensions.spacing),
                            Text(
                              'لا توجد ملازم متاحة حالياً 📂',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: dimensions.itemFontSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: materials.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: dimensions.spacing),
                        itemBuilder: (context, index) {
                          final file = materials[index].fileData;

                          // دمج الدومين مع المسار النسبي بشكل آمن
                          final fullUrl =
                              baseUrl +
                              file.url.replaceFirst(RegExp(r'^/+'), '');

                          return _buildMaterialItem(
                            context: context,
                            file: file,
                            fullUrl: fullUrl,
                            dimensions: dimensions,
                            index: index,
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

  // دالة لبناء عنصر المادة
  Widget _buildMaterialItem({
    required BuildContext context,
    required FileData file,
    required String fullUrl,
    required _MaterialsDimensions dimensions,
    required int index,
  }) {
    return InkWell(
      onTap: () => _openPdf(fullUrl),
      borderRadius: BorderRadius.circular(dimensions.borderRadius),
      child: Container(
        height: dimensions.itemHeight,
        padding: EdgeInsets.all(dimensions.itemPadding),
        decoration: BoxDecoration(
          color: const Color(0xFF11162B),
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            // رقم الملف
            // Container(
            //   width: dimensions.iconSize * 1.5,
            //   height: dimensions.iconSize * 1.5,
            //   decoration: BoxDecoration(
            //     color: Colors.purple.withOpacity(0.2),
            //     shape: BoxShape.circle,
            //     border: Border.all(
            //       color: Colors.purple,
            //       width: 1.5,
            //     ),
            //   ),
            //   child: Center(
            //     child: Text(
            //       '${index + 1}',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: dimensions.itemFontSize * 0.8,
            //         // fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(width: dimensions.spacing),

            // // أيقونة PDF
            // Icon(
            //   Icons.picture_as_pdf,
            //   color: Colors.redAccent,
            //   size: dimensions.iconSize,
            // ),
            // SizedBox(width: dimensions.spacing),

            // اسم الملف
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    file.filename,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dimensions.itemFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(height: dimensions.spacing / 2),
                  Text(
                    '${(file.size / 1024 / 1024).toStringAsFixed(1)} MB',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: dimensions.itemFontSize * 0.8,
                    ),
                  ),
                ],
              ),
            ),

            // سهم التنقل
            // SizedBox(width: dimensions.spacing),
            // Icon(
            //   Icons.arrow_back_ios_new,
            //   color: Colors.white54,
            //   size: dimensions.iconSize * 0.8,
            // ),
          ],
        ),
      ),
    );
  }
}

enum DeviceType { smallMobile, mobile, tablet, desktop }

class _MaterialsDimensions {
  final double horizontalPadding;
  final double verticalPadding;
  final double titleFontSize;
  final double itemFontSize;
  final double iconSize;
  final double itemHeight;
  final double itemPadding;
  final double borderRadius;
  final double spacing;
  final double dividerHeight;

  const _MaterialsDimensions({
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.titleFontSize,
    required this.itemFontSize,
    required this.iconSize,
    required this.itemHeight,
    required this.itemPadding,
    required this.borderRadius,
    required this.spacing,
    required this.dividerHeight,
  });
}
