import 'package:flutter/material.dart';
import 'package:prime_academy/core/helpers/themeing/app_colors.dart';
import 'package:prime_academy/features/startScreen/data/models/student_preview_response.dart';
import 'package:prime_academy/presentation/Home/veiw/home_screen.dart';

class PreviewHeader extends StatefulWidget {
  final StudentPreviewResponse response;
  const PreviewHeader({super.key, required this.response});
  @override
  State<PreviewHeader> createState() => PreviewHeaderState();
}

class PreviewHeaderState extends State<PreviewHeader> {
  String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith('http')) return imagePath;

    const String cdnPrefix = "https://cdn.primeacademy.education/primeacademy";
    return imagePath.startsWith('/')
        ? "$cdnPrefix$imagePath"
        : "$cdnPrefix/$imagePath";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    // final imageUrl = buildImageUrl(widget.response.image!.url);
    final imageUrl =
        widget.response.image?.url != null &&
            widget.response.image!.url!.isNotEmpty
        ? buildImageUrl(widget.response.image!.url!)
        : null;

    return Row(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Mycolors.backgroundColor,
            shape: BoxShape.circle,
            border: imageUrl == null
                ? Border.all(color: Colors.orange, width: 1)
                : null,
          ),
          child: ClipOval(
            child: Image.network(
              buildImageUrl(imageUrl),
              fit: BoxFit.cover,
              width: 90,
              height: 90,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, color: Colors.orange, size: 80),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.response.firstname} ${widget.response.lastname}",
              style: TextStyle(
                fontSize: isMobile ? 23 : 26,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
