import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
import 'package:prime_academy/features/Chat/logic/chat_state.dart';
import 'package:prime_academy/features/CoursesModules/data/repo/modules_lessons_repo.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/FilePreviewWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/MessageCardWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/MessageInputWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/RecordingManager.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/RecordingUIWidget.dart';
import 'package:prime_academy/presentation/widgets/Chat_Widgets/media_file_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;
  final int? moduleId;
  final int? courseId;
  final LoginResponse user;

  const ChatScreen({
    super.key,
    required this.chatId,
    this.moduleId,
    this.courseId,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Managers
  late final AudioPlayerManager _audioPlayerManager;
  late final RecordingManager _recordingManager;
  late final FileManager _fileManager;
  late final DialogHelper _dialogHelper;

  File? _pickedFile;
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();

    _audioPlayerManager = AudioPlayerManager(onStateChanged: _safeSetState);

    _recordingManager = RecordingManager(
      vsync: this,
      onStateChanged: _safeSetState,
    );

    _fileManager = FileManager();
    _dialogHelper = DialogHelper(context);
  }

  void _safeSetState() {
    if (mounted && !_isDisposing) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _isDisposing = true;

    _audioPlayerManager.dispose();
    _recordingManager.dispose();
    AudioRecorderManager.dispose();

    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_isDisposing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients && !_isDisposing) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }
Future<void> _loadProfileAndChat(ChatCubit cubit) async {
  Map<String, dynamic>? profileData;
  try {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null && userDataString.isNotEmpty) {
      final userData = jsonDecode(userDataString);
      profileData = {
        'id': userData['id'],
        'firstname': userData['firstname'],
        'lastname': userData['lastname'],
        'image': userData['image'],
      };
      print('✅ Loaded profile from SharedPreferences');
      print('Profile data: $profileData');
    }
  } catch (e) {
    print('⚠️ Failed to load profile from storage: $e');
  }

  cubit.loadChat(profileData: profileData);
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _isDisposing = true;

        return true;
      },
      child: MultiBlocProvider(
        providers: [RepositoryProvider(create: (_) => ChatRepo())],
        child:
      // BlocProvider(
      //     create: (context) {
      //       final chatRepo = context.read<ChatRepo>();
      //       final modulesRepo = context.read<ModulesLessonsRepo>();
      //       final cubit = ChatCubit(
      //         chatRepo: chatRepo,
      //         modulesLessonsRepo: modulesRepo,
      //         chatId: widget.chatId,
      //         moduleId: widget.moduleId,
      //         courseId: widget.courseId,
      //         user: widget.user,
      //       )..loadChat();
      //       return cubit;
      //     },
      BlocProvider(
  create: (context) {
    final chatRepo = context.read<ChatRepo>();
    final modulesRepo = context.read<ModulesLessonsRepo>();

    final cubit = ChatCubit(
      chatRepo: chatRepo,
      modulesLessonsRepo: modulesRepo,
      chatId: widget.chatId,
      moduleId: widget.moduleId,
      courseId: widget.courseId,
      user: widget.user,
    );

    // ✅ اعمل الـ loading بعد ما تخلق الـ cubit
    _loadProfileAndChat(cubit);

    return cubit;
  },
 
          child: BlocConsumer<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state is ChatLoaded && !_isDisposing) {
                _scrollToBottom();
              }
            },
            builder: (context, state) {
              if (state is ChatError) {
                return Scaffold(
                  backgroundColor: const Color(0xff0d1117),
                  appBar: _buildAppBar(),
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
                  appBar: _buildAppBar(),
                  body: Column(
                    children: [
                      Expanded(
                        child: messages.isEmpty
                            ? const Center(
                                child: Text(
                                  'ابدأ المحادثة',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return MessageCardWidget(
                                    message: messages[index],
                                    chatInfo: chatInfo,
                                    audioPlayerManager: _audioPlayerManager,
                                    fileManager: _fileManager,
                                    dialogHelper: _dialogHelper,
                                    onEdit: (msg) => _dialogHelper
                                        .showEditDialog(msg, cubit),
                                    onDelete: (msgId) =>
                                        cubit.deleteMessage(msgId),
                                  );
                                },
                              ),
                      ),
                      FilePreviewWidget(
                        pickedFile: _pickedFile,
                        onRemove: () {
                          if (!_isDisposing) {
                            _safeSetState();
                            _pickedFile = null;
                          }
                        },
                      ),
                      _buildMessageInputArea(cubit),
                    ],
                  ),
                );
              }

              // Initial state
              return Scaffold(
                backgroundColor: const Color(0xff0d1117),
                appBar: _buildAppBar(),
                body: Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      ),
                    ),
                    _buildMessageInputArea(null),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  } 

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff0d1117),
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 24),
        onPressed: () {
          // ✅ Mark as disposing to prevent setState calls
          _isDisposing = true;

          // ✅ SSE cleanup is handled automatically when widget disposes
          // No need to manually call closeSSE()

          Navigator.pop(context);
        },
      ),
      title: const Text(
        "اسألني لايف",
        style: TextStyle(color: Colors.white, fontSize: 30),
        textDirection: TextDirection.rtl,
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.orange, Colors.purple]),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputArea(ChatCubit? cubit) {
    if (cubit == null || _isDisposing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: Colors.black,
        child: MessageInputWidget(
          controller: _controller,
          onSend: () {},
          onStartRecording: () {},
          onPickFile: () {},
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.black,
      child: _recordingManager.isRecording
          ? RecordingUIWidget(
              recordingTime: _recordingManager.recordingTime,
              isPaused: _recordingManager.isPaused,
              pulseAnimation: _recordingManager.pulseAnimation!,
              onSend: () => _handleSendRecording(cubit),
              onTogglePause: () => _recordingManager.togglePauseResume(),
              onCancel: () => _recordingManager.cancelRecording(),
            )
          : MessageInputWidget(
              controller: _controller,
              onSend: () => _handleSendMessage(cubit),
              onStartRecording: () => _handleStartRecording(),
              onPickFile: () => _handlePickFile(),
            ),
    );
  }

  Future<void> _handleStartRecording() async {
    if (_isDisposing) return;

    try {
      print('🎙️ [iOS DEBUG] Starting recording...');
      await _recordingManager.startRecording();
      print('🎙️ [iOS DEBUG] Recording started successfully');
    } catch (e, stackTrace) {
      print('❌ [iOS DEBUG] Failed to start recording: $e');
      print('❌ [iOS DEBUG] Stack trace: $stackTrace');

      if (mounted && !_isDisposing) {
        _dialogHelper.showError('خطأ في بدء التسجيل: $e');
      }
    }
  }

  Future<void> _handleSendRecording(ChatCubit cubit) async {
    if (_isDisposing) return;

    try {
      print('🎙️ [iOS DEBUG] Finishing recording...');
      final recordingData = await _recordingManager.finishRecording();

      print(
        '🎙️ [iOS DEBUG] Recording data received: ${recordingData != null}',
      );

      if (recordingData == null) {
        throw Exception('Recording data is null');
      }

      if (recordingData['path'] == null) {
        throw Exception('Recording path is null');
      }

      final filePath = recordingData['path'] as String;
      print('🎙️ [iOS DEBUG] Recording path: $filePath');

      final file = File(filePath);
      final fileExists = await file.exists();
      print('🎙️ [iOS DEBUG] File exists: $fileExists');

      if (!fileExists) {
        throw Exception('Recording file does not exist at path: $filePath');
      }

      final fileSize = await file.length();
      print('🎙️ [iOS DEBUG] File size: $fileSize bytes');

      if (fileSize == 0) {
        throw Exception('Recording file is empty (0 bytes)');
      }

      final amplitudes = recordingData['amplitudes'] ?? [];
      final duration = recordingData['duration'] ?? 0;

      print('🎙️ [iOS DEBUG] Amplitudes count: ${amplitudes.length}');
      print('🎙️ [iOS DEBUG] Duration: $duration seconds');
      print('🎙️ [iOS DEBUG] Sending media to server...');

      await cubit.sendMedia(
        file,
        amplitudes: List<double>.from(amplitudes),
        duration: duration,
      );

      print('🎙️ [iOS DEBUG] Media sent successfully!');

      if (mounted && !_isDisposing) {
        _dialogHelper.showSuccess('تم إرسال التسجيل بنجاح');
      }
    } catch (e, stackTrace) {
      print('❌ [iOS DEBUG] Failed to send recording: $e');
      print('❌ [iOS DEBUG] Stack trace: $stackTrace');

      if (mounted && !_isDisposing) {
        _dialogHelper.showError('خطأ في إرسال التسجيل: $e');
      }
    }
  }

  void _handleSendMessage(ChatCubit cubit) {
    if (_isDisposing) return;
    final text = _controller.text.trim();
    final file = _pickedFile;

    if (file != null) {
      cubit.sendMedia(file, message: text.isNotEmpty ? text : null);
      if (!_isDisposing) {
        _safeSetState();
        _pickedFile = null;
      }
      _controller.clear();
    } else if (text.isNotEmpty) {
      cubit.sendMessage(text);
      _controller.clear();
    }
  }

  Future<void> _handlePickFile() async {
    if (_isDisposing) return;
    try {
      File? file = await pickFile();
      if (file != null && !_isDisposing) {
        _safeSetState();
        _pickedFile = file;
      }
    } catch (e) {
      if (mounted && !_isDisposing) {
        _dialogHelper.showError('خطأ في اختيار الملف: $e');
      }
    }
  }
}
