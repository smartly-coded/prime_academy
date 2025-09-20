import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
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

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  File? _pickedFile; // الملف اللي يترفع مع الرسالة

  @override
  void dispose() {
    if (ChatCubit.instance != null) {
      ChatCubit.instance!.closeSSE();
    }
    _controller.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
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
                    _buildFilePreview(), // عرض الملف المختار قبل الإرسال
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

          // رفع ملفات
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.blue),
              onPressed: () async {
                File? file = await pickFile();
                if (file != null) {
                  setState(() => _pickedFile = file);
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
                File? audio = await recordAudio();
                if (audio != null) {
                  cubit.sendMedia(audio);
                }
              },
            ),
          ),
          const SizedBox(width: 6),

          // إرسال النص + الملف (لو موجود)
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
    bool isStudent = msg.senderRole == "student" || msg.senderRole == "1";
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
                            backgroundImage: NetworkImage(
                              chatInfo.imageUrl ?? "",
                            ),
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

            // نص + مرفق
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

  Widget _buildMedia(MessageModel msg) {
    if (msg.mediaType == "audio") {
      return Row(
        children: [
          const Icon(Icons.mic, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () => playAudio(msg.mediaUrl!),
              child: const Text(
                "تشغيل التسجيل",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    } else if (msg.mediaType == "file") {
      return Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: TextButton(
              onPressed: () => openFile(msg.mediaUrl!),
              child: const Text(
                "فتح الملف",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(msg.message, style: const TextStyle(color: Colors.white));
    }
  }

  void openFile(String url) async {
    try {
      await OpenFilex.open(url);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في فتح الملف: $e')));
    }
  }

  void playAudio(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تشغيل الصوت: $e')));
    }
  }
}

void _showEditDialog(BuildContext context, MessageModel msg, ChatCubit cubit) {
  final controller = TextEditingController(text: msg.message);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("تعديل الرسالة"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              cubit.editMessage(msg.id!, controller.text);
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      );
    },
  );
}
