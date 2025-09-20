import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class ResponsiveMatchDialog extends StatefulWidget {
  final LessonQuestion question;
  final Function(bool isCorrect) onAnswerSubmitted;
  final VoidCallback onSkip;

  const ResponsiveMatchDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<ResponsiveMatchDialog> createState() => _ResponsiveMatchDialogState();
}

class _ResponsiveMatchDialogState extends State<ResponsiveMatchDialog> {
  late List<Prompt> _prompts;
  late List<ResponseModel> _responses;
  Map<int, int?> _matches = {}; // promptIndex -> responseIndex
  bool _showResult = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _prompts = List.from(widget.question.prompts);
    _responses = widget.question.prompts
        .where((p) => p.response != null)
        .map((p) => p.response!)
        .toList();

    // خلط الإجابات بشكل عشوائي
    _responses.shuffle();
  }

  void _submitAnswer() {
    // تحقق من صحة الإجابات
    bool allCorrect = true;

    for (int i = 0; i < _prompts.length; i++) {
      int? responseIndex = _matches[i];
      if (responseIndex == null ||
          _responses[responseIndex].id != _prompts[i].response?.id) {
        allCorrect = false;
        break;
      }
    }

    setState(() {
      _isCorrect = allCorrect;
      _showResult = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onAnswerSubmitted(_isCorrect);
      }
    });
  }

  bool get _isAnswerComplete {
    return _matches.length == _prompts.length &&
        !_matches.values.contains(null);
  }

  void _handleResponseTap(int responseIndex) {
    // البحث عن أول سؤال غير مربوط
    int? availablePromptIndex;
    for (int i = 0; i < _prompts.length; i++) {
      if (!_matches.containsKey(i)) {
        availablePromptIndex = i;
        break;
      }
    }

    if (availablePromptIndex != null) {
      setState(() {
        _matches[availablePromptIndex!] = responseIndex;
      });
    }
  }

  void _handlePromptTap(int promptIndex) {
    // إلغاء الربط
    setState(() {
      _matches.remove(promptIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD32F2F), Color(0xFFE53935), Color(0xFFEF5350)],
          ),
        ),
        child: SafeArea(
          child: _showResult ? _buildResultScreen() : _buildMatchContent(),
        ),
      ),
    );
  }

  Widget _buildMatchContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isLandscape = constraints.maxWidth > constraints.maxHeight;
        bool isTablet = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              SizedBox(height: isTablet ? 20 : 16),

              // Instructions
              Container(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "اضغط على الإجابات لربطها بالأسئلة بالترتيب",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: isTablet ? 24 : 20),

              // Content
              Expanded(child: _buildGridContent(isLandscape, isTablet)),

              // Bottom section
              _buildBottomSection(isTablet),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Text(
                "وصل بالترتيب",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: widget.onSkip,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildGridContent(bool isLandscape, bool isTablet) {
    int crossAxisCount = isTablet ? 3 : 2;
    if (isLandscape && !isTablet) crossAxisCount = 3;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Questions Grid
          Container(
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  "الأسئلة",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isTablet ? 1.5 : 1.3,
                  ),
                  itemCount: _prompts.length,
                  itemBuilder: (context, index) {
                    final prompt = _prompts[index];
                    final isMatched = _matches.containsKey(index);
                    final matchedResponseIndex = _matches[index];

                    return GestureDetector(
                      onTap: isMatched ? () => _handlePromptTap(index) : null,
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 12 : 8),
                        decoration: BoxDecoration(
                          color: isMatched
                              ? Colors.green.withOpacity(0.8)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMatched ? Colors.green : Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Number
                            Container(
                              width: isTablet ? 35 : 30,
                              height: isTablet ? 35 : 30,
                              decoration: BoxDecoration(
                                color: isMatched ? Colors.white : Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isMatched
                                        ? Colors.green
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: isTablet ? 8 : 6),

                            // Image if available
                            if (prompt.image != null) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  prompt.image!.url,
                                  width: isTablet ? 40 : 30,
                                  height: isTablet ? 40 : 30,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: isTablet ? 40 : 30,
                                      height: isTablet ? 40 : 30,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image,
                                        size: isTablet ? 20 : 15,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: isTablet ? 6 : 4),
                            ],

                            // Question text
                            Expanded(
                              child: Text(
                                _cleanHtmlText(prompt.title),
                                style: TextStyle(
                                  color: isMatched
                                      ? Colors.white
                                      : Colors.black87,
                                  fontFamily: 'Cairo',
                                  fontSize: isTablet ? 12 : 10,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Show matched response
                            if (isMatched && matchedResponseIndex != null) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _responses[matchedResponseIndex].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                    fontSize: isTablet ? 10 : 8,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: isTablet ? 24 : 20),

          // Responses Grid
          Container(
            padding: EdgeInsets.all(isTablet ? 16 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  "الإجابات - اضغط للربط",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 16 : 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isTablet ? 2.0 : 1.8,
                  ),
                  itemCount: _responses.length,
                  itemBuilder: (context, index) {
                    final response = _responses[index];
                    final isUsed = _matches.containsValue(index);

                    return GestureDetector(
                      onTap: isUsed ? null : () => _handleResponseTap(index),
                      child: Container(
                        padding: EdgeInsets.all(isTablet ? 12 : 8),
                        decoration: BoxDecoration(
                          color: isUsed
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isUsed ? Colors.grey : Colors.orange,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            response.title,
                            style: TextStyle(
                              color: isUsed ? Colors.grey[600] : Colors.black87,
                              fontFamily: 'Cairo',
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool isTablet) {
    return Column(
      children: [
        // Progress
        Container(
          margin: EdgeInsets.symmetric(vertical: isTablet ? 20 : 16),
          child: Text(
            "مربوط: ${_matches.length} من ${_prompts.length}",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onSkip,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "تخطي",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isAnswerComplete ? _submitAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAnswerComplete
                      ? Colors.white
                      : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  "تحقق من الإجابة",
                  style: TextStyle(
                    color: _isAnswerComplete
                        ? const Color(0xFFD32F2F)
                        : Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: _isCorrect
              ? Colors.green.withOpacity(0.9)
              : Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (_isCorrect ? Colors.green : Colors.red).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    _isCorrect ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              _isCorrect ? "إجابة صحيحة!" : "إجابة خاطئة!",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isCorrect
                  ? "لقد ربطت كل الأسئلة بإجاباتها الصحيحة"
                  : "بعض الروابط غير صحيحة، حاول مرة أخرى",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
