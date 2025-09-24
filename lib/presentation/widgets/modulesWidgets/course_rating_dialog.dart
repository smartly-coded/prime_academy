// course_rating_dialog.dart
import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/studentsTestimonals/data/models/students_testimonals_request.dart';

class CourseRatingDialog extends StatefulWidget {
  final int courseId;
  final Function(StudentsTestimonalsRequest) onSubmitRating;
  final VoidCallback? onCancel;

  const CourseRatingDialog({
    super.key,
    required this.courseId,
    required this.onSubmitRating,
    this.onCancel,
  });

  @override
  State<CourseRatingDialog> createState() => _CourseRatingDialogState();
}

class _CourseRatingDialogState extends State<CourseRatingDialog> {
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitRating() {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    // إنشاء request object للتقييم
    final ratingRequest = StudentsTestimonalsRequest(
      // املأ البيانات المطلوبة حسب الـ model بتاعك
      content: _reviewController.text.trim().isNotEmpty
          ? _reviewController.text.trim()
          : "تقييم رائع للكورس",
      courseId: widget.courseId,
      // أي بيانات أخرى مطلوبة
    );

    widget.onSubmitRating(ratingRequest);
    Navigator.of(context).pop();
  }

  void _cancelRating() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Mycolors.darkblue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          Text(
            'تقييم الكورس',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 3,
                maxLength: 300,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب تقييمك هنا',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontFamily: 'Cairo',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  counterStyle: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // زر الإلغاء
        TextButton(
          onPressed: _isSubmitting ? null : _cancelRating,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            'تخطي',
            style: TextStyle(
              color: _isSubmitting ? Colors.white24 : Colors.white54,
              fontFamily: 'Cairo',
              fontSize: 16,
            ),
          ),
        ),

        // زر الإرسال
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4f2349), Color(0xffa76433)],
            ),

            borderRadius: BorderRadius.circular(25),
          ),
          child: TextButton(
            onPressed: (!_isSubmitting) ? _submitRating : null,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: _isSubmitting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                    ),
                  )
                : Text(
                    'إرسال التقييم',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
