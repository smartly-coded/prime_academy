import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';

class ProfileHeader extends StatefulWidget {
  final LoginResponse user;
  const ProfileHeader({super.key, required this.user});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  File? _image;

  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Row(
      children: [
        GestureDetector(
          onTap: _openGallery,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: _image != null
                ? ClipOval(
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  )
                : (widget.user.image != null &&
                      widget.user.image!.url!.isNotEmpty)
                ? ClipOval(
                    child: Image.network(
                      "http://192.168.0.105:4005${widget.user.image!.url}",
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white),
                    ),
                  )
                : const Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحبا",
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.white70,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              "${widget.user.firstname} ${widget.user.lastname}",
              style: TextStyle(
                fontSize: isMobile ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
