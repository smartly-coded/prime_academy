import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_state.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_state.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/essay_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/fill_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/lesson_item.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/choose_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/match_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/reorder_question_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

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
  int? _currentSelectedItemId;
  String? _currentVideoId;
  bool _isDisposing = false;
  List<LessonQuestion> _lessonQuestions = [];
  Set<int> _shownQuestions = {};
  Timer? _questionCheckTimer;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _currentSelectedItemId = widget.itemId;

    // تحميل قائمة الدروس
    context.read<ModuleLessonsCubit>().emitModuleLessonsStates(
      widget.moduleId,
      widget.courseId,
    );
    context.read<LessonDetailsCubit>().emitLessonDetailsStates(widget.itemId);
  }

  void _initializePlayer(String url) {
    if (_isDisposing || !mounted) return;

    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null && _currentVideoId != videoId) {
      _currentVideoId = videoId;
      _isPlayerReady = false;

      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          captionLanguage: 'ar',
          forceHD: false,
          loop: false,
          isLive: false,
          disableDragSeek: false,
          useHybridComposition: true,
          hideThumbnail: false,
        ),
      );

      // إضافة listener للتحقق من الأسئلة
      _controller!.addListener(_onPlayerStateChange);
    }
  }

  Widget _buildQuestionDialog(LessonQuestion question) {
    switch (question.type) {
      case QuestionType.mcq:
        return FullScreenMcqDialog(
          question: question,
          onAnswerSubmitted: (bool isCorrect) {
            Navigator.of(context).pop();
            _controller?.play();
            print('Answer result: ${isCorrect ? "Correct" : "Incorrect"}');
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
            print('Question skipped');
          },
        );
      case QuestionType.essay:
        return EssayQuestionDialog(
          question: question,
          onAnswerSubmitted: (String answer, bool isCorrect) {
            Navigator.of(context).pop();
            _controller?.play();
            print('Essay answer: $answer, Correct: $isCorrect');
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
          },
        );
      case QuestionType.fillBlank:
        int expectedLength = question.correctAnswers.isNotEmpty
            ? question.correctAnswers.first.title!.length
            : 5; // قيمة افتراضية
        return FillInBlanksDialog(
          question: question,
          onAnswerSubmitted: (String answer, bool isCorrect) {
            Navigator.of(context).pop();
            _controller?.play();
            print('Fill answer: $answer, Correct: $isCorrect');
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
          },
          expectedLength: expectedLength,
        );

      case QuestionType.match:
        return ResponsiveMatchDialog(
          question: question,
          onAnswerSubmitted: (bool isCorrect) {
            Navigator.of(context).pop();
            _controller?.play();
            print('Match result: ${isCorrect ? "Correct" : "Incorrect"}');
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
          },
        );
      case QuestionType.reOrder:
        return ReorderQuestionDialog(
          question: question,
          onAnswerSubmitted: (bool isCorrect) {},
          onSkip: () {},
        );
      default:
        return Container(child: Text("not supported type"));
    }
  }

  void _changeVideo(String url) {
    if (_isDisposing || !mounted) return;

    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null && _currentVideoId != videoId) {
      print('Loading new video: $videoId');

      if (_controller != null) {
        setState(() {
          _currentVideoId = videoId;
          _isPlayerReady = false;
          _shownQuestions.clear(); // مسح الأسئلة المعروضة للفيديو الجديد
        });
        _controller!.load(videoId);
      } else {
        _initializePlayer(url);
      }
    }
  }

  void _onPlayerStateChange() {
    if (_controller == null || !_isPlayerReady || _isDisposing || !mounted) {
      return;
    }

    final currentSeconds = _controller!.value.position.inSeconds;
    _checkForQuestions(currentSeconds);
  }

  void _safeDisposeController() {
    _questionCheckTimer?.cancel();
    _questionCheckTimer = null;

    if (_controller != null) {
      try {
        _controller!.removeListener(_onPlayerStateChange);
        final tempController = _controller!;
        _controller = null;
        _currentVideoId = null;
        _isPlayerReady = false;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            tempController.dispose();
          } catch (e) {
            print('Error disposing controller: $e');
          }
        });
      } catch (e) {
        print('Error in safe dispose: $e');
      }
    }
  }

  @override
  void dispose() {
    _isDisposing = true;
    _safeDisposeController();
    super.dispose();
  }

  void _checkForQuestions(int currentSeconds) {
    if (_lessonQuestions.isEmpty) {
      return; // لا توجد أسئلة
    }

    print('=== CHECKING QUESTIONS ===');
    print('Current time: ${currentSeconds}s');
    print('Total questions: ${_lessonQuestions.length}');
    print('Already shown: ${_shownQuestions.toList()}');

    for (final question in _lessonQuestions) {
      print(
        'Question ${question.id}: timestamp=${question.timestamp}, title="${question.title}"',
      );

      // تحقق من وقت السؤال مع هامش تسامح ±2 ثانية
      bool timeMatch =
          (currentSeconds >= question.timestamp &&
          currentSeconds <= question.timestamp + 2);
      bool notShownYet = !_shownQuestions.contains(question.id);

      print(
        '  - Time match: $timeMatch (${question.timestamp} <= $currentSeconds <= ${question.timestamp + 2})',
      );
      print('  - Not shown yet: $notShownYet');

      if (timeMatch && notShownYet) {
        print('🎯 SHOWING QUESTION ${question.id} at time $currentSeconds');
        _shownQuestions.add(question.id);

        // وقف الفيديو
        _controller?.pause();
        print('Video paused for question');

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _buildQuestionDialog(question),
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
          ),
        );

        break; // إظهار سؤال واحد فقط في كل مرة
      }
    }
    print('=== END CHECKING ===');
  }

  void _updateLessonQuestions(LessonDetailsResponse lessonDetails) {
    List<LessonQuestion> allQuestions = [];

    try {
      print('Raw groupedQuestions: ${lessonDetails.groupedQuestions}');

      // البيانات مُجمعة حسب timestamp، لذا نحتاج لاستخراجها من كل timestamp
      lessonDetails.groupedQuestions.forEach((timestampKey, questionsData) {
        print('Processing timestamp: $timestampKey with data: $questionsData');

        // تحويل timestamp من String إلى int
        int timestamp;
        try {
          timestamp = int.parse(timestampKey);
        } catch (e) {
          print('Error parsing timestamp $timestampKey: $e');
          return; // تخطي هذا الـ timestamp
        }

        if (questionsData is List) {
          for (var questionData in questionsData) {
            try {
              print('Processing question data: $questionData');

              // تأكد من أن questionData هو Map
              if (questionData is Map<String, dynamic>) {
                // إضافة timestamp للبيانات إذا لم تكن موجودة
                if (!questionData.containsKey('timestamp')) {
                  questionData['timestamp'] = timestamp;
                }

                final question = LessonQuestion.fromJson(questionData);
                allQuestions.add(question);
                print(
                  '✅ Added question: ${question.title} at ${question.timestamp}s',
                );
              } else {
                print('❌ Question data is not a Map: $questionData');
              }
            } catch (e) {
              print('❌ Error parsing individual question: $e');
              print('Question data: $questionData');
            }
          }
        } else {
          print('❌ Questions data is not a List: $questionsData');
        }
      });

      // ترتيب الأسئلة حسب الوقت
      allQuestions.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      setState(() {
        _lessonQuestions = allQuestions;
        _shownQuestions.clear(); // مسح الأسئلة المعروضة السابقة
      });

      print(
        '✅ Updated lesson questions: ${_lessonQuestions.length} questions total',
      );

      // طباعة تفاصيل كل سؤال للـ debugging
      for (var question in _lessonQuestions) {
        print(
          'Question ${question.id}: "${question.title}" at ${question.timestamp}s - ${question.answers.length} answers',
        );
      }
    } catch (e) {
      print('❌ Error processing grouped questions: $e');
      print('Stack trace: ${StackTrace.current}');
      setState(() {
        _lessonQuestions = [];
        _shownQuestions.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<LessonDetailsCubit, LessonDetailsState>(
            listener: (context, state) {
              if (!mounted || _isDisposing) return;

              print('LessonDetailsState changed: $state');
              state.whenOrNull(
                success: (lessonDetails) {
                  // تحديث الأسئلة أولاً
                  _updateLessonQuestions(lessonDetails);

                  final url = lessonDetails.externalUrl;
                  if (url != null && url.isNotEmpty) {
                    final videoId = YoutubePlayer.convertUrlToId(url);
                    if (videoId != null) {
                      print('Changing video to: $videoId');
                      _changeVideo(url);
                    } else {
                      print('Invalid YouTube URL: $url');
                    }
                  } else {
                    print('No URL found in lesson details');
                  }
                },
                loading: () {
                  print('Loading lesson details...');
                },
                error: (msg) {
                  print('Error loading lesson: $msg');
                  if (mounted && !_isDisposing) {
                    _showErrorDialog("فشل تحميل تفاصيل الدرس: $msg");
                  }
                },
              );
            },
          ),
          // إضافة listener للـ ModuleLessons للتحديد التلقائي
          BlocListener<ModuleLessonsCubit, ModuleLessonsState>(
            listener: (context, state) {
              state.whenOrNull(
                success: (module) {
                  // التحقق إذا لم يتم تحميل تفاصيل العنصر المحدد مسبقاً
                  if (_currentSelectedItemId == widget.itemId &&
                      _controller == null) {
                    print(
                      'Auto-loading initial lesson details for item: ${widget.itemId}',
                    );
                    context.read<LessonDetailsCubit>().emitLessonDetailsStates(
                      widget.itemId,
                    );
                  }
                },
              );
            },
          ),
        ],
        child: BlocBuilder<ModuleLessonsCubit, ModuleLessonsState>(
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
                    // عرض الفيديو
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
                          child: YoutubePlayer(
                            controller: _controller!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.red,
                              handleColor: Colors.redAccent,
                            ),
                            onReady: () {
                              print('YouTube player is ready');
                              if (mounted && !_isDisposing) {
                                setState(() {
                                  _isPlayerReady = true;
                                });

                                // بدء timer للتحقق من الأسئلة كل ثانية
                                _questionCheckTimer?.cancel();
                                _questionCheckTimer = Timer.periodic(
                                  Duration(seconds: 1),
                                  (timer) {
                                    if (_controller != null &&
                                        _isPlayerReady &&
                                        mounted) {
                                      final currentSeconds =
                                          _controller!.value.position.inSeconds;
                                      _checkForQuestions(currentSeconds);
                                    }
                                  },
                                );
                              }
                            },
                            onEnded: (data) {
                              if (mounted && !_isDisposing) {
                                print('Video ended: ${data.videoId}');
                                _questionCheckTimer?.cancel();
                              }
                            },
                          ),
                        ),
                      ),

                    // الأزرار
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
                                    final isSelected =
                                        _currentSelectedItemId == item.id;

                                    return LessonItem(
                                      title: lesson.title,
                                      time: _formatDuration(lesson.videoLength),
                                      type: item.itemType,
                                      isSelected: isSelected,
                                      onTap: () {
                                        if (!mounted || _isDisposing) return;

                                        print('Tapping on lesson: ${item.id}');
                                        setState(() {
                                          _currentSelectedItemId = item.id;
                                        });

                                        // إيقاف الـ timer الحالي
                                        _questionCheckTimer?.cancel();

                                        // تحميل تفاصيل الدرس
                                        context
                                            .read<LessonDetailsCubit>()
                                            .emitLessonDetailsStates(item.id);
                                      },
                                    );
                                  } else {
                                    // عرض المصادر الخارجية
                                    final sourceIndex = index - lessons.length;
                                    final item = externalSources[sourceIndex];
                                    final externalSource = item.externalSource!;
                                    final isSelected =
                                        _currentSelectedItemId == item.id;

                                    return LessonItem(
                                      title: externalSource.title,
                                      time: null,
                                      type: item.itemType,
                                      isSelected: isSelected,
                                      onTap: () {
                                        if (!mounted || _isDisposing) return;

                                        setState(() {
                                          _currentSelectedItemId = item.id;
                                        });
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
      ),
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
    if (!mounted || _isDisposing) return;

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
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog('لا يمكن فتح الرابط: $url');
      }
    } catch (e) {
      _showErrorDialog('خطأ في فتح الرابط: $e');
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted || _isDisposing) return;

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
        width: 170,
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
