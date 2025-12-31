// // import 'dart:async';
// // import 'dart:io';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// // import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// // import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// // import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// // import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
// // import 'package:prime_academy/features/Chat/logic/chat_state.dart';
// // import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/FilePreviewWidget.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/MessageCardWidget.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/MessageInputWidget.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/RecordingManager.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/RecordingUIWidget.dart';
// // import 'package:prime_academy/presentation/widgets/Chat_Widgets/media_file_record.dart';



// // // class ChatScreen extends StatefulWidget {
// // //   final int chatId;
// // //   final LoginResponse user;

// // //   const ChatScreen({super.key, required this.chatId, required this.user});

// // //   @override
// // //   State<ChatScreen> createState() => _ChatScreenState();
// // // }

// // // class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
// // //   final TextEditingController _controller = TextEditingController();
// // //   final ScrollController _scrollController = ScrollController();
  
// // //   // Managers
// // //   late final AudioPlayerManager _audioPlayerManager;
// // //   late final RecordingManager _recordingManager;
// // //   late final FileManager _fileManager;
// // //   late final DialogHelper _dialogHelper;

// // //   File? _pickedFile;

// // //   @override
// // //   void initState() {
// // //     super.initState();
    
// // //     _audioPlayerManager = AudioPlayerManager(
// // //       onStateChanged: () => setState(() {}),
// // //     );
    
// // //     _recordingManager = RecordingManager(
// // //       vsync: this,
// // //       onStateChanged: () => setState(() {}),
// // //     );
    
// // //     _fileManager = FileManager();
// // //     _dialogHelper = DialogHelper(context);
// // //   }

// // //   @override
// // //   void dispose() {
// // //     if (ChatCubit.instance != null) {
// // //       ChatCubit.instance!.closeSSE();
// // //     }
// // //     _controller.dispose();
// // //     _scrollController.dispose();
// // //     _audioPlayerManager.dispose();
// // //     _recordingManager.dispose();
// // //     AudioRecorderManager.dispose();
// // //     super.dispose();
// // //   }

// // //   void _scrollToBottom() {
// // //     if (_scrollController.hasClients) {
// // //       WidgetsBinding.instance.addPostFrameCallback((_) {
// // //         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
// // //       });
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return RepositoryProvider(
// // //       create: (_) => ChatRepo(),
// // //       child: BlocProvider(
// // //         create: (context) {
// // //           final repo = context.read<ChatRepo>();
// // //           final cubit = ChatCubit(repo, widget.chatId, widget.user)..loadChat();
// // //           return cubit;
// // //         },
// // //         child: BlocConsumer<ChatCubit, ChatState>(
// // //           listener: (context, state) {
// // //             if (state is ChatLoaded) {
// // //               _scrollToBottom();
// // //             }
// // //           },
// // //           builder: (context, state) {
// // //             if (state is ChatLoading) {
// // //               return const Scaffold(
// // //                 body: Center(child: CircularProgressIndicator()),
// // //               );
// // //             }

// // //             if (state is ChatError) {
// // //               return Scaffold(
// // //                 body: Center(
// // //                   child: Text(
// // //                     state.error,
// // //                     style: const TextStyle(color: Colors.red),
// // //                   ),
// // //                 ),
// // //               );
// // //             }

// // //             if (state is ChatLoaded) {
// // //               final cubit = context.read<ChatCubit>();
// // //               final messages = state.messages;
// // //               final chatInfo = state.chatInfo;

// // //               return Scaffold(
// // //                 backgroundColor: const Color(0xff0d1117),
// // //                 appBar: _buildAppBar(),
// // //                 body: Column(
// // //                   children: [
// // //                     Expanded(
// // //                       child: ListView.builder(
// // //                         controller: _scrollController,
// // //                         padding: const EdgeInsets.only(top: 10, bottom: 10),
// // //                         itemCount: messages.length,
// // //                         itemBuilder: (context, index) {
// // //                           return MessageCardWidget(
// // //                             message: messages[index],
// // //                             chatInfo: chatInfo,
// // //                             audioPlayerManager: _audioPlayerManager,
// // //                             fileManager: _fileManager,
// // //                             dialogHelper: _dialogHelper,
// // //                             onEdit: (msg) => _dialogHelper.showEditDialog(
// // //                               msg,
// // //                               cubit,
// // //                             ),
// // //                             onDelete: (msgId) => cubit.deleteMessage(msgId),
// // //                           );
// // //                         },
// // //                       ),
// // //                     ),
// // //                     FilePreviewWidget(
// // //                       pickedFile: _pickedFile,
// // //                       onRemove: () => setState(() => _pickedFile = null),
// // //                     ),
// // //                     _buildMessageInputArea(cubit),
// // //                   ],
// // //                 ),
// // //               );
// // //             }

// // //             return const SizedBox.shrink();
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   AppBar _buildAppBar() {
// // //     return AppBar(
// // //       backgroundColor: const Color(0xff0d1117),
// // //       elevation: 0,
// // //       automaticallyImplyLeading: true,
// // //       leading: IconButton(
// // //         icon: const Icon(Icons.close, color: Colors.white, size: 24),
// // //         onPressed: () => Navigator.pop(context),
// // //       ),
// // //       title: const Text(
// // //         "اسألني لايف",
// // //         style: TextStyle(
// // //           color: Colors.white,
// // //           fontSize: 30,
// // //         ),
// // //         textDirection: TextDirection.rtl,
// // //       ),
// // //       centerTitle: true,
// // //       bottom: PreferredSize(
// // //         preferredSize: const Size.fromHeight(2),
// // //         child: Container(
// // //           height: 2,
// // //           decoration: const BoxDecoration(
// // //             gradient: LinearGradient(
// // //               colors: [Colors.orange, Colors.purple],
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildMessageInputArea(ChatCubit cubit) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// // //       color: Colors.black,
// // //       child: _recordingManager.isRecording
// // //           ? RecordingUIWidget(
// // //               recordingTime: _recordingManager.recordingTime,
// // //               isPaused: _recordingManager.isPaused,
// // //               pulseAnimation: _recordingManager.pulseAnimation!,
// // //               onSend: () => _handleSendRecording(cubit),
// // //               onTogglePause: () => _recordingManager.togglePauseResume(),
// // //               onCancel: () => _recordingManager.cancelRecording(),
// // //             )
// // //           : MessageInputWidget(
// // //               controller: _controller,
// // //               onSend: () => _handleSendMessage(cubit),
// // //               onStartRecording: () => _handleStartRecording(),
// // //               onPickFile: () => _handlePickFile(),
// // //             ),
// // //     );
// // //   }

// // //   Future<void> _handleStartRecording() async {
// // //     try {
// // //       await _recordingManager.startRecording();
// // //     } catch (e) {
// // //       _dialogHelper.showError('خطأ في بدء التسجيل: $e');
// // //     }
// // //   }

// // //   Future<void> _handleSendRecording(ChatCubit cubit) async {
// // //     try {
// // //       final recordingPath = await _recordingManager.finishRecording();
// // //       if (recordingPath != null) {
// // //         final file = File(recordingPath);
// // //         if (await file.exists()) {
// // //           cubit.sendMedia(file);
// // //           _dialogHelper.showSuccess('تم إرسال التسجيل بنجاح');
// // //         }
// // //       }
// // //     } catch (e) {
// // //       _dialogHelper.showError('خطأ في إرسال التسجيل: $e');
// // //     }
// // //   }

// // //   void _handleSendMessage(ChatCubit cubit) {
// // //     final text = _controller.text.trim();
// // //     final file = _pickedFile;

// // //     if (file != null) {
// // //       cubit.sendMedia(
// // //         file,
// // //         message: text.isNotEmpty ? text : null,
// // //       );
// // //       setState(() => _pickedFile = null);
// // //       _controller.clear();
// // //     } else if (text.isNotEmpty) {
// // //       cubit.sendMessage(text);
// // //       _controller.clear();
// // //     }
// // //   }

// // //   Future<void> _handlePickFile() async {
// // //     try {
// // //       File? file = await pickFile();
// // //       if (file != null) {
// // //         setState(() => _pickedFile = file);
// // //       }
// // //     } catch (e) {
// // //       _dialogHelper.showError('خطأ في اختيار الملف: $e');
// // //     }
// // //   }
// // // }


// // class ChatScreen extends StatefulWidget {
// //   final int chatId;
// //   final LoginResponse user;

// //   const ChatScreen({super.key, required this.chatId, required this.user});

// //   @override
// //   State<ChatScreen> createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
// //   final TextEditingController _controller = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
  
// //   // Managers
// //   late final AudioPlayerManager _audioPlayerManager;
// //   late final RecordingManager _recordingManager;
// //   late final FileManager _fileManager;
// //   late final DialogHelper _dialogHelper;

// //   File? _pickedFile;

// //   @override
// //   void initState() {
// //     super.initState();
    
// //     _audioPlayerManager = AudioPlayerManager(
// //       onStateChanged: () => setState(() {}),
// //     );
    
// //     _recordingManager = RecordingManager(
// //       vsync: this,
// //       onStateChanged: () => setState(() {}),
// //     );
    
// //     _fileManager = FileManager();
// //     _dialogHelper = DialogHelper(context);
// //   }

// //   @override
// //   void dispose() {
// //     if (ChatCubit.instance != null) {
// //       ChatCubit.instance!.closeSSE();
// //     }
// //     _controller.dispose();
// //     _scrollController.dispose();
// //     _audioPlayerManager.dispose();
// //     _recordingManager.dispose();
// //     AudioRecorderManager.dispose();
// //     super.dispose();
// //   }

// //   void _scrollToBottom() {
// //     if (_scrollController.hasClients) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return RepositoryProvider(
// //       create: (_) => ChatRepo(),
// //       child: BlocProvider(
// //         create: (context) {
// //           final repo = context.read<ChatRepo>();
// //           final cubit = ChatCubit(repo, widget.chatId, widget.user)..loadChat();
// //           return cubit;
// //         },
// //         child: BlocConsumer<ChatCubit, ChatState>(
// //           listener: (context, state) {
// //             if (state is ChatLoaded) {
// //               _scrollToBottom();
// //             }
// //           },
// //           builder: (context, state) {
// //             if (state is ChatLoading) {
// //               return const Scaffold(
// //                 body: Center(child: CircularProgressIndicator()),
// //               );
// //             }

// //             if (state is ChatError) {
// //               return Scaffold(
// //                 body: Center(
// //                   child: Text(
// //                     state.error,
// //                     style: const TextStyle(color: Colors.red),
// //                   ),
// //                 ),
// //               );
// //             }

// //             if (state is ChatLoaded) {
// //               final cubit = context.read<ChatCubit>();
// //               final messages = state.messages;
// //               final chatInfo = state.chatInfo;

// //               return Scaffold(
// //                 backgroundColor: const Color(0xff0d1117),
// //                 appBar: _buildAppBar(),
// //                 body: Column(
// //                   children: [
// //                     Expanded(
// //                       child: ListView.builder(
// //                         controller: _scrollController,
// //                         padding: const EdgeInsets.only(top: 10, bottom: 10),
// //                         itemCount: messages.length,
// //                         itemBuilder: (context, index) {
// //                           return MessageCardWidget(
// //                             message: messages[index],
// //                             chatInfo: chatInfo,
// //                             audioPlayerManager: _audioPlayerManager,
// //                             fileManager: _fileManager,
// //                             dialogHelper: _dialogHelper,
// //                             onEdit: (msg) => _dialogHelper.showEditDialog(
// //                               msg,
// //                               cubit,
// //                             ),
// //                             onDelete: (msgId) => cubit.deleteMessage(msgId),
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                     FilePreviewWidget(
// //                       pickedFile: _pickedFile,
// //                       onRemove: () => setState(() => _pickedFile = null),
// //                     ),
// //                     _buildMessageInputArea(cubit),
// //                   ],
// //                 ),
// //               );
// //             }

// //             return const SizedBox.shrink();
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   AppBar _buildAppBar() {
// //     return AppBar(
// //       backgroundColor: const Color(0xff0d1117),
// //       elevation: 0,
// //       automaticallyImplyLeading: true,
// //       leading: IconButton(
// //         icon: const Icon(Icons.close, color: Colors.white, size: 24),
// //         onPressed: () => Navigator.pop(context),
// //       ),
// //       title: const Text(
// //         "اسألني لايف",
// //         style: TextStyle(
// //           color: Colors.white,
// //           fontSize: 30,
// //         ),
// //         textDirection: TextDirection.rtl,
// //       ),
// //       centerTitle: true,
// //       bottom: PreferredSize(
// //         preferredSize: const Size.fromHeight(2),
// //         child: Container(
// //           height: 2,
// //           decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //               colors: [Colors.orange, Colors.purple],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildMessageInputArea(ChatCubit cubit) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// //       color: Colors.black,
// //       child: _recordingManager.isRecording
// //           ? RecordingUIWidget(
// //               recordingTime: _recordingManager.recordingTime,
// //               isPaused: _recordingManager.isPaused,
// //               pulseAnimation: _recordingManager.pulseAnimation!,
// //               onSend: () => _handleSendRecording(cubit),
// //               onTogglePause: () => _recordingManager.togglePauseResume(),
// //               onCancel: () => _recordingManager.cancelRecording(), 
               

// //             )
// //           : MessageInputWidget(
// //               controller: _controller,
// //               onSend: () => _handleSendMessage(cubit),
// //               onStartRecording: () => _handleStartRecording(),
// //               onPickFile: () => _handlePickFile(),
// //             ),
// //     );
// //   }

// //   Future<void> _handleStartRecording() async {
// //     try {
// //       await _recordingManager.startRecording();
// //     } catch (e) {
// //       _dialogHelper.showError('خطأ في بدء التسجيل: $e');
// //     }
// //   }

// //   // Future<void> _handleSendRecording(ChatCubit cubit) async {
// //   //   try {
// //   //     final recordingData = await _recordingManager.finishRecording();
// //   //     if (recordingData != null && recordingData['path'] != null) {
// //   //       final file = File(recordingData['path']);
// //   //       if (await file.exists()) {
// //   //         cubit.sendMedia(file);
// //   //         _dialogHelper.showSuccess('تم إرسال التسجيل بنجاح');
// //   //       }
// //   //     }
// //   //   } catch (e) {
// //   //     _dialogHelper.showError('خطأ في إرسال التسجيل: $e');
// //   //   }
// //   // }
// //   Future<void> _handleSendRecording(ChatCubit cubit) async {
// //   try {
// //     final recordingData = await _recordingManager.finishRecording();
// //     if (recordingData != null && recordingData['path'] != null) {
// //       final file = File(recordingData['path']);
// //       if (await file.exists()) {
// //         // ⭐ بعت الـ amplitudes والـ duration
// //         await cubit.sendMedia(
// //           file,
// //           amplitudes: List<double>.from(recordingData['amplitudes'] ?? []),
// //           duration: recordingData['duration'] ?? 0,
// //         );
// //         _dialogHelper.showSuccess('تم إرسال التسجيل بنجاح');
// //       }
// //     }
// //   } catch (e) {
// //     _dialogHelper.showError('خطأ في إرسال التسجيل: $e');
// //   }
// // }

// //   void _handleSendMessage(ChatCubit cubit) {
// //     final text = _controller.text.trim();
// //     final file = _pickedFile;

// //     if (file != null) {
// //       cubit.sendMedia(
// //         file,
// //         message: text.isNotEmpty ? text : null,
// //       );
// //       setState(() => _pickedFile = null);
// //       _controller.clear();
// //     } else if (text.isNotEmpty) {
// //       cubit.sendMessage(text);
// //       _controller.clear();
// //     }
// //   }

// //   Future<void> _handlePickFile() async {
// //     try {
// //       File? file = await pickFile();
// //       if (file != null) {
// //         setState(() => _pickedFile = file);
// //       }
// //     } catch (e) {
// //       _dialogHelper.showError('خطأ في اختيار الملف: $e');
// //     }
// //   }
// // }
// import 'dart:async';
// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
// import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
// import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
// import 'package:prime_academy/features/Chat/data/repos/chat_repo.dart';
// import 'package:prime_academy/features/Chat/logic/chat_cubit.dart';
// import 'package:prime_academy/features/Chat/logic/chat_state.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/AudioPlayerManager.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/DialogHelper.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/FileManager.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/FilePreviewWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/MessageCardWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/MessageInputWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/RecordingManager.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/RecordingUIWidget.dart';
// import 'package:prime_academy/presentation/widgets/Chat_Widgets/media_file_record.dart';

// class ChatScreen extends StatefulWidget {
//   final int chatId;
//   final LoginResponse user;

//   const ChatScreen({super.key, required this.chatId, required this.user});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
  
//   // Managers
//   late final AudioPlayerManager _audioPlayerManager;
//   late final RecordingManager _recordingManager;
//   late final FileManager _fileManager;
//   late final DialogHelper _dialogHelper;

//   File? _pickedFile;
//   bool _isDisposing = false; 

//   @override
//   void initState() {
//     super.initState();
    
//     _audioPlayerManager = AudioPlayerManager(
//       onStateChanged: _safeSetState,
//     );
    
//     _recordingManager = RecordingManager(
//       vsync: this,
//       onStateChanged: _safeSetState,
//     );
    
//     _fileManager = FileManager();
//     _dialogHelper = DialogHelper(context);
//   }

//   void _safeSetState() {
//     if (mounted && !_isDisposing) {
//       setState(() {});
//     }
//   }

//   @override
//   void dispose() {
//     _isDisposing = true; 
    
//     try {
//       if (ChatCubit.instance != null) {
//         ChatCubit.instance!.closeSSE();
//       }
//     } catch (e) {
//       debugPrint('SSE close error (ignored): $e');
//     }
    
//     _audioPlayerManager.dispose();
//     _recordingManager.dispose();
//     AudioRecorderManager.dispose();
    
//     _controller.dispose();
//     _scrollController.dispose();
    
//     super.dispose();
//   }

//   void _scrollToBottom() {
//     if (_scrollController.hasClients && !_isDisposing) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted && _scrollController.hasClients && !_isDisposing) {
//           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _isDisposing = true;
//         if (ChatCubit.instance != null) {
//           try {
//             ChatCubit.instance!.closeSSE();
//           } catch (e) {
//             debugPrint('SSE close error on back (ignored): $e');
//           }
//         }
//         return true;
//       },
//       child: RepositoryProvider(
//         create: (_) => ChatRepo(),
//         child: BlocProvider(
//           create: (context) {
//             final repo = context.read<ChatRepo>();
//             final cubit = ChatCubit(repo, widget.chatId, widget.user)..loadChat();
//             return cubit;
//           },
//           child: BlocConsumer<ChatCubit, ChatState>(
//             listener: (context, state) {
//               if (state is ChatLoaded && !_isDisposing) {
//                 _scrollToBottom();
//               }
//             },
//             builder: (context, state) {
//               if (state is ChatError) {
//                 return Scaffold(
//                   backgroundColor: const Color(0xff0d1117),
//                   appBar: _buildAppBar(),
//                   body: Center(
//                     child: Text(
//                       state.error,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 );
//               }

//               if (state is ChatLoaded) {
//                 final cubit = context.read<ChatCubit>();
//                 final messages = state.messages;
//                 final chatInfo = state.chatInfo;

//                 return Scaffold(
//                   backgroundColor: const Color(0xff0d1117),
//                   appBar: _buildAppBar(),
//                   body: Column(
//                     children: [
//                       Expanded(
//                         child: messages.isEmpty
//                             ? const Center(
//                                 child: Text(
//                                   'ابدأ المحادثة',
//                                   style: TextStyle(color: Colors.white54),
//                                 ),
//                               )
//                             : ListView.builder(
//                                 controller: _scrollController,
//                                 padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                 itemCount: messages.length,
//                                 itemBuilder: (context, index) {
//                                   return MessageCardWidget(
//                                     message: messages[index],
//                                     chatInfo: chatInfo,
//                                     audioPlayerManager: _audioPlayerManager,
//                                     fileManager: _fileManager,
//                                     dialogHelper: _dialogHelper,
//                                     onEdit: (msg) => _dialogHelper.showEditDialog(
//                                       msg,
//                                       cubit,
//                                     ),
//                                     onDelete: (msgId) => cubit.deleteMessage(msgId),
//                                   );
//                                 },
//                               ),
//                       ),
//                       FilePreviewWidget(
//                         pickedFile: _pickedFile,
//                         onRemove: () {
//                           if (!_isDisposing) {
//                             _safeSetState();
//                             _pickedFile = null;
//                           }
//                         },
//                       ),
//                       _buildMessageInputArea(cubit),
//                     ],
//                   ),
//                 );
//               }

//               return Scaffold(
//                 backgroundColor: const Color(0xff0d1117),
//                 appBar: _buildAppBar(),
//                 body: Column(
//                   children: [
//                     const Expanded(
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.orange,
//                         ),
//                       ),
//                     ),
//                     _buildMessageInputArea(null),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: const Color(0xff0d1117),
//       elevation: 0,
//       automaticallyImplyLeading: true,
//       leading: IconButton(
//         icon: const Icon(Icons.close, color: Colors.white, size: 24),
//         onPressed: () {
//           _isDisposing = true;
//           if (ChatCubit.instance != null) {
//             try {
//               ChatCubit.instance!.closeSSE();
//             } catch (e) {
//               debugPrint('SSE close error (ignored): $e');
//             }
//           }
//           Navigator.pop(context);
//         },
//       ),
//       title: const Text(
//         "اسألني لايف",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 30,
//         ),
//         textDirection: TextDirection.rtl,
//       ),
//       centerTitle: true,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(2),
//         child: Container(
//           height: 2,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.orange, Colors.purple],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInputArea(ChatCubit? cubit) {
//     if (cubit == null || _isDisposing) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         color: Colors.black,
//         child: MessageInputWidget(
//           controller: _controller,
//           onSend: () {},
//           onStartRecording: () {},
//           onPickFile: () {},
//         ),
//       );
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       color: Colors.black,
//       child: _recordingManager.isRecording
//           ? RecordingUIWidget(
//               recordingTime: _recordingManager.recordingTime,
//               isPaused: _recordingManager.isPaused,
//               pulseAnimation: _recordingManager.pulseAnimation!,
//               onSend: () => _handleSendRecording(cubit),
//               onTogglePause: () => _recordingManager.togglePauseResume(),
//               onCancel: () => _recordingManager.cancelRecording(),
//             )
//           : MessageInputWidget(
//               controller: _controller,
//               onSend: () => _handleSendMessage(cubit),
//               onStartRecording: () => _handleStartRecording(),
//               onPickFile: () => _handlePickFile(),
//             ),
//     );
//   }

//   Future<void> _handleStartRecording() async {
//     if (_isDisposing) return;
//     try {
//       await _recordingManager.startRecording();
//     } catch (e) {
//       if (mounted && !_isDisposing) {
//         _dialogHelper.showError('خطأ في بدء التسجيل: $e');
//       }
//     }
//   }

//   Future<void> _handleSendRecording(ChatCubit cubit) async {
//     if (_isDisposing) return;
//     try {
//       final recordingData = await _recordingManager.finishRecording();
//       if (recordingData != null && recordingData['path'] != null) {
//         final file = File(recordingData['path']);
//         if (await file.exists()) {
//           await cubit.sendMedia(
//             file,
//             amplitudes: List<double>.from(recordingData['amplitudes'] ?? []),
//             duration: recordingData['duration'] ?? 0,
//           );
//           if (mounted && !_isDisposing) {
//             _dialogHelper.showSuccess('تم إرسال التسجيل بنجاح');
//           }
//         }
//       }
//     } catch (e) {
//       if (mounted && !_isDisposing) {
//         _dialogHelper.showError('خطأ في إرسال التسجيل: $e');
//       }
//     }
//   }

//   void _handleSendMessage(ChatCubit cubit) {
//     if (_isDisposing) return;
//     final text = _controller.text.trim();
//     final file = _pickedFile;

//     if (file != null) {
//       cubit.sendMedia(
//         file,
//         message: text.isNotEmpty ? text : null,
//       );
//       if (!_isDisposing) {
//         _safeSetState();
//         _pickedFile = null;
//       }
//       _controller.clear();
//     } else if (text.isNotEmpty) {
//       cubit.sendMessage(text);
//       _controller.clear();
//     }
//   }

//   Future<void> _handlePickFile() async {
//     if (_isDisposing) return;
//     try {
//       File? file = await pickFile();
//       if (file != null && !_isDisposing) {
//         _safeSetState();
//         _pickedFile = file;
//       }
//     } catch (e) {
//       if (mounted && !_isDisposing) {
//         _dialogHelper.showError('خطأ في اختيار الملف: $e');
//       }
//     }
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/Chat/data/models/chatModel.dart';
import 'package:prime_academy/features/Chat/data/models/chat_info_model.dart';
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

class ChatScreen extends StatefulWidget {
  final int chatId;
  final int moduleId; 
  final int courseId;
  final LoginResponse user;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.moduleId, 
    required this.courseId, 
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
  bool _isDisposing = false; // ⭐ flag لمنع أي operations أثناء الـ dispose

  @override
  void initState() {
    super.initState();
    
    _audioPlayerManager = AudioPlayerManager(
      onStateChanged: _safeSetState,
    );
    
    _recordingManager = RecordingManager(
      vsync: this,
      onStateChanged: _safeSetState,
    );
    
    _fileManager = FileManager();
    _dialogHelper = DialogHelper(context);
  }

  // ⭐ دالة آمنة للـ setState
  void _safeSetState() {
    if (mounted && !_isDisposing) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _isDisposing = true; // ⭐ علّم إننا بندي dispose
    
    // ⭐ اقفل الـ SSE الأول عشان ميبعتش events جديدة
    try {
      if (ChatCubit.instance != null) {
        ChatCubit.instance!.closeSSE();
      }
    } catch (e) {
      // Ignore SSE close errors
      debugPrint('SSE close error (ignored): $e');
    }
    
    // ⭐ بعدين dispose الباقي
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ⭐ Handle back button properly
      onWillPop: () async {
        _isDisposing = true;
        if (ChatCubit.instance != null) {
          try {
            ChatCubit.instance!.closeSSE();
          } catch (e) {
            debugPrint('SSE close error on back (ignored): $e');
          }
        }
        return true;
      },
      child: MultiBlocProvider(
        providers: [
          RepositoryProvider(create: (_) => ChatRepo()),
          // ⭐ ModulesLessonsRepo موجود already في MultiRepositoryProvider في main
        ],
        child: BlocProvider(
          create: (context) {
            final chatRepo = context.read<ChatRepo>();
            final modulesRepo = context.read<ModulesLessonsRepo>();
            final cubit = ChatCubit(
             
               chatRepo: chatRepo, modulesLessonsRepo: modulesRepo, chatId:               widget.chatId,
 moduleId:               widget.moduleId, // ⭐ تمرير moduleId
 courseId:               widget.courseId, // ⭐ تمرير courseId
user: widget.user,
            )..loadChat();
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
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return MessageCardWidget(
                                    message: messages[index],
                                    chatInfo: chatInfo,
                                    audioPlayerManager: _audioPlayerManager,
                                    fileManager: _fileManager,
                                    dialogHelper: _dialogHelper,
                                    onEdit: (msg) => _dialogHelper.showEditDialog(
                                      msg,
                                      cubit,
                                    ),
                                    onDelete: (msgId) => cubit.deleteMessage(msgId),
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
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
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
          // ⭐ Close SSE before popping
          _isDisposing = true;
          if (ChatCubit.instance != null) {
            try {
              ChatCubit.instance!.closeSSE();
            } catch (e) {
              debugPrint('SSE close error (ignored): $e');
            }
          }
          Navigator.pop(context);
        },
      ),
      title: const Text(
        "اسألني لايف",
        style: TextStyle(
          color: Colors.white,
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
      await _recordingManager.startRecording();
    } catch (e) {
      if (mounted && !_isDisposing) {
        _dialogHelper.showError('خطأ في بدء التسجيل: $e');
      }
    }
  }

  Future<void> _handleSendRecording(ChatCubit cubit) async {
    if (_isDisposing) return;
    try {
      final recordingData = await _recordingManager.finishRecording();
      if (recordingData != null && recordingData['path'] != null) {
        final file = File(recordingData['path']);
        if (await file.exists()) {
          await cubit.sendMedia(
            file,
            amplitudes: List<double>.from(recordingData['amplitudes'] ?? []),
            duration: recordingData['duration'] ?? 0,
          );
          if (mounted && !_isDisposing) {
            _dialogHelper.showSuccess('تم إرسال التسجيل بنجاح');
          }
        }
      }
    } catch (e) {
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
      cubit.sendMedia(
        file,
        message: text.isNotEmpty ? text : null,
      );
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