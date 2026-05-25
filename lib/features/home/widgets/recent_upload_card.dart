import 'package:flutter/material.dart';

class RecentUploadCard extends StatelessWidget {
  const RecentUploadCard({
    super.key,
    required this.imageUrl,
    this.width = 96,
    this.height = 90,
  });

  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFEDEDFC),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _placeholder();
        },
        errorBuilder: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE6E3FF), Color(0xFFFFDDE7)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_rounded, color: Color(0xFF8A82EA), size: 30),
      ),
    );
  }
}
