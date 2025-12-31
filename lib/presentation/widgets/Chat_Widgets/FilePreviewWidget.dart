// import 'dart:io';
// import 'package:flutter/material.dart';

// class FilePreviewWidget extends StatelessWidget {
//   final File? pickedFile;
//   final VoidCallback onRemove;

//   const FilePreviewWidget({
//     super.key,
//     required this.pickedFile,
//     required this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (pickedFile == null) return const SizedBox.shrink();
    
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.insert_drive_file, color: Colors.orange),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               pickedFile!.path.split('/').last,
//               style: const TextStyle(color: Colors.white),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close, color: Colors.red),
//             onPressed: onRemove,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class FilePreviewWidget extends StatefulWidget {
  final File? pickedFile;
  final VoidCallback onRemove;

  const FilePreviewWidget({
    super.key,
    required this.pickedFile,
    required this.onRemove,
  });

  @override
  State<FilePreviewWidget> createState() => _FilePreviewWidgetState();
}

class _FilePreviewWidgetState extends State<FilePreviewWidget> {
  String? _thumbnailPath;
  bool _isGeneratingThumbnail = false;

  @override
  void initState() {
    super.initState();
    if (widget.pickedFile != null) {
      _isGeneratingThumbnail = true; 
    }
    _generateThumbnailIfNeeded();
  }

  @override
  void didUpdateWidget(FilePreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pickedFile?.path != widget.pickedFile?.path) {
      setState(() => _isGeneratingThumbnail = true);
      _generateThumbnailIfNeeded();
    }
  }

  Future<void> _generateThumbnailIfNeeded() async {
    if (widget.pickedFile == null) {
      setState(() {
        _thumbnailPath = null;
        _isGeneratingThumbnail = false;
      });
      return;
    }

    if (_isVideoFile()) {
      setState(() => _isGeneratingThumbnail = true);
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      try {
        final thumbnail = await VideoThumbnail.thumbnailFile(
          video: widget.pickedFile!.path,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 200,
          quality: 75,
        );
        
        if (mounted) {
          setState(() {
            _thumbnailPath = thumbnail;
            _isGeneratingThumbnail = false;
          });
        }
      } catch (e) {
        print('Error generating thumbnail: $e');
        if (mounted) {
          setState(() => _isGeneratingThumbnail = false);
        }
      }
    } else if (_isImageFile()) {
      setState(() => _isGeneratingThumbnail = true);
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        setState(() => _isGeneratingThumbnail = false);
      }
    }
  }

  bool _isVideoFile() {
    if (widget.pickedFile == null) return false;
    final extension = widget.pickedFile!.path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'].contains(extension);
  }

  bool _isImageFile() {
    if (widget.pickedFile == null) return false;
    final extension = widget.pickedFile!.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pickedFile == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: _buildFilePreview(),
      ),
    );
  }

  Widget _buildFilePreview() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildThumbnailContent(),
          ),
        ),
        
        Positioned(
          top: -6,
          right: -6,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _isGeneratingThumbnail
                ? Padding(
                    padding: const EdgeInsets.all(3),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[800]!),
                    ),
                  )
                : GestureDetector(
                    onTap: widget.onRemove,
                    child: Center(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey[800],
                        size: 16,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailContent() {
    if (_isImageFile()) {
      return Image.file(
        widget.pickedFile!,
        fit: BoxFit.cover,
        width: 65,
        height: 65,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return frame != null
              ? child
              : Container(
                  color: Colors.grey[850],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white54, size: 30),
                  ),
                );
        },
      );
    }
    
    if (_isVideoFile()) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (_thumbnailPath != null)
            Image.file(
              File(_thumbnailPath!),
              fit: BoxFit.cover,
              width: 65,
              height: 65,
            )
          else
            Container(
              color: Colors.grey[850],
              child: const Icon(
                Icons.videocam,
                color: Colors.white54,
                size: 30,
              ),
            ),
          
          if (_thumbnailPath != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
        ],
      );
    }
    
    return Container(
      color: Colors.grey[850],
      child: const Icon(
        Icons.insert_drive_file,
        color: Colors.orange,
        size: 30,
      ),
    );
  }
}