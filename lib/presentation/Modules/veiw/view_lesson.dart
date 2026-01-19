import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/Utils/GlobalLoadingCubit.dart';
import 'package:prime_academy/core/di/dependency_injection.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_state.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/mark_answered_state.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_state.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_cubit.dart';
import 'package:prime_academy/features/studentsTestimonals/logic/testimonal_state.dart';
import 'package:prime_academy/layout/app_layout.dart';
import 'package:prime_academy/layout/custom_app_bar.dart';
import 'package:prime_academy/presentation/Chat/ChatPage1.dart';
import 'package:prime_academy/presentation/Modules/veiw/video_header.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/course_rating_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/essay_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/fill_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/choose_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/match_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/materials.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/reorder_question_dialog.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/youtube_webview_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/CoursesModules/data/models/module_lessons_response_model.dart';

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
  GlobalKey<YouTubeWebViewPlayerState>? _playerKey;
  int? _currentSelectedItemId;
  String? _currentVideoId;
  bool _isDisposing = false;
  List<LessonQuestion> _lessonQuestions = [];
  final Set<int> _shownQuestions = {};
  Timer? _questionCheckTimer;
  bool _isPlayerReady = false;
  String _currentLessonTitle = "";
  Set<int> _rewardedLessons = {};
  bool _isFirstVideo = false;
  bool _hasShownRatingPopup = false;
  Set<String> _shownRatingForCourses = {};
  Set<String> _shownQuestionsGlobally = {};
  late int _currentChatId;

  void _updateCurrentLessonTitle(String title) {
    setState(() {
      _currentLessonTitle = title;
    });
  }

  String _formatVideoLength(int videoLengthInSeconds) {
    try {
      int minutes = videoLengthInSeconds ~/ 60;
      int seconds = videoLengthInSeconds % 60;
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } catch (e) {
      return "00:00";
    }
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

    lessons.sort((a, b) => a.id.compareTo(b.id));
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

      final testimonalCubit = context.read<TestimonalCubit>();

      Future.delayed(Duration(seconds: 1), () {
        if (mounted && !_isDisposing) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => CourseRatingDialog(
              courseId: widget.courseId,
              onSubmitRating: (ratingRequest) {
                testimonalCubit.sendStudentTestimonal(ratingRequest);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('شكراً لك! تم إرسال تقييمك بنجاح'),
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

  String? _extractYouTubeId(String url) {
    final regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  void _initializePlayer(String url) {
    if (_isDisposing || !mounted) return;

    final videoId = _extractYouTubeId(url);
    if (videoId != null && _currentVideoId != videoId) {
      setState(() {
        _currentVideoId = videoId;
        _isPlayerReady = false;
        _playerKey = GlobalKey<YouTubeWebViewPlayerState>();
      });
    }
  }

  Widget _buildQuestionDialog(LessonQuestion question) {
    switch (question.type) {
      case QuestionType.mcq:
        return FullScreenMcqDialog(
          question: question,
          onAnswerSubmitted: (List<int> selectedChoices, bool isCorrect) {
            Navigator.of(context).pop();

            context.read<MarkAnsweredCubit>().submitChoiceAnswer(
              question.id,
              question.lessonId,
              selectedChoices,
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _playerKey?.currentState?.play();
            print('Question skipped');
          },
        );

      case QuestionType.essay:
        return EssayQuestionDialog(
          question: question,
          onAnswerSubmitted: (String answer, bool isCorrect) {
            Navigator.of(context).pop();

            context.read<MarkAnsweredCubit>().submitEssayAnswer(
              question.id,
              question.lessonId,
              answer,
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _playerKey?.currentState?.play();
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

            context.read<MarkAnsweredCubit>().submitFillAnswer(
              question.id,
              question.lessonId,
              answer,
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _playerKey?.currentState?.play();
          },
          expectedLength: expectedLength,
        );

      case QuestionType.match:
        return ResponsiveMatchDialog(
          question: question,
          onAnswerSubmitted: (Map<int, int> matchAnswers, bool isCorrect) {
            Navigator.of(context).pop();

            context.read<MarkAnsweredCubit>().submitMatchAnswer(
              question.id,
              question.lessonId,
              matchAnswers,
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _playerKey?.currentState?.play();
          },
        );

      case QuestionType.reOrder:
        return ReorderQuestionDialog(
          question: question,
          onAnswerSubmitted: (Map<int, int> orderAnswers, bool isCorrect) {
            Navigator.of(context).pop();

            context.read<MarkAnsweredCubit>().submitReOrderAnswer(
              question.id,
              question.lessonId,
              orderAnswers,
            );
            Future.delayed(const Duration(milliseconds: 300), () {
              _resumeVideo();
            });
          },
          onSkip: () {
            Navigator.of(context).pop();
            _playerKey?.currentState?.play();
          },
        );
    }
  }

  void _changeVideo(String url) {
    if (_isDisposing || !mounted) return;

    final videoId = _extractYouTubeId(url);
    if (videoId != null && _currentVideoId != videoId) {
      print('Loading new video: $videoId');

      setState(() {
        _currentVideoId = videoId;
        _isPlayerReady = false;
        _shownQuestions.clear();
        _playerKey = GlobalKey<YouTubeWebViewPlayerState>();
      });
    }
  }

  void _safeDisposeController() {
    _questionCheckTimer?.cancel();
    _questionCheckTimer = null;
    _playerKey = null;
    _currentVideoId = null;
    _isPlayerReady = false;
  }

  @override
  void dispose() {
    _isDisposing = true;
    _safeDisposeController();
    super.dispose();
  }

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

      final questionKey = '${_currentSelectedItemId}_${question.id}';
      bool notShownYet =
          !_shownQuestions.contains(question.id) &&
          !_shownQuestionsGlobally.contains(questionKey);

      if (timeMatch && notShownYet) {
        _shownQuestions.add(question.id);
        _shownQuestionsGlobally.add(questionKey);
        _saveShownQuestions();

        _playerKey?.currentState?.pause();

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _buildQuestionDialog(question),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
        break;
      }
    }
  }

  void _checkForQuestionsAtPosition(Duration position) {
    if (_lessonQuestions.isEmpty) {
      return;
    }

    final lessonNotRewarded = !_rewardedLessons.contains(
      _currentSelectedItemId,
    );

    if (!lessonNotRewarded) {
      print(
        'Lesson $_currentSelectedItemId is already rewarded - skipping questions',
      );
      return;
    }

    final currentSeconds = position.inSeconds;

    for (final question in _lessonQuestions) {
      bool timeMatch =
          (currentSeconds >= question.timestamp &&
          currentSeconds <= question.timestamp + 2);

      final questionKey = '${_currentSelectedItemId}_${question.id}';
      bool notShownYet =
          !_shownQuestions.contains(question.id) &&
          !_shownQuestionsGlobally.contains(questionKey);

      if (timeMatch && notShownYet) {
        _shownQuestions.add(question.id);
        _shownQuestionsGlobally.add(questionKey);
        _saveShownQuestions();

        _playerKey?.currentState?.pause();

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                _buildQuestionDialog(question),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
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
        // print('Processing timestamp: $timestampKey with data: $questionsData');

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
              // print('Processing question data: $questionData');

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

  Widget _buildVideoPlayer(DeviceType deviceType) {
    if (_currentVideoId == null || _playerKey == null) {
      return const SizedBox.shrink();
    }

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
        // child:
        // HLSVideoPlayer(
        //   key: _playerKey,
        //   videoId: _currentVideoId!,
        //   autoPlay: true,
        //   onReady: () {
        //     if (!mounted || _isDisposing) return;
        //     setState(() {
        //       _isPlayerReady = true;
        //     });
        //     _showRatingPopupIfNeeded();
        //   },
        //   onError: (error) {
        //     print('❌ Video error: $error');
        //   },
        //   onProgress: (position, duration) {
        //     if (!mounted || _isDisposing || !_isPlayerReady) return;
        //     // ✅ Just check for questions based on position
        //     _checkForQuestionsAtPosition(position);
        //   },
        //   onVideoEnd: () {
        //     if (!mounted || _isDisposing) return;
        //     print('🏁 Video ended');
        //   },
        // ),
        child: YouTubeWebViewPlayer(
          key: _playerKey,
          videoId: _currentVideoId!,
          autoPlay: true,
          showControls: true,
          onReady: () {
            if (!mounted || _isDisposing) return;
            setState(() {
              _isPlayerReady = true;
            });
            _showRatingPopupIfNeeded();
          },
          onError: (error) {
            print('❌ Video error: $error');
          },
          onProgress: (position, duration) {
            if (!mounted || _isDisposing || !_isPlayerReady) return;
            _checkForQuestionsAtPosition(position);
          },
          onVideoEnd: () {
            if (!mounted || _isDisposing) return;
            print('🏁 Video ended');
          },
        ),

        //             child: YouTubeWebViewPlayer(
        //   key: _playerKey,
        //   videoId: _currentVideoId!,
        //   autoPlay: true,
        //   onReady: () {
        //     if (!mounted || _isDisposing) return;

        //     setState(() {
        //       _isPlayerReady = true;
        //     });

        //     _showRatingPopupIfNeeded();
        //   },
        // ),
      ),
    );
  }

  void _resumeVideo() {
    if (_playerKey != null && _isPlayerReady && mounted && !_isDisposing) {
      try {
        _playerKey!.currentState?.play();
        print('Video resumed successfully');
      } catch (e) {
        print('Error resuming video: $e');
      }
    }
  }

  Widget _buildActionButtons(
    DeviceType deviceType,
    int moduleId,
    int courseId,
  ) {
    double fontSize;
    EdgeInsets padding;
    double spacing;
    double buttonHeight;

    switch (deviceType) {
      case DeviceType.mobilePortrait:
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 8);
        spacing = 8;
        buttonHeight = 60;
        break;
      case DeviceType.mobileLandscape:
        fontSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        spacing = 6;
        buttonHeight = 50;
        break;
      case DeviceType.tablet:
        fontSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
        spacing = 10;
        buttonHeight = 70;
        break;
      case DeviceType.desktop:
        fontSize = 20;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        spacing = 12;
        buttonHeight = 80;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<ModuleLessonsCubit, ModuleLessonsState>(
                builder: (context, state) {
                  return _buildButton(
                    "الملازم الالكترونيه",
                    "assets/icons/open-book.png",
                    () {
                      state.when(
                        initial: () {},
                        loading: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('جاري تحميل الملازم...'),
                            ),
                          );
                        },
                        success: (data) {
                          final materials = data.materials ?? [];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MaterialsPage(materials: materials),
                            ),
                          );
                        },
                        error: (errorMsg) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تعذر تحميل الملازم 😔 $errorMsg'),
                            ),
                          );
                        },
                      );
                    },
                    fontSize,
                    padding,
                    buttonHeight,
                  );
                },
              ),
              SizedBox(width: spacing),
              _buildButton(
                "الفيديوهات",
                "assets/icons/play.png",
                () {},
                fontSize,
                padding,
                buttonHeight,
              ),
            ],
          ),
          SizedBox(height: spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                "اسأل الذكاء الاصطناعي",
                "assets/icons/bot.png",
                () {
                  _openExternalLink("https://chatgpt.com/");
                },
                fontSize,
                padding,
                buttonHeight,
              ),
              SizedBox(width: spacing),
              _buildButton(
                "اسأل المعلم",
                "assets/icons/message.png",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => ChatCubit(
                          chatRepo: getIt<ChatRepo>(),
                          modulesLessonsRepo: getIt<ModulesLessonsRepo>(),
                          chatId: _currentChatId,
                          moduleId: moduleId,
                          courseId: courseId,
                          user: widget.user,
                        )..loadChat(),
                        child: ChatScreen(
                          chatId: _currentChatId,
                          user: widget.user,
                        ),
                      ),
                    ),
                  );
                },
                fontSize,
                padding,
                buttonHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String text,
    String imagePath,
    VoidCallback onTap,
    double fontSize,
    EdgeInsets padding,
    double buttonHeight,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          padding: padding,
          decoration: BoxDecoration(
            color: Mycolors.cardColor1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: 8),
              Image.asset(imagePath, width: 20, height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonItemContent(
    List<dynamic> items,
    int index,
    DeviceType deviceType,
  ) {
    print('📋 _buildLessonItemContent - Index: $index');

    try {
      final item = items[index] as Item;
      final isLesson = item.lesson != null;

      print('📋 Item ID: ${item.id}');
      print('📋 Is Lesson: $isLesson');

      if (isLesson) {
        print(
          '📋 Lesson externalUrl type: ${item.lesson?.externalUrl.runtimeType}',
        );
        print('📋 Lesson externalUrl value: ${item.lesson?.externalUrl}');
      }

      final title = isLesson ? item.lesson!.title : item.externalSource!.title;
      final duration = isLesson
          ? _formatVideoLength(item.lesson!.videoLength)
          : 'رابط';
      final thumbnailUrl = isLesson
          ? _extractThumbnailUrl(item.lesson!.thumbnail)
          : null;
      final accessWithoutEnrollment = isLesson
          ? item.lesson!.accessWithoutEnrollment
          : false;
      final watched = isLesson ? item.lesson!.watched : false;
      final cupColor = watched ? Colors.amber : Colors.grey;

      final videoUrl = isLesson
          ? _extractUrlFromDynamic(item.lesson?.externalUrl)
          : null;
      print('📋 Extracted videoUrl: $videoUrl (type: ${videoUrl.runtimeType})');

      return _buildCustomLessonItem(
        title: title,
        duration: duration,
        thumbnailUrl: thumbnailUrl,
        isVideo: isLesson,
        isSelected: _currentSelectedItemId == item.id,
        isRewarded: accessWithoutEnrollment,
        videoUrl: videoUrl,
        index: index,
        onTap: () {
          setState(() {
            _currentSelectedItemId = item.id;
            if (isLesson) {
              _currentLessonTitle = item.lesson!.title;
            }
          });
          if (isLesson) {
            _questionCheckTimer?.cancel();
            context.read<LessonDetailsCubit>().emitLessonDetailsStates(item.id);
          } else {
            _openExternalLink(item.externalSource!.url);
          }
        },
        deviceType: deviceType,
        cupColor: isLesson ? cupColor : null,
      );
    } catch (e, stackTrace) {
      print('❌❌❌ ERROR in _buildLessonItemContent: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Widget _buildLessonsList(
    List<dynamic> items,
    DeviceType deviceType, {
    bool isInRow = false,
  }) {
    double borderRadius;
    EdgeInsets contentPadding;
    double fontSize;
    double titleFontSize;
    double containerHeight;
    double listHeight;
    ValueNotifier<bool> lineFlip = ValueNotifier(false);

    switch (deviceType) {
      case DeviceType.mobilePortrait:
        borderRadius = 20;
        contentPadding = const EdgeInsets.all(16);
        fontSize = 14;
        titleFontSize = 24;
        containerHeight = 500;
        listHeight = 400;
        break;
      case DeviceType.mobileLandscape:
        borderRadius = 16;
        contentPadding = const EdgeInsets.all(12);
        fontSize = 12;
        titleFontSize = 18;
        containerHeight = isInRow ? double.infinity : 400;
        listHeight = isInRow ? double.infinity : 300;
        break;
      case DeviceType.tablet:
        borderRadius = 24;
        contentPadding = const EdgeInsets.all(20);
        fontSize = 16;
        titleFontSize = 24;
        containerHeight = isInRow ? double.infinity : 500;
        listHeight = isInRow ? double.infinity : 400;
        break;
      case DeviceType.desktop:
        borderRadius = 28;
        contentPadding = const EdgeInsets.all(24);
        fontSize = 18;
        titleFontSize = 26;
        containerHeight = isInRow ? double.infinity : 600;
        listHeight = isInRow ? double.infinity : 500;
        break;
    }

    return Container(
      height: isInRow ? null : containerHeight,
      constraints: isInRow ? BoxConstraints(minHeight: 300) : null,
      decoration: BoxDecoration(
        color: Mycolors.cardColor1.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Flexible(
            flex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Text(
                    "الحصص المسجلة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ValueListenableBuilder<bool>(
                  valueListenable: lineFlip,
                  builder: (context, isFlipped, _) {
                    return GestureDetector(
                      onTap: () {
                        lineFlip.value = !lineFlip.value;
                      },
                      child: Container(
                        height: 2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: Mycolors.primary_color.colors,
                            begin: isFlipped
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            end: isFlipped
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          isInRow
              ? Expanded(
                  child: ListView.builder(
                    itemCount: items.length,

                    itemBuilder: (context, index) {
                      return _buildLessonItemContent(items, index, deviceType);
                    },
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: false,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      print('📱 ListView.builder - Index: $index');

                      try {
                        final item = items[index] as Item;
                        final isLesson = item.lesson != null;

                        print('📱 Item ID: ${item.id}');
                        print('📱 Is Lesson: $isLesson');

                        if (isLesson) {
                          print(
                            '📱 Lesson externalUrl type: ${item.lesson?.externalUrl.runtimeType}',
                          );
                          print(
                            '📱 Lesson externalUrl value: ${item.lesson?.externalUrl}',
                          );
                        }

                        final title = isLesson
                            ? item.lesson!.title
                            : item.externalSource!.title;
                        final duration = isLesson
                            ? _formatVideoLength(item.lesson!.videoLength)
                            : 'رابط';
                        final thumbnailUrl = isLesson
                            ? _extractThumbnailUrl(item.lesson!.thumbnail)
                            : null;

                        final accessWithoutEnrollment = isLesson
                            ? item.lesson!.accessWithoutEnrollment
                            : false;
                        final watched = isLesson ? item.lesson!.watched : false;
                        final cupColor = watched ? Colors.amber : Colors.grey;

                        final videoUrl = isLesson
                            ? _extractUrlFromDynamic(item.lesson?.externalUrl)
                            : null;
                        print(
                          '📱 Extracted videoUrl: $videoUrl (type: ${videoUrl.runtimeType})',
                        );

                        return _buildCustomLessonItem(
                          title: title,
                          duration: duration,
                          thumbnailUrl: thumbnailUrl,
                          isVideo: isLesson,
                          isSelected: _currentSelectedItemId == item.id,
                          isRewarded: accessWithoutEnrollment,
                          videoUrl: videoUrl,
                          index: index,
                          onTap: () {
                            setState(() {
                              _currentSelectedItemId = item.id;
                              if (isLesson) {
                                _currentLessonTitle = item.lesson!.title;
                              }
                            });
                            if (isLesson) {
                              _questionCheckTimer?.cancel();
                              context
                                  .read<LessonDetailsCubit>()
                                  .emitLessonDetailsStates(item.id);
                            } else {
                              _openExternalLink(item.externalSource!.url);
                            }
                          },
                          deviceType: deviceType,
                          cupColor: isLesson ? cupColor : null,
                        );
                      } catch (e, stackTrace) {
                        print('❌❌❌ ERROR in ListView.builder itemBuilder: $e');
                        print('Stack trace: $stackTrace');

                        return Container(
                          height: 110,
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          color: Colors.red.withOpacity(0.3),
                          child: Center(
                            child: Text(
                              'Error loading item $index',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildCustomLessonItem({
    required String title,
    required String duration,
    required String? thumbnailUrl,
    required bool isVideo,
    required bool isSelected,
    required bool isRewarded,
    required int index,
    required VoidCallback onTap,
    required DeviceType deviceType,
    Color? cupColor,
    String? videoUrl,
  }) {
    double itemPadding;
    double iconSize;

    switch (deviceType) {
      case DeviceType.mobilePortrait:
        itemPadding = 16;
        iconSize = 24;
        break;
      case DeviceType.mobileLandscape:
        itemPadding = 12;
        iconSize = 20;
        break;
      case DeviceType.tablet:
        itemPadding = 20;
        iconSize = 28;
        break;
      case DeviceType.desktop:
        itemPadding = 24;
        iconSize = 32;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF0e3995cc).withOpacity(.19)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Color.fromARGB(14, 57, 67, 204).withOpacity(.99)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(itemPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.rtl,
            children: [
              _buildVideoThumbnailWithDuration(
                thumbnailUrl: thumbnailUrl,
                duration: duration,
                isVideo: isVideo,
                iconSize: iconSize,
                videoUrl: videoUrl,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceType == DeviceType.mobilePortrait
                            ? 14
                            : 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (cupColor != null) SizedBox(width: 8),
              if (cupColor != null)
                Icon(Icons.emoji_events, color: cupColor, size: iconSize),
            ],
          ),
        ),
      ),
    );
  }

  String? extractYouTubeId(String? url) {
    if (url == null || url.isEmpty) return null;
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host.contains("youtu.be")) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }

    if (uri.host.contains("youtube.com")) {
      return uri.queryParameters["v"];
    }

    return null;
  }

  String? _extractThumbnailUrl(dynamic thumbnail) {
    if (thumbnail == null) return null;
    if (thumbnail is String) return thumbnail;
    if (thumbnail is Map<String, dynamic>) {
      return thumbnail['url'] as String?;
    }
    return null;
  }

  String? _extractUrlFromDynamic(dynamic externalUrl) {
    print('🔍 _extractUrlFromDynamic called');
    print('🔍 Input type: ${externalUrl.runtimeType}');
    print('🔍 Input value: $externalUrl');

    if (externalUrl == null) {
      print('✅ externalUrl is null - returning null');
      return null;
    }

    if (externalUrl is String) {
      print('✅ externalUrl is String: $externalUrl');
      return externalUrl;
    }

    if (externalUrl is Map<String, dynamic>) {
      print('✅ externalUrl is Map - keys: ${externalUrl.keys.toList()}');
      final url =
          externalUrl['url'] as String? ??
          externalUrl['videoUrl'] as String? ??
          externalUrl['link'] as String?;
      print('✅ Extracted URL from Map: $url');
      return url;
    }

    print('⚠️ Unknown type: ${externalUrl.runtimeType}');
    return null;
  }

  Widget _buildVideoThumbnailWithDuration({
    required String? thumbnailUrl,
    required String duration,
    required bool isVideo,
    required double iconSize,
    String? videoUrl,
  }) {
    print('🎬 _buildVideoThumbnailWithDuration called');
    print('🎬 videoUrl type: ${videoUrl.runtimeType}');
    print('🎬 videoUrl value: $videoUrl');
    print('🎬 thumbnailUrl: $thumbnailUrl');

    try {
      if (isVideo && thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
        print('✅ Using server thumbnail');
        thumbnailUrl =
            "https://cdn.primeacademy.education/primeacademy$thumbnailUrl";

        return _buildNetworkThumb(thumbnailUrl, duration, iconSize, isVideo);
      }

      if (isVideo && videoUrl != null) {
        print('🎬 Attempting to extract YouTube ID from: $videoUrl');

        if (videoUrl is! String) {
          print(
            '❌ ERROR: videoUrl is not a String! Type: ${videoUrl.runtimeType}',
          );
          return _buildPlaceholderThumbnail(isVideo, iconSize, duration);
        }

        final videoId = extractYouTubeId(videoUrl);
        print('🎬 Extracted YouTube ID: $videoId');

        if (videoId != null) {
          final ytThumb = "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
          print('✅ Using YouTube thumbnail: $ytThumb');
          return _buildNetworkThumb(ytThumb, duration, iconSize, isVideo);
        }
      }

      print('ℹ️ Using placeholder thumbnail');
      return _buildPlaceholderThumbnail(isVideo, iconSize, duration);
    } catch (e, stackTrace) {
      print('❌❌❌ ERROR in _buildVideoThumbnailWithDuration: $e');
      print('Stack trace: $stackTrace');
      return _buildPlaceholderThumbnail(isVideo, iconSize, duration);
    }
  }

  Widget _buildNetworkThumb(
    String url,
    String duration,
    double iconSize,
    bool isVideo,
  ) {
    return Container(
      width: 100,
      height: 95,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              width: 100,
              height: 95,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderThumbnail(isVideo, iconSize, duration);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildPlaceholderThumbnail(isVideo, iconSize, duration);
              },
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                duration,
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderThumbnail(
    bool isVideo,
    double iconSize,
    String duration,
  ) {
    return Container(
      width: 100,
      height: 95,
      decoration: BoxDecoration(
        color: Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              isVideo ? Icons.play_arrow : Icons.link,
              color: Colors.white,
              size: 30,
            ),
          ),
          if (isVideo)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  duration,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🏗️ BUILD METHOD STARTED');
    print('🏗️ Current selected item: $_currentSelectedItemId');
    print('🏗️ Current video ID: $_currentVideoId');
    final deviceType = _getDeviceType(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Mycolors.backgroundColor,
      appBar: CustomAppBar(
        user: widget.user,
        onLogoPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppLayout(user: widget.user)),
          (route) => false,
        ),
        showBackArrow: true,
      ),
      body: MultiBlocListener(
        listeners: [
          // 🔧 FIXED VERSION - Replace lines 1453-1487 in view_lesson.dart
          BlocListener<LessonDetailsCubit, LessonDetailsState>(
            listener: (context, state) {
              if (!mounted || _isDisposing) return;

              print('LessonDetailsState changed: $state');
              state.whenOrNull(
                success: (lessonDetails) {
                  _updateLessonQuestions(lessonDetails);
                  _currentChatId = lessonDetails.chatId;
                  _updateCurrentLessonTitle(lessonDetails.title ?? "");

                  // ✅ FIX: Handle both String and Map types for externalUrl
                  String? url;

                  // Debug logging to understand the data structure
                  print(
                    '🔍 externalUrl type: ${lessonDetails.externalUrl.runtimeType}',
                  );
                  print('🔍 externalUrl value: ${lessonDetails.externalUrl}');

                  if (lessonDetails.externalUrl != null) {
                    if (lessonDetails.externalUrl is String) {
                      // Case 1: Direct YouTube URL string
                      url = lessonDetails.externalUrl as String;
                      print('✅ Extracted URL as String: $url');
                    } else if (lessonDetails.externalUrl is Map) {
                      // Case 2: URL wrapped in an object
                      final urlMap =
                          lessonDetails.externalUrl as Map<String, dynamic>;
                      // Try multiple possible keys
                      url =
                          urlMap['url'] as String? ??
                          urlMap['videoUrl'] as String? ??
                          urlMap['link'] as String? ??
                          urlMap['external_url'] as String?;
                      print('✅ Extracted URL from Map: $url');
                      print('🔍 Map keys available: ${urlMap.keys.toList()}');
                    } else {
                      print(
                        '⚠️ Unknown externalUrl type: ${lessonDetails.externalUrl.runtimeType}',
                      );
                    }
                  }

                  if (url != null && url.isNotEmpty) {
                    final videoId = _extractYouTubeId(url);
                    if (videoId != null) {
                      print('✅ YouTube video detected - ID: $videoId');

                      _changeVideo(url);
                    } else {
                      print('⚠️ Non-YouTube URL or invalid format: $url');
                      // TODO: Handle non-YouTube videos (HLS, MP4, etc.)
                      // For now, show an error or alternative player
                      if (mounted && !_isDisposing) {
                        _showErrorDialog(
                          'هذا الفيديو غير مدعوم حالياً. يدعم التطبيق فقط مقاطع يوتيوب.',
                        );
                      }
                    }
                  } else {
                    print('❌ No valid URL found in lesson details');
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
                    print('Rating submitted successfully: $data');
                  }
                },
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ في إرسال التقييم: $error'),
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
              print('🔔 ModuleLessonsState changed: $state');

              state.whenOrNull(
                success: (module) {
                  print('🎯🎯🎯 SUCCESS CALLBACK STARTED');
                  print('🎯🎯🎯 module is null: ${module == null}');
                  print('🎯🎯🎯 module type: ${module.runtimeType}');
                  if (_currentSelectedItemId == widget.itemId &&
                      _playerKey == null) {
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
            print('🏗️ BlocBuilder state: ${state.runtimeType}');
            return state.when(
              initial: () {
                return Center(
                  child: Text(
                    "جاري تحميل الدروس...",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
              loading: () {
                print('📱 State: LOADING');
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              },
              success: (module) {
                print('🎯🎯🎯 BUILDER SUCCESS STARTED');
                print('🎯🎯🎯 module is null: ${module == null}');
                print('🎯🎯🎯 module type: ${module.runtimeType}');
                try {
                  print('🎯 Accessing module.items...');

                  if (module.items != null) {
                    for (var i = 0; i < module.items!.length; i++) {
                      final item = module.items![i];
                      print(
                        '🎯 Item $i: id=${item.id}, lesson=${item.lesson != null}',
                      );
                      if (item.lesson != null) {
                        print('🎯   Lesson title: ${item.lesson!.title}');
                        print(
                          '🎯   externalUrl type: ${item.lesson!.externalUrl.runtimeType}',
                        );
                        print(
                          '🎯   externalUrl value: ${item.lesson!.externalUrl}',
                        );
                      }
                    }
                  }
                  final lessons =
                      module.items
                          ?.where((item) => item.lesson != null)
                          .toList() ??
                      [];

                  print('🎯 Filtered lessons count: ${lessons.length}');
                  _checkIfFirstVideo(lessons);
                  print('🎯 _checkIfFirstVideo completed');
                  final externalSources =
                      module.items
                          ?.where((item) => item.externalSource != null)
                          .toList() ??
                      [];
                  print('🎯 External sources count: ${externalSources.length}');
                  if (isLandscape && deviceType != DeviceType.mobilePortrait) {
                    print('🎯 Building landscape layout');
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                videoHeader(
                                  _currentLessonTitle,
                                  context,
                                  deviceType,
                                ),
                                _buildVideoPlayer(deviceType),
                                _buildActionButtons(
                                  deviceType,
                                  widget.courseId,
                                  widget.moduleId,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: _buildLessonsList(
                            module.items ?? [],
                            deviceType,
                            isInRow: true,
                          ),
                        ),
                      ],
                    );
                  } else {
                    print('🎯 Building portrait layout');
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          videoHeader(_currentLessonTitle, context, deviceType),
                          _buildVideoPlayer(deviceType),
                          _buildActionButtons(
                            deviceType,
                            widget.courseId,
                            widget.moduleId,
                          ),
                          SizedBox(height: 40),
                          _buildLessonsList(module.items ?? [], deviceType),
                        ],
                      ),
                    );
                  }
                } catch (e, stackTrace) {
                  print('❌❌❌ ERROR in ModuleLessonsState.success: $e');
                  print('Stack trace: $stackTrace');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        Text('Error: $e', style: TextStyle(color: Colors.red)),
                      ],
                    ),
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
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red.withOpacity(0.8),
                        fontSize: 14,
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
                        style: TextStyle(color: Colors.white),
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

  void _openExternalLink(String url) {
    if (!mounted || _isDisposing) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mycolors.darkblue,
        title: const Text(
          "فتح رابط خارجي",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "هل تريد فتح هذا الرابط؟\n$url",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _launchUrl(url);
            },
            child: const Text("فتح", style: TextStyle(color: Colors.white)),
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
        title: const Text("خطأ", style: TextStyle(color: Colors.red)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("موافق", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

enum DeviceType { mobilePortrait, mobileLandscape, tablet, desktop }
