import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/CoursesModules/data/models/lesson_details_response.dart';

class QuestionDialog extends StatefulWidget {
  final VideoQuestion question;
  final Function(String) onAnswerSubmitted;
  final VoidCallback onSkip;

  const QuestionDialog({
    Key? key,
    required this.question,
    required this.onAnswerSubmitted,
    required this.onSkip,
  }) : super(key: key);

  @override
  State<QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<QuestionDialog> {
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Mycolors.darkblue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.quiz, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "سؤال تفاعلي - ${_formatTime(widget.question.timestamp)}",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Text(
              _cleanHtmlText(widget.question.title),
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _answerController,
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: "اكتب إجابتك هنا...",
              hintStyle: TextStyle(color: Colors.white60, fontFamily: 'Cairo'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            maxLines: 3,
            textAlign: TextAlign.right,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onSkip,
          child: Text(
            "تخطي",
            style: TextStyle(color: Colors.white60, fontFamily: 'Cairo'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final answer = _answerController.text.trim();
            if (answer.isNotEmpty) {
              widget.onAnswerSubmitted(answer);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "إرسال",
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
          ),
        ),
      ],
    );
  }

  String _cleanHtmlText(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "${minutes}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
