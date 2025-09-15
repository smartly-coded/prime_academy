import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/module_lessons_response_model.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_state.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/lesson_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewModule extends StatefulWidget {
  final int moduleId;
  final int courseId;
  final int itemId;

  const ViewModule({
    super.key,
    required this.moduleId,
    required this.courseId,
    required this.itemId,
  });

  @override
  State<ViewModule> createState() => _ViewModuleState();
}

class _ViewModuleState extends State<ViewModule> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    context.read<ModuleLessonsCubit>().emitModuleLessonsStates(
      widget.moduleId,
      widget.courseId,
    );
  }

  void _initializePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: true,
          captionLanguage: 'ar', // العربية إذا متاحة
          forceHD: false,
          loop: false,
          isLive: false,
          disableDragSeek: false,
          useHybridComposition: true, // مهم لـ Android performance
          hideThumbnail: false,
        ),
      );
    }
  }

  void _playVideo(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      if (_controller != null) {
        // إذا كان هناك player موجود، حمل فيديو جديد
        _controller!.load(videoId);
      } else {
        // إذا لم يكن هناك player، أنشئ واحد جديد
        setState(() {
          _initializePlayer(url);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller:
            _controller ??
            YoutubePlayerController(
              initialVideoId: 'dQw4w9WgXcQ', // placeholder video
              flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
            ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          print('Player is ready.');
        },
        onEnded: (data) {
          print('Video ended: ${data.videoId}');
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Mycolors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Mycolors.backgroundColor,
            elevation: 0,
            title: Text(
              "دروس الوحدة",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: BlocBuilder<ModuleLessonsCubit, ModuleLessonsState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(
                  child: Text(
                    "جاري تحميل الدروس...",
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                success: (module) {
                  final selectedItem = module.items.firstWhere(
                    (item) => item.id == widget.itemId,
                    orElse: () => module.items.first as Item,
                  );

                  final videoUrl = selectedItem.lesson?.externalUrl;

                  // جهز الـ controller لو فيه فيديو
                  if (videoUrl != null && videoUrl.isNotEmpty) {
                    if (_controller == null) {
                      _initializePlayer(videoUrl);
                    } else {
                      _controller!.load(
                        YoutubePlayer.convertUrlToId(videoUrl)!,
                      );
                    }
                  }

                  final lessons =
                      module.items
                          ?.where((item) => item.lesson != null)
                          .toList() ??
                      [];

                  final externalSources =
                      module.items
                          ?.where((item) => item.externalSource != null)
                          .toList() ??
                      [];

                  return Column(
                    children: [
                      if (_controller != null)
                        Container(
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: YoutubePlayer(controller: _controller!),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 80,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildButton(
                                "اسأل الذكاء الاصطناعي",
                                "assets/icons/bot.png",
                                () {
                                  _openExternalLink("https://chatgpt.com/");
                                },
                              ),
                              _buildButton(
                                "اسأل المعلم",
                                "assets/icons/message.png",
                                () {},
                              ),
                              _buildButton(
                                "الملازم الالكترونيه",
                                "assets/icons/open-book.png",
                                () {},
                              ),
                              _buildButton(
                                "الفيديوهات",
                                "assets/icons/play.png",
                                () {},
                              ),
                            ],
                          ),
                        ),
                      ),

                      // قائمة الدروس
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Mycolors.darkblue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Header للقائمة
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.playlist_play,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "محتويات الوحدة (${lessons.length + externalSources.length})",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Divider(color: Colors.white12, height: 1),

                              // قائمة العناصر
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      (lessons.length + externalSources.length),
                                  itemBuilder: (context, index) {
                                    if (index < lessons.length) {
                                      // عرض الدروس
                                      final item = lessons[index];
                                      final lesson = item.lesson!;

                                      return LessonItem(
                                        title: lesson.title,
                                        time: _formatDuration(
                                          lesson.videoLength,
                                        ),
                                        type: item.itemType,
                                        onTap: () {
                                          if (lesson.externalUrl != null) {
                                            setState(() {
                                              _playVideo(lesson.externalUrl!);
                                            });
                                          }
                                        },
                                      );
                                    } else {
                                      // عرض المصادر الخارجية
                                      final sourceIndex =
                                          index - lessons.length;
                                      final item = externalSources[sourceIndex];
                                      final externalSource =
                                          item.externalSource!;

                                      return LessonItem(
                                        title: externalSource.title,
                                        time: null,
                                        type: item.itemType,
                                        onTap: () {
                                          _openExternalLink(externalSource.url);
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        "خطأ في تحميل البيانات",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.red.withOpacity(0.8),
                          fontSize: 14,
                          fontFamily: 'Cairo',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<ModuleLessonsCubit>()
                              .emitModuleLessonsStates(
                                widget.moduleId,
                                widget.courseId,
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          "إعادة المحاولة",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return "${hours}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
    } else {
      return "${minutes}:${secs.toString().padLeft(2, '0')}";
    }
  }

  void _openExternalLink(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mycolors.darkblue,
        title: Text(
          "فتح رابط خارجي",
          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        content: Text(
          "هل تريد فتح هذا الرابط؟\n$url",
          style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "إلغاء",
              style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _launchUrl(url);
            },
            child: Text(
              "فتح",
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // يفتح في المتصفح الخارجي
        );
      } else {
        _showErrorDialog('لا يمكن فتح الرابط: $url');
      }
    } catch (e) {
      _showErrorDialog('خطأ في فتح الرابط: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mycolors.darkblue,
        title: Text(
          "خطأ",
          style: TextStyle(color: Colors.red, fontFamily: 'Cairo'),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "موافق",
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, String imagePath, VoidCallback ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 170, // عرض ثابت للزرار
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Mycolors.cardColor1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                textAlign: TextAlign.right,
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Image.asset(imagePath, width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
