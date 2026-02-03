import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';

class DialogHelper {
  final BuildContext context;

  DialogHelper(this.context);

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1c2128),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 16),
            Text('جاري تحميل الملف...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void showFileOptionsDialog(String filePath) {
    final fileName = filePath.split('/').last;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1c2128),
        title: const Text(
          'تم تحميل الملف',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تم حفظ الملف: $fileName',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'لا يوجد تطبيق لفتح هذا النوع من الملفات',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void showFullScreenImage(
    String imageUrl,
    String Function(String) buildImageUrl,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Scaffold(
              backgroundColor: Mycolors.cardColor1,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.network(
                      buildImageUrl(imageUrl),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.red,
                          size: 100,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditDialog(MessageModel msg, ChatCubit cubit) {
    final controller = TextEditingController(text: msg.message);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1c2128),
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              const Text(
                "تعديل الرسالة",
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(106, 114, 130, 1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(106, 114, 130, 1)),
              ),
              hintText: 'قم بتعديل الرسالة هنا...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(21, 26, 40, 1),
                ),
              ),
              onPressed: () {
                final newMessage = controller.text.trim();
                if (newMessage.isNotEmpty) {
                  cubit.editMessage(msg.id!, newMessage);
                  Navigator.pop(context);
                  showSuccess('تم تعديل الرسالة بنجاح');
                } else {
                  showError('لا يمكن أن تكون الرسالة فارغة');
                }
              },
              child: const Text("تعديل", style: TextStyle(color: Colors.grey)),
            ),
            SizedBox(width: 80),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(150, 207, 3, 3),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }
}
