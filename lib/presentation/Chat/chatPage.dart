import 'dart:async';
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

class ChatScreen extends StatefulWidget {
  final int chatId;
  final LoginResponse user;

  const ChatScreen({super.key, required this.chatId, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();

  File? _pickedFile;

  // Recording state
  bool _isRecording = false;
  int _recordingTime = 0;
  Timer? _recordingTimer;
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;
  String? _currentRecordingPath;

  // Audio playback state
  String? _playingAudioUrl;
  bool _isPlaying = false;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _audioPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _playingAudioUrl = null;
        _audioPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    if (ChatCubit.instance != null) {
      ChatCubit.instance!.closeSSE();
    }
    _controller.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    _pulseController?.dispose();
    AudioRecorderManager.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      _currentRecordingPath = await AudioRecorderManager.startRecording();

      if (_currentRecordingPath == null) {
        throw 'فشل في بدء التسجيل - تأكد من أذونات الميكروفون';
      }

      setState(() {
        _isRecording = true;
        _recordingTime = 0;
      });

      _pulseController?.repeat(reverse: true);
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingTime++;
        });
      });
    } catch (e) {
      _showError('خطأ في بدء التسجيل: $e');
      setState(() {
        _isRecording = false;
        _currentRecordingPath = null;
      });
    }
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    _pulseController?.stop();

    try {
      if (_isRecording && _currentRecordingPath != null) {
        await AudioRecorderManager.stopRecording(_currentRecordingPath);
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }

    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _cancelRecording() async {
    await _stopRecording();

    if (_currentRecordingPath != null) {
      try {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting recording: $e');
      }
    }

    setState(() {
      _recordingTime = 0;
      _currentRecordingPath = null;
    });
  }

  Future<void> _sendRecording(ChatCubit cubit) async {
    try {
      if (_currentRecordingPath == null) {
        throw 'لا يوجد تسجيل للإرسال';
      }

      await _stopRecording();

      final file = File(_currentRecordingPath!);
      if (!await file.exists()) {
        throw 'ملف التسجيل غير موجود';
      }

      cubit.sendMedia(file);
      _showSuccess('تم إرسال التسجيل بنجاح');

      setState(() {
        _recordingTime = 0;
        _currentRecordingPath = null;
      });
    } catch (e) {
      _showError('خطأ في إرسال التسجيل: $e');
      setState(() {
        _recordingTime = 0;
        _currentRecordingPath = null;
      });
    }
  }

  String get _formattedTime {
    final minutes = (_recordingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_recordingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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
                  leading: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    "اسألني لايف",
                    style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textDirection: TextDirection.rtl,
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
      child: _isRecording ? _buildRecordingUI(cubit) : _buildNormalUI(cubit),
    );
  }

  // Widget _buildNormalUI(ChatCubit cubit) {
  //   return Row(
  //     children: [
  //       CircleAvatar(
  //         radius: 20,
  //         backgroundColor: Colors.blue,
  //         child: IconButton(
  //           icon: const Icon(Icons.send, color: Colors.white),
  //           onPressed: () {
  //             final text = _controller.text.trim();
  //             final file = _pickedFile;

  //             if (file != null) {
  //               cubit.sendMedia(file, message: text.isNotEmpty ? text : null);
  //               setState(() => _pickedFile = null);
  //               _controller.clear();
  //             } else if (text.isNotEmpty) {
  //               cubit.sendMessage(text);
  //               _controller.clear();
  //             }
  //           },
  //         ),
  //       ),
  //       const SizedBox(width: 6),
  //       CircleAvatar(
  //         radius: 20,
  //         backgroundColor: Colors.blue,
  //         child: IconButton(
  //           icon: const Icon(Icons.mic, color: Colors.white),
  //           onPressed: () {
  //             _startRecording();
  //           },
  //         ),
  //       ),
  //       const SizedBox(width: 6),

  //       CircleAvatar(
  //         radius: 20,
  //         backgroundColor: Mycolors.darkblue,
  //         child: IconButton(
  //           icon: const Icon(Icons.attach_file, color: Colors.white),
  //           onPressed: () async {
  //             try {
  //               File? file = await pickFile();
  //               if (file != null) {
  //                 setState(() => _pickedFile = file);
  //               }
  //             } catch (e) {
  //               _showError('خطأ في اختيار الملف: $e');
  //             }
  //           },
  //         ),
  //       ),

  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: TextField(
  //           controller: _controller,
  //           style: const TextStyle(color: Colors.white),
  //           decoration: InputDecoration(
  //             hintText: "اكتب رسالتك...",
  //             hintStyle: const TextStyle(color: Colors.grey),
  //             contentPadding: const EdgeInsets.symmetric(
  //               horizontal: 12,
  //               vertical: 10,
  //             ),
  //             filled: true,
  //             fillColor: const Color(0xff0d1117),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               borderSide: const BorderSide(color: Colors.blue),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               borderSide: const BorderSide(color: Colors.blue, width: 2),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildNormalUI(ChatCubit cubit) {
    return Row(
      children: [
        // زر الإرسال
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2,
            ), // ✅ البوردر الأزرق
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Mycolors.darkblue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
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
        ),
        const SizedBox(width: 6),

        // زر الميكروفون
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Mycolors.darkblue,
            child: IconButton(
              icon: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {
                _startRecording();
              },
            ),
          ),
        ),
        const SizedBox(width: 6),

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Mycolors.darkblue,
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.white),
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
        ),

        const SizedBox(width: 8),

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
      ],
    );
  }

  Widget _buildRecordingUI(ChatCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff0d1117),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _sendRecording(cubit),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formattedTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 30,
              child: CustomPaint(painter: WaveformPainter()),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedBuilder(
            animation: _pulseAnimation!,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation!.value,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.3),
                  ),
                  child: const Icon(Icons.mic, color: Colors.red, size: 24),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.red,
            child: IconButton(
              icon: const Icon(Icons.pause, color: Colors.white, size: 20),
              onPressed: () => _stopRecording(),
            ),
          ),
          const SizedBox(width: 6),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[800],
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white, size: 20),
              onPressed: () => _cancelRecording(),
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
                            // fontWeight: FontWeight.bold,
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
    if (imagePath.startsWith('https://') || imagePath.startsWith('http://')) {
      return imagePath;
    }

    if (imagePath.startsWith('file://')) {
      imagePath = imagePath.substring(7);
    }
    if (imagePath.startsWith('file:')) {
      imagePath = imagePath.substring(5);
    }

    const String baseUrl = 'https://cdn.primeacademy.education/primeacademy';
    //  'https://cdn-dev.primeacademy.education/primeacademydev';
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
    final isCurrentlyPlaying = _playingAudioUrl == fullUrl && _isPlaying;
    final progress = _playingAudioUrl == fullUrl && _audioDuration.inSeconds > 0
        ? _audioPosition.inSeconds / _audioDuration.inSeconds
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleAudioPlayback(fullUrl),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: AudioWaveformPainter(progress: progress),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _playingAudioUrl == fullUrl
                      ? '${_formatDuration(_audioPosition)} / ${_formatDuration(_audioDuration)}'
                      : _audioDuration.inSeconds > 0
                      ? _formatDuration(_audioDuration)
                      : '00:13',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleAudioPlayback(String url) async {
    try {
      if (!_isValidUrl(url)) {
        _showError('رابط الملف الصوتي غير صحيح');
        return;
      }

      if (_playingAudioUrl == url && _isPlaying) {
        await _audioPlayer.pause();
      } else if (_playingAudioUrl == url && !_isPlaying) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.stop();
        setState(() {
          _playingAudioUrl = url;
        });
        await _audioPlayer.play(UrlSource(url));
      }
    } catch (e) {
      _showError('خطأ في تشغيل الصوت: $e');
    }
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
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
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
                buildImageUrl(imageUrl),
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
                borderSide: BorderSide(color: Colors.blue),
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

// Custom Waveform Painter for recording UI
class WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final middleY = size.height / 2;
    final barWidth = 3.0;
    final spacing = 5.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + spacing);
      final randomHeight =
          (i % 3 == 0
              ? 0.8
              : i % 2 == 0
              ? 0.5
              : 0.3) *
          size.height;

      canvas.drawLine(
        Offset(x, middleY - randomHeight / 2),
        Offset(x, middleY + randomHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom Audio Waveform Painter for audio messages
class AudioWaveformPainter extends CustomPainter {
  final double progress;

  AudioWaveformPainter({this.progress = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final middleY = size.height / 2;
    final barWidth = 2.0;
    final spacing = 4.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final x = i * (barWidth + spacing);
      final normalizedProgress = progress.clamp(0.0, 1.0);
      final isPlayed = (i / totalBars) <= normalizedProgress;

      final paint = Paint()
        ..color = isPlayed ? Colors.blue : Colors.grey.withOpacity(0.5)
        ..strokeWidth = barWidth
        ..strokeCap = StrokeCap.round;

      final heightFactor = ((i % 5) == 0)
          ? 0.9
          : ((i % 3) == 0)
          ? 0.6
          : ((i % 2) == 0)
          ? 0.4
          : 0.3;
      final barHeight = size.height * heightFactor;

      canvas.drawLine(
        Offset(x, middleY - barHeight / 2),
        Offset(x, middleY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AudioWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
