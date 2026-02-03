import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/features/profileScreen/data/models/student_profile_response.dart';

class ProfileHeader extends StatefulWidget {
  // final LoginResponse user;
  final StudentProfileResponse user;

  const ProfileHeader({super.key, required this.user});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _image;

  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    final imageUrl = _buildImageUrl(widget.user.image?.url);

    return Row(
      children: [
        GestureDetector(
          onTap: _openGallery,
          child: Container(
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),

              child: ClipOval(
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : (imageUrl.isNotEmpty)
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.person, color: Colors.white),
                      )
                    : Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.orange.withOpacity(0.6),
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحبا",
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                color: Colors.white70,
              ),
            ),
            Text(
              "${widget.user.firstname} ${widget.user.lastname}",
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildPlaceholder() {
  return Center(
    child: Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 100, color: Colors.black87),
    ),
  );
}

String _buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return "";

  if (imagePath.startsWith('http')) return imagePath;

  const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";

  return imagePath.startsWith('/')
      ? "$cdnPrefix$imagePath"
      : "$cdnPrefix/$imagePath";
}
