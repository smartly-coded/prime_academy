import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/Chat/logic/chat_state.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/Chat/media_file_record.dart';

// إضافة دوال التسجيل (أو ضعها في ملف منفصل وادعها)
Future<File?> showRecordingSheet(BuildContext context) async {
  return await showModalBottomSheet<File?>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    builder: (context) => const RecordingBottomSheet(),
  );
}

class RecordingBottomSheet extends StatefulWidget {
  const RecordingBottomSheet({Key? key}) : super(key: key);

  @override
  State<RecordingBottomSheet> createState() => _RecordingBottomSheetState();
}

class _RecordingBottomSheetState extends State<RecordingBottomSheet> {
  bool _isRecording = false;
  int _recordingTime = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRecording) {
        setState(() {
          _recordingTime++;
        });
        _startTimer();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xff1c2128),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mic,
            size: 64,
            color: _isRecording ? Colors.red : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _isRecording ? _formattedTime : '00:00',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
                child: IconButton(
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (_isRecording) {
                      // إيقاف التسجيل وإنشاء ملف
                      final directory = await getTemporaryDirectory();
                      final timestamp = DateTime.now().millisecondsSinceEpoch;
                      final filePath =
                          '${directory.path}/recording_$timestamp.m4a';
                      final file = File(filePath);
                      await file.writeAsBytes(
                        List.generate(1000, (index) => index % 256),
                      );
                      Navigator.pop(context, file);
                    } else {
                      setState(() {
                        _isRecording = true;
                      });
                    }
                  },
                ),
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor: _isRecording ? Colors.green : Colors.grey,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _isRecording
                      ? () async {
                          final directory = await getTemporaryDirectory();
                          final timestamp =
                              DateTime.now().millisecondsSinceEpoch;
                          final filePath =
                              '${directory.path}/recording_$timestamp.m4a';
                          final file = File(filePath);
                          await file.writeAsBytes(
                            List.generate(1000, (index) => index % 256),
                          );
                          Navigator.pop(context, file);
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final int chatId;
  final LoginResponse user;

  ChatScreen({super.key, required this.chatId, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();

  File? _pickedFile;

  @override
  void dispose() {
    if (ChatCubit.instance != null) {
      ChatCubit.instance!.closeSSE();
    }
    _controller.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();

    // تنظيف موارد التسجيل
    AudioRecorderManager.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ChatRepo(),
      child: BlocProvider(
        create: (context) {
          final repo = context.read<ChatRepo>();
          final cubit = ChatCubit(repo, widget.chatId, widget.user)..loadChat();
          return cubit;
        },
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatLoaded) {
              _scrollToBottom();
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is ChatError) {
              return Scaffold(
                body: Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }

            if (state is ChatLoaded) {
              final cubit = context.read<ChatCubit>();
              final messages = state.messages;
              final chatInfo = state.chatInfo;

              return Scaffold(
                backgroundColor: const Color(0xff0d1117),
                appBar: AppBar(
                  backgroundColor: const Color(0xff0d1117),
                  elevation: 0,
                  automaticallyImplyLeading: true,
                  title: const Text(
                    "اسألني لايف",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(2),
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.purple],
                        ),
                      ),
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageCard(
                            messages[index],
                            chatInfo,
                            context,
                          );
                        },
                      ),
                    ),
                    _buildFilePreview(),
                    _buildMessageInput(cubit),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFilePreview() {
    if (_pickedFile == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _pickedFile!.path.split('/').last,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() => _pickedFile = null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.black,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "اكتب رسالتك...",
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: const Color(0xff0d1117),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.blue),
              onPressed: () async {
                try {
                  File? file = await pickFile();
                  if (file != null) {
                    setState(() => _pickedFile = file);
                  }
                } catch (e) {
                  _showError('خطأ في اختيار الملف: $e');
                }
              },
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.blue),
              onPressed: () async {
                try {
                  // استخدام التسجيل التفاعلي الجديد
                  File? audio = await showRecordingDialog(context);
                  if (audio != null) {
                    cubit.sendMedia(audio);
                    _showSuccess('تم إرسال التسجيل بنجاح');
                  }
                } catch (e) {
                  _showError('خطأ في التسجيل: $e');
                }
              },
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                final text = _controller.text.trim();
                final file = _pickedFile;

                if (file != null) {
                  cubit.sendMedia(file, message: text.isNotEmpty ? text : null);
                  setState(() => _pickedFile = null);
                  _controller.clear();
                } else if (text.isNotEmpty) {
                  cubit.sendMessage(text);
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(
    MessageModel msg,
    ChatInfoModel chatInfo,
    BuildContext context,
  ) {
    bool isStudent = msg.senderRole == 1;
    String userName = isStudent ? chatInfo.name : "معلم";
    String role = isStudent ? "طالب" : "معلم";
    Color roleColor = Colors.purple;

    return Align(
      alignment: isStudent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Mycolors.darkblue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isStudent)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(
                          context,
                          msg,
                          context.read<ChatCubit>(),
                        );
                      } else if (value == 'delete') {
                        context.read<ChatCubit>().deleteMessage(msg.id!);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text("تعديل")),
                      const PopupMenuItem(value: 'delete', child: Text("حذف")),
                    ],
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                if (isStudent) const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isStudent)
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: _buildProfileImage(
                              chatInfo.imageUrl,
                            ),
                            backgroundColor: Colors.grey[800],
                            child:
                                chatInfo.imageUrl == null ||
                                    chatInfo.imageUrl!.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [roleColor, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (msg.message.isNotEmpty)
              Text(msg.message, style: const TextStyle(color: Colors.white)),
            if (msg.mediaUrl != null) _buildMedia(msg),
            const SizedBox(height: 4),
            Text(
              msg.createdAt.toString().substring(0, 16),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _buildProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final fullUrl = buildImageUrl(imageUrl);
    return _isValidUrl(fullUrl) ? NetworkImage(fullUrl) : null;
  }

  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('https://') || imagePath.startsWith('http://'))
      return imagePath;

    if (imagePath.startsWith('file://')) {
      imagePath = imagePath.substring(7);
    }
    if (imagePath.startsWith('file:')) {
      imagePath = imagePath.substring(5);
    }

    const String baseUrl =
        'https://cdn-dev.primeacademy.education/primeacademydev';
    return imagePath.startsWith('/')
        ? '$baseUrl$imagePath'
        : '$baseUrl/$imagePath';
  }

  Widget _buildMedia(MessageModel msg) {
    if (msg.media == null) return const SizedBox.shrink();
    final media = msg.media!;
    final fullUrl = buildImageUrl(media.url);

    if (media.mimeType?.startsWith('audio/') == true) {
      return _buildAudioWidget(media, fullUrl);
    } else if (media.mimeType?.startsWith('image/') == true) {
      return _buildImageWidget(fullUrl);
    } else if (media.mimeType?.startsWith('video/') == true) {
      return _buildVideoWidget(media, fullUrl);
    } else {
      return _buildFileWidget(media, fullUrl);
    }
  }

  Widget _buildAudioWidget(dynamic media, String fullUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.audiotrack, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              media.filename ?? "تسجيل صوتي",
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () => _playAudio(fullUrl),
            icon: const Icon(Icons.play_arrow, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String fullUrl) {
    if (!_isValidUrl(fullUrl)) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        height: 200,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.red, size: 50),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: GestureDetector(
        onTap: () => _showFullScreenImage(fullUrl),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            fullUrl,
            height: 200,
            width: 250,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 200,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.red, size: 50),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoWidget(dynamic media, String fullUrl) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.videocam, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              media.filename ?? "فيديو",
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () => _openFile(fullUrl, media.filename),
            icon: const Icon(Icons.play_arrow, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildFileWidget(dynamic media, String fullUrl) {
    final isPdf = media.mimeType?.contains('pdf') == true;
    final isDoc =
        media.mimeType?.contains('document') == true ||
        media.mimeType?.contains('word') == true;

    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = Colors.orange;

    if (isPdf) {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else if (isDoc) {
      fileIcon = Icons.description;
      iconColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(fileIcon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  media.filename ?? "ملف",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                if (media.size != null)
                  Text(
                    _formatFileSize(media.size!),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openFile(fullUrl, media.filename),
            icon: const Icon(Icons.open_in_new, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  // Helper methods
  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.tryParse(url);
      return uri != null &&
          uri.hasAbsolutePath &&
          (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _openFile(String url, String? filename) async {
    try {
      if (!_isValidUrl(url)) {
        throw 'رابط الملف غير صحيح';
      }

      if (_canOpenInBrowser(url)) {
        await _openInBrowser(url);
        return;
      }

      await _downloadAndOpenFile(url, filename);
    } catch (e) {
      _showError('خطأ في فتح الملف: $e');
    }
  }

  bool _canOpenInBrowser(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.contains('.pdf') ||
        lowerUrl.contains('.jpg') ||
        lowerUrl.contains('.jpeg') ||
        lowerUrl.contains('.png') ||
        lowerUrl.contains('.gif');
  }

  Future<void> _openInBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح الرابط';
    }
  }

  Future<void> _downloadAndOpenFile(String url, String? filename) async {
    try {
      _showLoadingDialog();

      Directory? directory = await _getDownloadDirectory();
      if (directory == null) {
        throw 'لا يمكن الوصول إلى مجلد التحميل';
      }

      String fileName = filename ?? _getFileNameFromUrl(url);
      String filePath = '${directory.path}/$fileName';

      File file = File(filePath);
      if (file.existsSync()) {
        Navigator.pop(context);
        await _openLocalFile(filePath);
        return;
      }

      await _dio.download(url, filePath);
      Navigator.pop(context);
      await _openLocalFile(filePath);
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      rethrow;
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      List<String> possiblePaths = [
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Downloads',
      ];

      for (String path in possiblePaths) {
        Directory dir = Directory(path);
        if (dir.existsSync()) {
          return dir;
        }
      }

      return await getExternalStorageDirectory();
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  String _getFileNameFromUrl(String url) {
    String fileName = url.split('/').last;
    if (!fileName.contains('.')) {
      fileName += '.file';
    }
    return fileName;
  }

  Future<void> _openLocalFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    if (result.type == ResultType.done) {
      _showSuccess('تم فتح الملف بنجاح');
    } else if (result.type == ResultType.noAppToOpen) {
      _showFileOptionsDialog(filePath);
    } else {
      throw 'لا يمكن فتح الملف: ${result.message}';
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1c2128),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'جاري تحميل الملف...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showFileOptionsDialog(String filePath) {
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _playAudio(String url) async {
    try {
      if (!_isValidUrl(url)) {
        throw 'رابط الملف الصوتي غير صحيح';
      }
      await _audioPlayer.play(UrlSource(url));
      _showSuccess('بدء تشغيل الملف الصوتي');
    } catch (e) {
      _showError('خطأ في تشغيل الصوت: $e');
    }
  }

  void _showFullScreenImage(String imageUrl) {
    if (!_isValidUrl(imageUrl)) {
      _showError('رابط الصورة غير صحيح');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'عرض الصورة',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.red, size: 100),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    MessageModel msg,
    ChatCubit cubit,
  ) {
    final controller = TextEditingController(text: msg.message);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1c2128),
          title: const Text(
            "تعديل الرسالة",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: 'اكتب رسالتك هنا...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                final newMessage = controller.text.trim();
                if (newMessage.isNotEmpty) {
                  cubit.editMessage(msg.id!, newMessage);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تعديل الرسالة بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('لا يمكن أن تكون الرسالة فارغة'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("حفظ", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
