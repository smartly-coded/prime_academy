import 'dart:io';
import 'package:flutter/material.dart';

class FilePreviewWidget extends StatelessWidget {
  final File? pickedFile;
  final VoidCallback onRemove;

  const FilePreviewWidget({
    super.key,
    required this.pickedFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (pickedFile == null) return const SizedBox.shrink();
    
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
              pickedFile!.path.split('/').last,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}