import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/lesson_details_state.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_cubit.dart';
import 'package:prime_academy/features/CoursesModules/logic/module_lessons_state.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/lesson_item.dart';
import 'package:prime_academy/presentation/widgets/modulesWidgets/question_dialog.dart';
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
  int? _currentSelectedItemId;
  String? _currentVideoId; // لتتبع الفيديو الحالي
  bool _isDisposing = false; // فلاج لمنع العمليات أثناء التدمير
  LessonDetailsResponse? _currentLessonDetails;
  List<VideoQuestion> _lessonQuestions = [];
  List<int> _askedQuestionTimestamps = [];
  bool _isQuestionDialogOpen = false;
  @override
  void initState() {
    super.initState();
    _currentSelectedItemId = widget.itemId;
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
    }
  }

  // الحل الأفضل والأبسط - استخدام load method:
  void _changeVideo(String url) {
    if (_isDisposing || !mounted) return;

    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null && _currentVideoId != videoId) {
      print('Loading new video: $videoId');

      if (_controller != null) {
        // استخدام load method لتغيير الفيديو بدون إعادة إنشاء الcontroller
        setState(() {
          _currentVideoId = videoId;
        });
        _controller!.load(videoId);
      } else {
        // إنشاء controller جديد لو مش موجود
        _initializePlayer(url);
      }
    }
  }

  void _safeDisposeController() {
    if (_controller != null) {
      try {
        final tempController = _controller!;
        _controller = null;
        _currentVideoId = null;

        // تدمير الكنترولر في الـ frame التالي
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
                  _currentLessonDetails = lessonDetails;

                  // معالجة الأسئلة
                  _lessonQuestions = _parseQuestionsFromResponse(lessonDetails);
                  _askedQuestionTimestamps.clear();

                  print(
                    'Loaded ${_lessonQuestions.length} questions for this lesson',
                  );

                  print('Success: URL = ${lessonDetails.externalUrl}');
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
                              if (mounted && !_isDisposing) {
                                print('Player is ready.');
                              }
                            },
                            onEnded: (data) {
                              if (mounted && !_isDisposing) {
                                print('Video ended: ${data.videoId}');
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

  List<VideoQuestion> _parseQuestionsFromResponse(
    LessonDetailsResponse response,
  ) {
    List<VideoQuestion> questions = [];

    try {
      // التعامل مع groupedQuestions كـ Map<String, dynamic>
      response.groupedQuestions.forEach((timestampKey, questionsList) {
        final timestamp = int.tryParse(timestampKey);
        if (timestamp != null && questionsList is List) {
          for (var questionData in questionsList) {
            if (questionData is Map<String, dynamic>) {
              try {
                final question = VideoQuestion.fromJson(questionData);
                questions.add(question);
              } catch (e) {
                print('Error parsing question: $e');
                print('Question data: $questionData');
              }
            }
          }
        }
      });

      // ترتيب الأسئلة حسب الوقت
      questions.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (e) {
      print('Error parsing questions from response: $e');
    }

    return questions;
  }

  // تحديث التحقق من الأسئلة
  void _checkForQuestionsAtTime(int currentSeconds) {
    if (_lessonQuestions.isEmpty) return;

    // البحث عن أسئلة في هذا الوقت
    for (VideoQuestion question in _lessonQuestions) {
      if (!_askedQuestionTimestamps.contains(question.timestamp) &&
          currentSeconds >= question.timestamp &&
          currentSeconds <= question.timestamp + 2) {
        _askedQuestionTimestamps.add(question.timestamp);
        _showQuestionDialog(question);
        break;
      }
    }
  }

  // تحديث عرض dialog السؤال
  void _showQuestionDialog(VideoQuestion question) {
    if (!mounted || _isDisposing || _isQuestionDialogOpen) return;

    _isQuestionDialogOpen = true;

    // إيقاف الفيديو مؤقتاً
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuestionDialog(
        question: question,
        onAnswerSubmitted: (answer) {
          _isQuestionDialogOpen = false;
          Navigator.of(context).pop();

          // إعادة تشغيل الفيديو
          if (_controller != null && mounted && !_isDisposing) {
            _controller!.play();
          }

          _handleQuestionAnswer(question, answer);
        },
        onSkip: () {
          _isQuestionDialogOpen = false;
          Navigator.of(context).pop();

          if (_controller != null && mounted && !_isDisposing) {
            _controller!.play();
          }
        },
      ),
    );
  }

  // تحديث معالجة الإجابة
  void _handleQuestionAnswer(VideoQuestion question, String answer) {
    print('Question: ${question.title}');
    print('Answer: $answer');

    final isCorrect = _isAnswerCorrect(question, answer);

    if (isCorrect) {
      _showFeedback("إجابة صحيحة!", true);
    } else {
      final correctAnswer = question.correctAnswers.isNotEmpty
          ? question.correctAnswers.first.title
          : "غير متوفرة";
      _showFeedback("إجابة خاطئة. الإجابة الصحيحة: $correctAnswer", false);
    }

    // يمكن إرسال الإجابة للسيرفر هنا
    _submitAnswerToServer(question, answer, isCorrect);
  }

  void _showFeedback(String message, bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // التحقق من صحة الإجابة
  bool _isAnswerCorrect(VideoQuestion question, String userAnswer) {
    if (question.correctAnswers.isEmpty) return false;

    final cleanUserAnswer = userAnswer.trim().toLowerCase();

    return question.correctAnswers.any((correctAnswer) {
      final cleanCorrectAnswer = correctAnswer.title.trim().toLowerCase();

      // مقارنة مباشرة
      if (cleanUserAnswer == cleanCorrectAnswer) return true;

      // مقارنة الكلمات المفتاحية
      final userWords = cleanUserAnswer.split(' ');
      final correctWords = cleanCorrectAnswer.split(' ');

      // التحقق من وجود معظم الكلمات الصحيحة في إجابة المستخدم
      int matchCount = 0;
      for (String correctWord in correctWords) {
        if (userWords.any(
          (userWord) =>
              userWord.contains(correctWord) || correctWord.contains(userWord),
        )) {
          matchCount++;
        }
      }

      // إذا كان أكثر من 60% من الكلمات متطابقة
      return (matchCount / correctWords.length) >= 0.6;
    });
  }

  // إرسال الإجابة للسيرفر (اختياري)
  Future<void> _submitAnswerToServer(
    VideoQuestion question,
    String answer,
    bool isCorrect,
  ) async {
    try {
      // هنا يمكن إرسال البيانات للـ API
      final data = {
        'question_id': question.id,
        'lesson_id': question.lessonId,
        'user_answer': answer,
        'is_correct': isCorrect,
        'timestamp': question.timestamp,
        'answered_at': DateTime.now().toIso8601String(),
      };

      print('Submitting answer to server: $data');
      // await apiService.submitAnswer(data);
    } catch (e) {
      print('Error submitting answer: $e');
    }
  }

  // عرض معلومات إحصائية
  void _showQuestionStats() {
    final totalQuestions = _lessonQuestions.length;
    final answeredQuestions = _askedQuestionTimestamps.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Mycolors.darkblue,
        title: Text(
          "إحصائيات الأسئلة",
          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow("إجمالي الأسئلة", totalQuestions.toString()),
            _buildStatRow("الأسئلة المجابة", answeredQuestions.toString()),
            _buildStatRow(
              "المتبقي",
              (totalQuestions - answeredQuestions).toString(),
            ),
          ],
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

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }
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
