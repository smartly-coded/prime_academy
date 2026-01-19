// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
// import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';

// class ProfileHeader extends StatefulWidget {
//   final LoginResponse user;
//   const ProfileHeader({super.key, required this.user});

//   @override
//   State<ProfileHeader> createState() => _ProfileHeaderState();
// }

// class _ProfileHeaderState extends State<ProfileHeader> {
//   File? _image;

//   Future<void> _openGallery() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final isMobile = width < 600;
//     final imageUrl = buildImageUrl(widget.user.image!.url);
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: _openGallery,
//           child: Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.black,
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.white, width: 1),
//             ),
//             child: _image != null
//                 ? ClipOval(
//                     child: Image.file(
//                       _image!,
//                       fit: BoxFit.cover,
//                       width: 50,
//                       height: 50,
//                     ),
//                   )
//                 : (widget.user.image != null &&
//                       widget.user.image!.url!.isNotEmpty)
//                 ? ClipOval(
//                     child: Image.network(
//                       _buildImageUrl(
//                       imageUrl,
//                       ),
//                       fit: BoxFit.cover,
//                       width: 50,
//                       height: 50,
//                       errorBuilder: (_, __, ___) =>
//                           const Icon(Icons.person, color: Colors.white),
//                     ),
//                   )
//                 : const Icon(Icons.camera_alt_outlined, color: Colors.white),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "مرحبا",
//               style: TextStyle(
//                 fontSize: isMobile ? 16 : 18,
//                 color: Colors.white70,
//                 fontFamily: 'Cairo',
//               ),
//             ),
//             Text(
//               "${widget.user.firstname} ${widget.user.lastname}",
//               style: TextStyle(
//                 fontSize: isMobile ? 18 : 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontFamily: 'Cairo',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
// String _buildImageUrl(String? imagePath) {
//   if (imagePath == null || imagePath.isEmpty) return "";

//   if (imagePath.startsWith('http')) return imagePath;

//   // إذا الصور مخزّنة على CDN فرعي
//   const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";

//   return imagePath.startsWith('/')
//       ? "$cdnPrefix$imagePath"
//       : "$cdnPrefix/$imagePath";
// }
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
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📸 User Image Object: ${widget.user.image}');
    print('📸 Image URL from user: ${widget.user.image?.url}');
  
    return Row(
      children: [
        GestureDetector(
          onTap: _openGallery,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
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
                  : const Icon(Icons.camera_alt_outlined, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
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
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _buildImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return "";

  if (imagePath.startsWith('http')) return imagePath;

  const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";

  return imagePath.startsWith('/')
      ? "$cdnPrefix$imagePath"
      : "$cdnPrefix/$imagePath";
}
