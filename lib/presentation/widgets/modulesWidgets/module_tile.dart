// // import 'package:flutter/material.dart';
// // import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// // import 'package:prime_academy/core/routing/app_routes.dart';
// // import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
// // import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
// // import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // import 'lesson_item.dart';

// // class ModuleTile extends StatefulWidget {
// //   final ModuleModel module;
// //   final int courseId;
// //   final LoginResponse user;
// //   final int index;

// //   const ModuleTile({
// //     super.key,
// //     required this.module,
// //     required this.courseId,
// //     required this.user,
// //     required this.index,
// //   });

// //   @override
// //   State<ModuleTile> createState() => _ModuleTileState();
// // }

// // class _ModuleTileState extends State<ModuleTile> {
// //   bool _isExpanded = false;
// //   bool get isGradientNonSpecial {
// //     if (widget.index == 0) return true;

// //     final adjustedIndex = widget.index - 1;
// //     final cycleIndex = adjustedIndex % 4;

// //     return cycleIndex >= 2;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isSpecial = widget.module.special == true;
// //     final size = MediaQuery.of(context).size;
// //     final isTablet = size.width > 600;

// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: 10),

// //       decoration: BoxDecoration(
// //         color: !isSpecial && !isGradientNonSpecial
// //             ? Mycolors.cardColor1.withOpacity(.6)
// //             : null,

// //         gradient: isSpecial
// //             ? const LinearGradient(
// //                 colors: [Color(0xFF6a760c), Color(0xFF1b2130)],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               )
// //             : isGradientNonSpecial
// //             ? const LinearGradient(
// //                 colors: [Color(0xFF0e3995), Color(0xFF1b2130)],
// //                 begin: Alignment.bottomLeft,
// //                 end: Alignment.bottomRight,
// //               )
// //             : null,

// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.3),
// //             blurRadius: 6,
// //             offset: Offset(0, 3),
// //           ),
// //         ],
// //       ),

// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           ListTile(
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 16,
// //               vertical: 12,
// //             ),
// //             minVerticalPadding: 0,
// //             dense: true,
// //             onTap: () {
// //               setState(() {
// //                 _isExpanded = !_isExpanded;
// //               });
// //             },
// //             title: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   _isExpanded ? Icons.expand_less : Icons.expand_more,
// //                   color: Colors.white,
// //                   size: isTablet ? 24 : 20,
// //                 ),
// //                 SizedBox(width: 8),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.end,
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       if (isSpecial)
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children: [
// //                             Text(
// //                               widget.module.title,
// //                               textAlign: TextAlign.right,
// //                               maxLines: 1,
// //                               overflow: TextOverflow.ellipsis,
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: isTablet ? 20 : 18,
// //                               ),
// //                             ),
// //                             const SizedBox(width: 8),
// //                             Image.asset(
// //                               "assets/images/olive.png",
// //                               height: 45,
// //                               width: 45,
// //                             ),
// //                           ],
// //                         )
// //                       else
// //                         Text(
// //                           widget.module.title,
// //                           textDirection: TextDirection.rtl,
// //                           textAlign: TextAlign.right,
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: isTablet ? 20 : 18,
// //                           ),
// //                         ),

// //                       if (isSpecial || widget.module.subtitle != null)
// //                         SizedBox(height: 4),
// //                       if (isSpecial)
// //                         Text(
// //                           " لن يخرج عنها الامتحان",
// //                           textAlign: TextAlign.right,
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontSize: isTablet ? 16 : 14,
// //                             fontWeight: FontWeight.w600,
// //                           ),
// //                         )
// //                       else if (widget.module.subtitle != null)
// //                         Text(
// //                           widget.module.subtitle!,
// //                           textAlign: TextAlign.right,
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(
// //                             color: Colors.white70,
// //                             fontSize: isTablet ? 14 : 12,
// //                             fontWeight: FontWeight.w500,
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           if (_isExpanded)
// //             Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     color: Mycolors.cardColor1.withOpacity(.6),
// //                     borderRadius: const BorderRadius.only(
// //                       bottomLeft: Radius.circular(12),
// //                       bottomRight: Radius.circular(12),
// //                     ),
// //                   ),
// //                   padding: const EdgeInsets.only(bottom: 12),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: widget.module.items
// //                         .map(
// //                           (item) => LessonItem(
// //                             title: item.title,
// //                             time: item.time,
// //                             type: item.type,
// //                             isSpecial: widget.module.special,
// //                             onTap: () async {
// //                               if (item.type == LessonType.link &&
// //                                   item.url != null) {
// //                                 final uri = Uri.parse(item.url!);
// //                                 if (await canLaunchUrl(uri)) {
// //                                   await launchUrl(
// //                                     uri,
// //                                     mode: LaunchMode.externalApplication,
// //                                   );
// //                                 } else {
// //                                   ScaffoldMessenger.of(context).showSnackBar(
// //                                     const SnackBar(
// //                                       content: Text('لا يمكن فتح الرابط'),
// //                                     ),
// //                                   );
// //                                 }
// //                               } else {
// //                                 Navigator.pushNamed(
// //                                   context,
// //                                   AppRoutes.moduleLessonsPreview,
// //                                   arguments: {
// //                                     'moduleId': widget.module.id,
// //                                     'courseId': widget.courseId,
// //                                     'user': widget.user,
// //                                     "itemId": item.id,
// //                                   },
// //                                 );
// //                               }
// //                             },
// //                           ),
// //                         )
// //                         .toList(),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
// import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ModuleTile extends StatefulWidget {
//   final ModuleModel module;
//   final int courseId;
//   final LoginResponse user;
//   final int index;

//   const ModuleTile({
//     super.key,
//     required this.module,
//     required this.courseId,
//     required this.user,
//     required this.index,
//   });

//   @override
//   State<ModuleTile> createState() => _ModuleTileState();
// }

// class _ModuleTileState extends State<ModuleTile>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;

//   bool get isGradientNonSpecial {
//     if (widget.index == 0) return true;
//     final adjustedIndex = widget.index - 1;
//     final cycleIndex = adjustedIndex % 4;
//     return cycleIndex >= 2;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     // Slide من الشمال لليمين - بسيط
//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(-0.12, 0), end: Offset.zero).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//         );

//     // Scale - تكبير ناعم
//     _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     // Rotate - هزة خفيفة يمين وشمال أثناء الطلوع
//     _rotateAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 0.0,
//           end: -0.08,
//         ).chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 30,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: -0.08,
//           end: 0.08,
//         ).chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 40,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 0.08,
//           end: 0.0,
//         ).chain(CurveTween(curve: Curves.easeOut)),
//         weight: 30,
//       ),
//     ]).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSpecial = widget.module.special == true;
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(16),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: _getModuleGradient(isSpecial),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: Colors.white.withOpacity(0.08),
//                 width: 1,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.5),
//                   blurRadius: 16,
//                   spreadRadius: -2,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildHeader(isSpecial, isTablet),
//                 if (_isExpanded) ..._buildItems(isSpecial, isTablet),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   LinearGradient _getModuleGradient(bool isSpecial) {
//     if (isSpecial) {
//       // Olive gradient - ياخد نص العرض من الشمال
//       return LinearGradient(
//         colors: [
//           const Color(0xFF6a760c).withOpacity(0.9),
//           const Color(0xFF5a6310).withOpacity(0.75),
//           const Color(0xFF4a5310).withOpacity(0.55),
//           const Color(0xFF3d4710).withOpacity(0.35),
//           const Color(0xFF1b2130).withOpacity(0.15),
//           const Color(0xFF0d1420).withOpacity(0.9),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 1.0],
//       );
//     } else if (isGradientNonSpecial) {
//       // Blue gradient - ياخد نص العرض من الشمال
//       return LinearGradient(
//         colors: [
//           const Color(0xFF0e3995).withOpacity(0.85),
//           const Color(0xFF0c3482).withOpacity(0.7),
//           const Color(0xFF0a2d6e).withOpacity(0.5),
//           const Color(0xFF082557).withOpacity(0.3),
//           const Color(0xFF1b2130).withOpacity(0.15),
//           const Color(0xFF0d1420).withOpacity(0.9),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 1.0],
//       );
//     } else {
//       // Dark Blue gradient
//       return LinearGradient(
//         colors: [
//           const Color(0xFF1e3a5f).withOpacity(0.65),
//           const Color(0xFF162d47).withOpacity(0.5),
//           const Color(0xFF0f2340).withOpacity(0.35),
//           const Color(0xFF0a1c2e).withOpacity(0.2),
//           const Color(0xFF0d1420).withOpacity(0.9),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: const [0.0, 0.25, 0.45, 0.65, 1.0],
//       );
//     }
//   }

//   Widget _buildHeader(bool isSpecial, bool isTablet) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           if (!_isExpanded) {
//             // لما نفتح - نشغل الـ animation
//             _isExpanded = true;
//             if (isSpecial) {
//               _animationController.forward();
//             }
//           } else {
//             // لما نقفل - نرجع بدون هزة
//             _isExpanded = false;
//             if (isSpecial) {
//               _animationController.reverse();
//             }
//           }
//         });
//       },
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: isTablet ? 18 : 16,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(
//               _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//               color: Colors.white,
//               size: isTablet ? 30 : 26,
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isSpecial)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             widget.module.title,
//                             textAlign: TextAlign.right,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: isTablet ? 20 : 18,
//                               height: 1.3,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         AnimatedBuilder(
//                           animation: _animationController,
//                           builder: (context, child) {
//                             return Transform.translate(
//                               offset: Offset(_slideAnimation.value.dx * 45, 0),
//                               child: Transform.scale(
//                                 scale: _scaleAnimation.value,
//                                 child: Transform.rotate(
//                                   angle: _rotateAnimation.value,
//                                   child: Image.asset(
//                                     "assets/images/olive.png",
//                                     height: isTablet ? 48 : 45,
//                                     width: isTablet ? 48 : 45,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     )
//                   else
//                     Text(
//                       widget.module.title,
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                         fontSize: isTablet ? 20 : 18,
//                         height: 1.3,
//                       ),
//                     ),
//                   if (isSpecial || widget.module.subtitle != null)
//                     const SizedBox(height: 5),
//                   if (isSpecial)
//                     Text(
//                       "لن يخرج عنها الامتحان",
//                       textAlign: TextAlign.right,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.85),
//                         fontSize: isTablet ? 14 : 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     )
//                   else if (widget.module.subtitle != null)
//                     Text(
//                       widget.module.subtitle!,
//                       textAlign: TextAlign.right,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.7),
//                         fontSize: isTablet ? 14 : 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildItems(bool isSpecial, bool isTablet) {
//     final List<Widget> items = [];

//     for (int i = 0; i < widget.module.items.length; i++) {
//       final item = widget.module.items[i];

//       items.add(
//         _buildLessonItem(
//           title: item.title,
//           type: item.type,
//           isSpecial: isSpecial,
//           isTablet: isTablet,
//           onTap: () async {
//             if (item.type == LessonType.link && item.url != null) {
//               final uri = Uri.parse(item.url!);
//               if (await canLaunchUrl(uri)) {
//                 await launchUrl(uri, mode: LaunchMode.externalApplication);
//               } else {
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('لا يمكن فتح الرابط')),
//                   );
//                 }
//               }
//             } else {
//               Navigator.pushNamed(
//                 context,
//                 AppRoutes.moduleLessonsPreview,
//                 arguments: {
//                   'moduleId': widget.module.id,
//                   'courseId': widget.courseId,
//                   'user': widget.user,
//                   'itemId': item.id,
//                 },
//               );
//             }
//           },
//         ),
//       );
//     }

//     return items;
//   }

//   Widget _buildLessonItem({
//     required String title,
//     required LessonType type,
//     required bool isSpecial,
//     required bool isTablet,
//     required VoidCallback onTap,
//   }) {
//     IconData iconData;
//     switch (type) {
//       case LessonType.video:
//         iconData = Icons.play_circle_filled;
//         break;

//       case LessonType.link:
//         iconData = Icons.link_rounded;
//         break;
//       default:
//         iconData = Icons.article_rounded;
//     }

//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: isTablet ? 14 : 12,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.right,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: isTablet ? 16 : 15,
//                   fontWeight: FontWeight.w500,
//                   height: 1.4,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Icon(
//               iconData,
//               color: Colors.white.withOpacity(0.85),
//               size: isTablet ? 24 : 22,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/core/routing/app_routes.dart';
// import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
// import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ModuleTile extends StatefulWidget {
//   final ModuleModel module;
//   final int courseId;
//   final LoginResponse user;
//   final int index;

//   const ModuleTile({
//     super.key,
//     required this.module,
//     required this.courseId,
//     required this.user,
//     required this.index,
//   });

//   @override
//   State<ModuleTile> createState() => _ModuleTileState();
// }

// class _ModuleTileState extends State<ModuleTile>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _rotateAnimation;

//   bool get isGradientNonSpecial {
//     if (widget.index == 0) return true;
//     final adjustedIndex = widget.index - 1;
//     final cycleIndex = adjustedIndex % 4;
//     return cycleIndex >= 2;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     // Slide من الشمال لليمين - بسيط
//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(-0.12, 0), end: Offset.zero).animate(
//           CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//         );

//     // Scale - تكبير ناعم
//     _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
//     );

//     // Rotate - هزة خفيفة يمين وشمال أثناء الطلوع
//     _rotateAnimation = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 0.0,
//           end: -0.08,
//         ).chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 30,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: -0.08,
//           end: 0.08,
//         ).chain(CurveTween(curve: Curves.easeInOut)),
//         weight: 40,
//       ),
//       TweenSequenceItem(
//         tween: Tween<double>(
//           begin: 0.08,
//           end: 0.0,
//         ).chain(CurveTween(curve: Curves.easeOut)),
//         weight: 30,
//       ),
//     ]).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSpecial = widget.module.special == true;
//     final size = MediaQuery.of(context).size;
//     final isTablet = size.width > 600;
//     final hasOverlay = isSpecial || isGradientNonSpecial;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12), // ✅ rounded-xl = 12px
//         child: Stack(
//           clipBehavior: Clip.hardEdge,
//           children: [
//             // ✅ Main container with SOLID background (not gradient)
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1B2130), // ✅ Simple solid color
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildHeader(isSpecial, isTablet),
//                   if (_isExpanded) ..._buildItems(isSpecial, isTablet),
//                 ],
//               ),
//             ),

//             // ✅ Blurred overlay stripe (::after pseudo-element)
//             if (hasOverlay)
//               Positioned.fill(
//                 child: IgnorePointer(
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Positioned(
//                         top: -80, // inset-block-start: -80px
//                         right: size.width * -0.2, // inset-inline-end: -20%
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(
//                             sigmaX: 63,
//                             sigmaY: 63,
//                           ), // ✅ blur(63px)
//                           child: Container(
//                             width: size.width * 0.8, // ✅ width: 80%
//                             height: 100,
//                             color: isSpecial
//                                 ? const Color(0xFF6A760C) // ✅ #6a760c olive
//                                 : const Color(0xFF0E3995), // ✅ #0e3995 blue
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   LinearGradient _getModuleGradient(bool isSpecial) {
//     if (isSpecial) {
//       // Olive gradient - ياخد نص العرض من الشمال
//       return LinearGradient(
//         colors: [
//           const Color(0xFF6a760c).withOpacity(0.9),
//           const Color(0xFF5a6310).withOpacity(0.75),
//           const Color(0xFF4a5310).withOpacity(0.55),
//           const Color(0xFF3d4710).withOpacity(0.35),
//           const Color(0xFF1b2130).withOpacity(0.15),
//           const Color(0xFF0d1420).withOpacity(0.9),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 1.0],
//       );
//     } else if (isGradientNonSpecial) {
//       // Blue gradient - ياخد نص العرض من الشمال
//       return LinearGradient(
//         colors: [
//           const Color(0xFF0e3995).withOpacity(0.85),
//           const Color(0xFF0c3482).withOpacity(0.7),
//           const Color(0xFF0a2d6e).withOpacity(0.5),
//           const Color(0xFF082557).withOpacity(0.3),
//           const Color(0xFF1b2130).withOpacity(0.15),
//           const Color(0xFF0d1420).withOpacity(0.9),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 1.0],
//       );
//     } else {
//       // Dark Blue gradient
//       return LinearGradient(
//         colors: [
//           const Color(0xFF1e3a5f).withOpacity(0.65),
//           const Color(0xFF162d47).withOpacity(0.5),
//           const Color(0xFF0f2340).withOpacity(0.35),
//           const Color(0xFF0a1c2e).withOpacity(0.2),
//           const Color(0xFF0d1420).withOpacity(0.9),
//         ],
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         stops: const [0.0, 0.25, 0.45, 0.65, 1.0],
//       );
//     }
//   }

//   Widget _buildHeader(bool isSpecial, bool isTablet) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _isExpanded = !_isExpanded;
//         });

//         // ✅ Trigger animation only for special (olive) modules when expanding
//         if (isSpecial && _isExpanded) {
//           _animationController.forward(from: 0);
//         }
//       },
//       borderRadius: const BorderRadius.vertical(
//         top: Radius.circular(12),
//       ), // ✅ 12px
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: isTablet ? 18 : 16,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // ✅ Chevron on LEFT (for RTL layout)
//             AnimatedRotation(
//               turns: _isExpanded ? 0.5 : 0, // 180deg rotation

//               duration: const Duration(milliseconds: 200),
//               curve: Curves.easeOut,
//               child: Icon(
//                 Icons.keyboard_arrow_down, // ✅ Always down arrow, rotates 180
//                 color: Colors.white,
//                 size: 16, // ✅ Web uses size-4 = 16px
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (isSpecial)
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             widget.module.title,
//                             textAlign: TextAlign.right,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600, // ✅ 600
//                               fontSize: isTablet ? 20 : 18,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // ✅ Olive image with animation
//                         AnimatedBuilder(
//                           animation: _animationController,
//                           builder: (context, child) {
//                             return Transform.translate(
//                               offset: Offset(_slideAnimation.value.dx * 45, 0),
//                               child: Transform.scale(
//                                 scale: _scaleAnimation.value,
//                                 child: Transform.rotate(
//                                   angle: _rotateAnimation.value,
//                                   child: Transform.scale(
//                                     scale: 1.2, // ✅ Base scale from web
//                                     child: Image.asset(
//                                       "assets/images/olive.png",
//                                       height: isTablet
//                                           ? 56
//                                           : 40, // ✅ w-10 h-10 md:w-14 md:h-14
//                                       width: isTablet ? 56 : 40,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     )
//                   else
//                     Text(
//                       widget.module.title,
//                       textDirection: TextDirection.rtl,
//                       textAlign: TextAlign.right,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600, // ✅ 600
//                         fontSize: isTablet ? 20 : 18,
//                       ),
//                     ),
//                   if (isSpecial || widget.module.subtitle != null)
//                     const SizedBox(height: 8), // ✅ gap-2 = 8px
//                   if (isSpecial)
//                     Text(
//                       "لن يخرج عنها الامتحان",
//                       textAlign: TextAlign.right,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white, // ✅ text-white (not opacity)
//                         fontSize: 14, // ✅ text-sm
//                         fontWeight: FontWeight.w400,
//                       ),
//                     )
//                   else if (widget.module.subtitle != null)
//                     Text(
//                       widget.module.subtitle!,
//                       textAlign: TextAlign.right,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.7),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildItems(bool isSpecial, bool isTablet) {
//     final List<Widget> items = [];

//     for (int i = 0; i < widget.module.items.length; i++) {
//       final item = widget.module.items[i];

//       items.add(
//         _buildLessonItem(
//           title: item.title,
//           type: item.type,
//           isSpecial: isSpecial,
//           isTablet: isTablet,
//           onTap: () async {
//             if (item.type == LessonType.link && item.url != null) {
//               final uri = Uri.parse(item.url!);
//               if (await canLaunchUrl(uri)) {
//                 await launchUrl(uri, mode: LaunchMode.externalApplication);
//               } else {
//                 if (context.mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('لا يمكن فتح الرابط')),
//                   );
//                 }
//               }
//             } else {
//               Navigator.pushNamed(
//                 context,
//                 AppRoutes.moduleLessonsPreview,
//                 arguments: {
//                   'moduleId': widget.module.id,
//                   'courseId': widget.courseId,
//                   'user': widget.user,
//                   'itemId': item.id,
//                 },
//               );
//             }
//           },
//         ),
//       );
//     }

//     return items;
//   }

//   Widget _buildLessonItem({
//     required String title,
//     required LessonType type,
//     required bool isSpecial,
//     required bool isTablet,
//     required VoidCallback onTap,
//   }) {
//     IconData iconData;
//     switch (type) {
//       case LessonType.video:
//         iconData = Icons.play_circle_filled;
//         break;

//       case LessonType.link:
//         iconData = Icons.link_rounded;
//         break;
//       default:
//         iconData = Icons.article_rounded;
//     }

//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: isTablet ? 14 : 12,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 textAlign: TextAlign.right,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: isTablet ? 16 : 15,
//                   fontWeight: FontWeight.w500,
//                   height: 1.4,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Icon(
//               iconData,
//               color: Colors.white.withOpacity(0.85),
//               size: isTablet ? 24 : 22,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/core/routing/app_routes.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_type.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_model.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:url_launcher/url_launcher.dart';

class ModuleTile extends StatefulWidget {
  final ModuleModel module;
  final int courseId;
  final LoginResponse user;
  final int index;

  const ModuleTile({
    super.key,
    required this.module,
    required this.courseId,
    required this.user,
    required this.index,
  });

  @override
  State<ModuleTile> createState() => _ModuleTileState();
}

class _ModuleTileState extends State<ModuleTile>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  bool get isGradientNonSpecial {
    if (widget.index == 0) return true;
    final adjustedIndex = widget.index - 1;
    final cycleIndex = adjustedIndex % 4;
    return cycleIndex >= 2;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Slide من الشمال لليمين - بسيط
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-0.12, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    // Scale - تكبير ناعم
    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Rotate - هزة خفيفة يمين وشمال أثناء الطلوع
    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: -0.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.08,
          end: 0.08,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.08,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSpecial = widget.module.special == true;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final hasOverlay = isSpecial || isGradientNonSpecial;

    return Container(
      margin: EdgeInsets.zero, // Remove margin since parent handles spacing

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // ✅ Layer 1: Base background (darker for cards without overlay)
            Container(
              decoration: BoxDecoration(
                color: hasOverlay
                    ? const Color(0xFF1b2130) // Normal bg with overlay
                    : const Color(
                        0xFF1b2130,
                      ), // ✅ Same color for non-overlay cards
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // ✅ Layer 2: Blurred colored stripe from TOP-LEFT (z-index: 0)
            if (hasOverlay)
              Positioned(
                top: -80,
                left: size.width * -0.2,

                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: 63,
                    sigmaY: 63,
                    tileMode: TileMode.decal,
                  ),
                  child: Container(
                    width: size.width * 0.8,
                    height: 100,
                    decoration: BoxDecoration(
                      color: isSpecial
                          ? const Color(0xFF6A760C) // olive
                          : const Color(0xFF0E3995), // blue
                    ),
                  ),
                ),
              ),

            // ✅ Layer 3: Content ON TOP with transparent background
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(isSpecial, isTablet),
                  if (_isExpanded) ..._buildItems(isSpecial, isTablet),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getModuleGradient(bool isSpecial) {
    if (isSpecial) {
      // Olive gradient - ياخد نص العرض من الشمال
      return LinearGradient(
        colors: [
          const Color(0xFF6a760c).withOpacity(0.9),
          const Color(0xFF5a6310).withOpacity(0.75),
          const Color(0xFF4a5310).withOpacity(0.55),
          const Color(0xFF3d4710).withOpacity(0.35),
          const Color(0xFF1b2130).withOpacity(0.15),
          const Color(0xFF0d1420).withOpacity(0.9),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 1.0],
      );
    } else if (isGradientNonSpecial) {
      // Blue gradient - ياخد نص العرض من الشمال
      return LinearGradient(
        colors: [
          const Color(0xFF0e3995).withOpacity(0.85),
          const Color(0xFF0c3482).withOpacity(0.7),
          const Color(0xFF0a2d6e).withOpacity(0.5),
          const Color(0xFF082557).withOpacity(0.3),
          const Color(0xFF1b2130).withOpacity(0.15),
          const Color(0xFF0d1420).withOpacity(0.9),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.0, 0.2, 0.35, 0.5, 0.65, 1.0],
      );
    } else {
      // Dark Blue gradient
      return LinearGradient(
        colors: [
          const Color(0xFF1e3a5f).withOpacity(0.65),
          const Color(0xFF162d47).withOpacity(0.5),
          const Color(0xFF0f2340).withOpacity(0.35),
          const Color(0xFF0a1c2e).withOpacity(0.2),
          const Color(0xFF0d1420).withOpacity(0.9),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.0, 0.25, 0.45, 0.65, 1.0],
      );
    }
  }

  Widget _buildHeader(bool isSpecial, bool isTablet) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });

        // ✅ Trigger animation only for special (olive) modules when expanding
        if (isSpecial) {
          if (_isExpanded) {
            _animationController.forward(from: 0); // Start animation
          } else {
            _animationController.reset(); // ✅ Reset to original state
          }
        }
      },
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
      ), // ✅ 12px
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: isTablet ? 18 : 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // ✅ Chevron on LEFT (for RTL layout)
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0, // 180deg rotation
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Icon(
                Icons.keyboard_arrow_down, // ✅ Always down arrow, rotates 180
                color: Colors.white,
                size: 16, // ✅ Web uses size-4 = 16px
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSpecial)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            widget.module.title,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600, // ✅ 600
                              fontSize: isTablet ? 20 : 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ✅ Olive image with animation
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_slideAnimation.value.dx * 45, 0),
                              child: Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Transform.rotate(
                                  angle: _rotateAnimation.value,
                                  child: Transform.scale(
                                    scale: 1.2, // ✅ Base scale from web
                                    child: Image.asset(
                                      "assets/images/olive.png",
                                      height: isTablet
                                          ? 56
                                          : 40, // ✅ w-10 h-10 md:w-14 md:h-14
                                      width: isTablet ? 56 : 40,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  else
                    Text(
                      widget.module.title,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600, // ✅ 600
                        fontSize: isTablet ? 20 : 18,
                      ),
                    ),
                  if (isSpecial || widget.module.subtitle != null)
                    const SizedBox(height: 8), // ✅ gap-2 = 8px
                  if (isSpecial)
                    Text(
                      "لن يخرج عنها الامتحان",
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white, // ✅ text-white (not opacity)
                        fontSize: 14, // ✅ text-sm
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  else if (widget.module.subtitle != null)
                    Text(
                      widget.module.subtitle!,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems(bool isSpecial, bool isTablet) {
    final List<Widget> items = [];

    for (int i = 0; i < widget.module.items.length; i++) {
      final item = widget.module.items[i];

      items.add(
        _buildLessonItem(
          title: item.title,
          type: item.type,
          isSpecial: isSpecial,
          isTablet: isTablet,
          onTap: () async {
            if (item.type == LessonType.link && item.url != null) {
              final uri = Uri.parse(item.url!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يمكن فتح الرابط')),
                  );
                }
              }
            } else {
              Navigator.pushNamed(
                context,
                AppRoutes.moduleLessonsPreview,
                arguments: {
                  'moduleId': widget.module.id,
                  'courseId': widget.courseId,
                  'user': widget.user,
                  'itemId': item.id,
                },
              );
            }
          },
        ),
      );
    }

    return items;
  }

  Widget _buildLessonItem({
    required String title,
    required LessonType type,
    required bool isSpecial,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    IconData iconData;
    switch (type) {
      case LessonType.video:
        iconData = Icons.play_circle_filled;
        break;

      case LessonType.link:
        iconData = Icons.link_rounded;
        break;
      default:
        iconData = Icons.article_rounded;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: isTablet ? 14 : 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 16 : 15,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              iconData,
              color: Colors.white.withOpacity(0.85),
              size: isTablet ? 24 : 22,
            ),
          ],
        ),
      ),
    );
  }
}
