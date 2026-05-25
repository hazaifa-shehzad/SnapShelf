import 'package:flutter/material.dart';

class AlbumPreviewCard extends StatelessWidget {
  const AlbumPreviewCard({
    super.key,
    required this.title,
    required this.photoCount,
    required this.folderColor,
    required this.tabColor,
    this.onTap,
  });

  final String title;
  final int photoCount;
  final Color folderColor;
  final Color tabColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 72,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 18,
                    width: 46,
                    decoration: BoxDecoration(
                      color: tabColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: folderColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF171725),
              fontSize: 14,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$photoCount Photos',
            style: const TextStyle(
              color: Color(0xFF6F7485),
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
