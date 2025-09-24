import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_state.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_state.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_state.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_state.dart';
import 'package:prime_academy/presentation/Chat/chatPage.dart';
import 'package:prime_academy/presentation/Modules/veiw/video_header.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/course_rating_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/essay_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/fill_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/lesson_item.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/choose_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/match_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/recorded_lesson_items.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/reorder_question_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

class ViewModule extends StatefulWidget {
  final int moduleId;
  final int courseId;
  final int itemId;
  final LoginResponse user;

  const ViewModule({
    super.key,
    required this.moduleId,
    required this.courseId,
    required this.itemId,
    required this.user,
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
  String _currentLessonTitle = ""; // متغير لحفظ عنوان الدرس الحالي
  Set<int> _rewardedLessons = {};
  bool _isFirstVideo = false;
  bool _hasShownRatingPopup = false;
  Set<String> _shownRatingForCourses = {};
  Set<String> _shownQuestionsGlobally = {};
  // تحديث العنوان عند تغيير الدرس
  void _updateCurrentLessonTitle(String title) {
    setState(() {
      _currentLessonTitle = title;
    });
  }

  Future<void> _loadShownRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final shownList = prefs.getStringList('shown_ratings') ?? [];
    setState(() {
      _shownRatingForCourses = shownList.toSet();
    });
    print('Loaded shown ratings for courses: $_shownRatingForCourses');
  }

  Future<void> _saveShownRatings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('shown_ratings', _shownRatingForCourses.toList());
  }

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
    _loadRewardedLessons();
    _loadShownQuestions();
    _loadShownRatings();
  }

  void _checkIfFirstVideo(List<dynamic> lessons) {
    if (lessons.isEmpty || _currentSelectedItemId == null) {
      _isFirstVideo = false;
      return;
    }

    // ترتيب الدروس حسب الـ ID (أو أي معيار ترتيب آخر)
    lessons.sort((a, b) => a.id.compareTo(b.id));

    // فحص إذا كان الدرس الحالي هو أول درس
    final firstLesson = lessons.first;
    _isFirstVideo = firstLesson.id == _currentSelectedItemId;

    print(
      'Current lesson: $_currentSelectedItemId, First lesson: ${firstLesson.id}, Is first: $_isFirstVideo',
    );
  }

  void _showRatingPopupIfNeeded() {
    final courseKey = widget.courseId.toString();

    if (_isFirstVideo &&
        !_hasShownRatingPopup &&
        !_shownRatingForCourses.contains(courseKey)) {
      _hasShownRatingPopup = true;
      _shownRatingForCourses.add(courseKey);
      _saveShownRatings();

      // ✅ احفظي الـ cubit قبل الـ dialog
      final testimonalCubit = context.read<TestimonalCubit>();

      Future.delayed(Duration(seconds: 1), () {
        if (mounted && !_isDisposing) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CourseRatingDialog(
              courseId: widget.courseId,
              onSubmitRating: (ratingRequest) {
                // ✅ استخدمي الـ cubit المحفوظ
                testimonalCubit.sendStudentTestimonal(ratingRequest);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'شكراً لك! تم إرسال تقييمك بنجاح',
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              onCancel: () {
                print('Rating popup cancelled');
              },
            ),
          );
        }
      });
    }
  }

  // دالة للحصول على نوع الجهاز
  DeviceType _getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    if (screenWidth > 1200) {
      return DeviceType.desktop;
    } else if (screenWidth > 600) {
      return DeviceType.tablet;
    } else if (orientation == Orientation.landscape) {
      return DeviceType.mobileLandscape;
    } else {
      return DeviceType.mobilePortrait;
    }
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

      _controller!.addListener(_onPlayerStateChange);
    }
  }

  late int _currentChatId;
  Widget _buildQuestionDialog(LessonQuestion question) {
    switch (question.type) {
      case QuestionType.mcq:
        return FullScreenMcqDialog(
          question: question,
          onAnswerSubmitted: (List<int> selectedChoices, bool isCorrect) {
            Navigator.of(context).pop();

            // استخدام الطريقة الجديدة
            context.read<MarkAnsweredCubit>().submitChoiceAnswer(
              question.id!, // questionId
              question.lessonId!, // lessonId
              selectedChoices, // List<int> للاختيارات
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
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

            // استخدام الطريقة الجديدة
            context.read<MarkAnsweredCubit>().submitEssayAnswer(
              question.id!, // questionId
              question.lessonId!, // lessonId
              answer, // الإجابة النصية
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
          },
        );

      case QuestionType.fillBlank:
        int expectedLength = question.correctAnswers.isNotEmpty
            ? question.correctAnswers.first.title!.length
            : 5;
        return FillInBlanksDialog(
          question: question,
          onAnswerSubmitted: (String answer, bool isCorrect) {
            Navigator.of(context).pop();

            // استخدام الطريقة الجديدة
            context.read<MarkAnsweredCubit>().submitFillAnswer(
              question.id!, // questionId
              question.lessonId!, // lessonId
              answer, // الإجابة النصية
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
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
          onAnswerSubmitted: (Map<int, int> matchAnswers, bool isCorrect) {
            // تعديل النوع
            Navigator.of(context).pop();

            // استخدام الطريقة الجديدة
            context.read<MarkAnsweredCubit>().submitMatchAnswer(
              question.id!, // questionId
              question.lessonId!, // lessonId
              matchAnswers, // Map<int, int> للمطابقة
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
          },
        );

      case QuestionType.reOrder:
        return ReorderQuestionDialog(
          question: question,
          onAnswerSubmitted: (Map<int, int> orderAnswers, bool isCorrect) {
            // تعديل النوع
            Navigator.of(context).pop();

            // استخدام الطريقة الجديدة
            context.read<MarkAnsweredCubit>().submitReOrderAnswer(
              question.id!, // questionId
              question.lessonId!, // lessonId
              orderAnswers, // Map<int, int> للترتيب
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _controller?.play();
          },
        );
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
          _shownQuestions.clear(); // تنضيف الأسئلة المحلية بس
          // _shownQuestionsGlobally متتمسحش عشان تفضل محفوظة
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
  // أسئلة اتعرضت خلاص

  Future<void> _loadShownQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final shownList =
        prefs.getStringList('shown_questions_${widget.moduleId}') ?? [];
    setState(() {
      _shownQuestionsGlobally = shownList.toSet();
    });
    print('Loaded shown questions: $_shownQuestionsGlobally');
  }

  Future<void> _saveShownQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'shown_questions_${widget.moduleId}',
      _shownQuestionsGlobally.toList(),
    );
  }

  Future<void> _saveRewardedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final rewardedList = _rewardedLessons.map((e) => e.toString()).toList();
    await prefs.setStringList(
      'rewarded_lessons_${widget.moduleId}',
      rewardedList,
    );
    print('Saved rewarded lessons: $_rewardedLessons');
  }

  Future<void> _loadRewardedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final rewardedList =
        prefs.getStringList('rewarded_lessons_${widget.moduleId}') ?? [];
    setState(() {
      _rewardedLessons = rewardedList.map((e) => int.parse(e)).toSet();
    });
    print('Loaded rewarded lessons: $_rewardedLessons');
  }

  void _checkForQuestions(int currentSeconds) {
    if (_lessonQuestions.isEmpty) {
      return;
    }

    // التأكد من تحميل الـ rewarded lessons
    final lessonNotRewarded = !_rewardedLessons.contains(
      _currentSelectedItemId,
    );

    if (!lessonNotRewarded) {
      print(
        'Lesson $_currentSelectedItemId is already rewarded - skipping questions',
      );
      return;
    }

    for (final question in _lessonQuestions) {
      bool timeMatch =
          (currentSeconds >= question.timestamp &&
          currentSeconds <= question.timestamp + 2);

      // تحقق من الأسئلة المعروضة محلياً وعالمياً
      final questionKey = '${_currentSelectedItemId}_${question.id}';
      bool notShownYet =
          !_shownQuestions.contains(question.id) &&
          !_shownQuestionsGlobally.contains(questionKey);

      if (timeMatch && notShownYet) {
        _shownQuestions.add(question.id);
        _shownQuestionsGlobally.add(questionKey);
        _saveShownQuestions(); // حفظ في التخزين

        _controller?.pause();
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _buildQuestionDialog(question),
            // باقي الكود...
          ),
        );
        break;
      }
    }
  }

  void _updateLessonQuestions(LessonDetailsResponse lessonDetails) {
    List<LessonQuestion> allQuestions = [];

    try {
      print('Raw groupedQuestions: ${lessonDetails.groupedQuestions}');

      lessonDetails.groupedQuestions.forEach((timestampKey, questionsData) {
        print('Processing timestamp: $timestampKey with data: $questionsData');

        int timestamp;
        try {
          timestamp = int.parse(timestampKey);
        } catch (e) {
          print('Error parsing timestamp $timestampKey: $e');
          return;
        }

        if (questionsData is List) {
          for (var questionData in questionsData) {
            try {
              print('Processing question data: $questionData');

              if (questionData is Map<String, dynamic>) {
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

      allQuestions.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      setState(() {
        _lessonQuestions = allQuestions;
      });
    } catch (e) {
      print('❌ Error processing grouped questions: $e');
      print('Stack trace: ${StackTrace.current}');
      setState(() {
        _lessonQuestions = [];
        _shownQuestions.clear();
      });
    }
  }

  // بناء الفيديو مع أحجام responsive
  Widget _buildVideoPlayer(DeviceType deviceType) {
    if (_controller == null) return const SizedBox.shrink();

    double videoHeight;
    EdgeInsets margin;

    switch (deviceType) {
      case DeviceType.mobilePortrait:
        videoHeight = 220;
        margin = const EdgeInsets.all(16);
        break;
      case DeviceType.mobileLandscape:
        videoHeight = MediaQuery.of(context).size.height * 0.6;
        margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        break;
      case DeviceType.tablet:
        videoHeight = 300;
        margin = const EdgeInsets.all(20);
        break;
      case DeviceType.desktop:
        videoHeight = 400;
        margin = const EdgeInsets.all(24);
        break;
    }

    return Container(
      height: videoHeight,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
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

              _questionCheckTimer?.cancel();
              _questionCheckTimer = Timer.periodic(const Duration(seconds: 1), (
                timer,
              ) {
                if (_controller != null && _isPlayerReady && mounted) {
                  final currentSeconds = _controller!.value.position.inSeconds;
                  _checkForQuestions(currentSeconds);
                }
              });
            }
          },
          onEnded: (data) {
            if (mounted && !_isDisposing) {
              print('Video ended: ${data.videoId}');
              _questionCheckTimer?.cancel();
              if (_isFirstVideo && !_hasShownRatingPopup) {
                _showRatingPopupIfNeeded();
              }
            }
          },
        ),
      ),
    );
  }

  void _resumeVideo() {
    if (_controller != null && _isPlayerReady && mounted && !_isDisposing) {
      try {
        _controller!.play();
        print('Video resumed successfully');
      } catch (e) {
        print('Error resuming video: $e');
        // إعادة تهيئة الفيديو إذا فشل
        if (_currentVideoId != null) {
          _controller!.load(_currentVideoId!);
        }
      }
    }
  }

  // بناء الأزرار مع responsive design
  Widget _buildActionButtons(DeviceType deviceType) {
    double fontSize;
    EdgeInsets padding;
    double spacing;
    double buttonHeight;

    switch (deviceType) {
      case DeviceType.mobilePortrait:
        fontSize = 12;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        spacing = 8;
        buttonHeight = 60;
        break;
      case DeviceType.mobileLandscape:
        fontSize = 11;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        spacing = 6;
        buttonHeight = 50;
        break;
      case DeviceType.tablet:
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
        spacing = 10;
        buttonHeight = 70;
        break;
      case DeviceType.desktop:
        fontSize = 15;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        spacing = 12;
        buttonHeight = 80;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 80,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildButton("اسأل الذكاء الاصطناعي", "assets/icons/bot.png", () {
              _openExternalLink("https://chatgpt.com/");
            }),
            _buildButton("اسأل المعلم", "assets/icons/message.png", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => ChatCubit(
                      context.read<ChatRepo>(), // ✅ بجيب الـ repo من الـ main
                      _currentChatId!, // رقم الشات
                      widget.user, // اليوزر اللى جه من loginResponse
                    )..loadChat(),
                    child: ChatScreen(
                      chatId: _currentChatId!,
                      user: widget.user,
                    ),
                  ),
                ),
              );
            }),
            _buildButton(
              "الملازم الالكترونيه",
              "assets/icons/open-book.png",
              () {},
            ),
            _buildButton("الفيديوهات", "assets/icons/play.png", () {}),
          ],
        ),
      ),
    );
  }

  // بناء قائمة الدروس مع responsive design
  Widget _buildLessonsList(
    List<dynamic> lessons,
    List<dynamic> externalSources,
    DeviceType deviceType,
  ) {
    double borderRadius;
    EdgeInsets contentPadding;
    double fontSize;

    switch (deviceType) {
      case DeviceType.mobilePortrait:
        borderRadius = 20;
        contentPadding = const EdgeInsets.all(16);
        fontSize = 16;
        break;
      case DeviceType.mobileLandscape:
        borderRadius = 16;
        contentPadding = const EdgeInsets.all(12);
        fontSize = 14;
        break;
      case DeviceType.tablet:
        borderRadius = 24;
        contentPadding = const EdgeInsets.all(20);
        fontSize = 18;
        break;
      case DeviceType.desktop:
        borderRadius = 28;
        contentPadding = const EdgeInsets.all(24);
        fontSize = 20;
        break;
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Mycolors.darkblue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: contentPadding,
              child: Center(
                child: Text(
                  "الحصص المسجله",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: BlocBuilder<MarkAnsweredCubit, MarkAnsweredState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: (lessons.length + externalSources.length),
                    itemBuilder: (context, index) {
                      if (index < lessons.length) {
                        final item = lessons[index];
                        final lesson = item.lesson!;
                        final isSelected = _currentSelectedItemId == item.id;
                        final isRewarded = _rewardedLessons.contains(item.id);

                        return RecordedLessonItem(
                          title: lesson.title,
                          type: item.itemType,
                          isSelected: isSelected,
                          lessonRewarded: isRewarded, // تمرير حالة المكافأة
                          onTap: () {
                            if (!mounted || _isDisposing) return;

                            print('Tapping on lesson: ${item.id}');
                            setState(() {
                              _currentSelectedItemId = item.id;
                              _currentLessonTitle = lesson.title;
                            });

                            _questionCheckTimer?.cancel();
                            context
                                .read<LessonDetailsCubit>()
                                .emitLessonDetailsStates(item.id);
                          },
                        );
                      } else {
                        final sourceIndex = index - lessons.length;
                        final item = externalSources[sourceIndex];
                        final externalSource = item.externalSource!;
                        final isSelected = _currentSelectedItemId == item.id;

                        return RecordedLessonItem(
                          title: externalSource.title,
                          type: item.itemType,
                          isSelected: isSelected,
                          lessonRewarded:
                              false, // المصادر الخارجية مافيهاش مكافآت
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = _getDeviceType(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    int _currentChatId;
    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Mycolors.backgroundColor,
        elevation: 0,
        title: Image.asset("assets/images/footer-logo.webp", height: 40),
        actions: [
          Container(
            padding: const EdgeInsets.all(2),
            width: 70,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff4f2349), Color(0xffa76433)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0XFF0f1217),
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<LessonDetailsCubit, LessonDetailsState>(
            listener: (context, state) {
              if (!mounted || _isDisposing) return;

              print('LessonDetailsState changed: $state');
              state.whenOrNull(
                success: (lessonDetails) {
                  _updateCurrentLessonTitle(lessonDetails.title ?? "");

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
          BlocListener<LessonDetailsCubit, LessonDetailsState>(
            listener: (context, state) {
              if (!mounted || _isDisposing) return;

              print('LessonDetailsState changed: $state');
              state.whenOrNull(
                success: (lessonDetails) {
                  // تحديث الأسئلة أولاً
                  _updateLessonQuestions(lessonDetails);
                  _currentChatId = lessonDetails.chatId;
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
          BlocListener<MarkAnsweredCubit, MarkAnsweredState>(
            listener: (context, state) {
              state.when(
                success: (data) {
                  final isLastReward = data.lessonRewarded ?? false;
                  print(
                    'LastReward received: $isLastReward for lesson: $_currentSelectedItemId',
                  );

                  if (isLastReward && _currentSelectedItemId != null) {
                    print(
                      'Adding lesson $_currentSelectedItemId to rewarded lessons',
                    );
                    setState(() {
                      _rewardedLessons.add(_currentSelectedItemId!);
                    });
                    _saveRewardedLessons();
                    print('Current rewarded lessons: $_rewardedLessons');
                  }
                },
                error: (error) {
                  _showErrorDialog("خطأ في إرسال الإجابة: $error");
                },
                loading: () {},
                initial: () {},
              );
            },
          ),
          BlocListener<TestimonalCubit, TestimonalState>(
            listener: (context, state) {
              state.when(
                success: (data) {
                  if (data is String) {
                    // رسالة نجاح من إرسال التقييم
                    print('Rating submitted successfully: $data');
                  }
                },
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'خطأ في إرسال التقييم: $error',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                loading: () {
                  print('Submitting rating...');
                },
                initial: () {},
              );
            },
          ),
          BlocListener<ModuleLessonsCubit, ModuleLessonsState>(
            listener: (context, state) {
              state.whenOrNull(
                success: (module) {
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
                _checkIfFirstVideo(lessons);
                final externalSources =
                    module.items
                        ?.where((item) => item.externalSource != null)
                        .toList() ??
                    [];

                // تخطيط مختلف للـ landscape والـ tablet
                if (isLandscape && deviceType != DeviceType.mobilePortrait) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            videoHeader(
                              _currentLessonTitle,
                              context,
                              deviceType,
                            ),
                            _buildVideoPlayer(deviceType),
                            _buildActionButtons(deviceType),
                          ],
                        ),
                      ),
                      // الجانب الأيمن - قائمة الدروس
                      Expanded(
                        flex: 2,
                        child: _buildLessonsList(
                          lessons,
                          externalSources,
                          deviceType,
                        ),
                      ),
                    ],
                  );
                } else {
                  // التخطيط العمودي للـ portrait
                  return Column(
                    children: [
                      videoHeader(_currentLessonTitle, context, deviceType),

                      _buildVideoPlayer(deviceType),
                      _buildActionButtons(deviceType),
                      _buildLessonsList(lessons, externalSources, deviceType),
                    ],
                  );
                }
              },
              error: (error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "خطأ في تحميل البيانات",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
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
                      child: const Text(
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
        title: const Text(
          "فتح رابط خارجي",
          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        content: Text(
          "هل تريد فتح هذا الرابط؟\n$url",
          style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "إلغاء",
              style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _launchUrl(url);
            },
            child: const Text(
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
        title: const Text(
          "خطأ",
          style: TextStyle(color: Colors.red, fontFamily: 'Cairo'),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
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

// enum لتحديد نوع الجهاز
enum DeviceType { mobilePortrait, mobileLandscape, tablet, desktop }
