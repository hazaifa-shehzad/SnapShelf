import 'package:flutter/material.dart';

class AlbumFolderCard extends StatelessWidget {
  const AlbumFolderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.folderColor,
    required this.tabColor,
    this.onTap,
    this.onMoreTap,
    this.showMoreButton = false,
  });

  final String title;
  final String subtitle;
  final Color folderColor;
  final Color tabColor;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;
  final bool showMoreButton;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'album-folder-$title',
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _FolderPainter(
                          folderColor: folderColor,
                          tabColor: tabColor,
                        ),
                      ),
                    ),
                    if (showMoreButton)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: GestureDetector(
                          onTap: onMoreTap,
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.more_vert_rounded,
                              size: 17,
                              color: Color(0xFF4C4D58),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF171821),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF7A7D8C),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FolderPainter extends CustomPainter {
  const _FolderPainter({
    required this.folderColor,
    required this.tabColor,
  });

  final Color folderColor;
  final Color tabColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.width * 0.075);
    final tabHeight = size.height * 0.2;
    final tabWidth = size.width * 0.42;
    final tabStart = size.width * 0.48;

    final tabPaint = Paint()
      ..color = tabColor
      ..style = PaintingStyle.fill;

    final bodyPaint = Paint()
      ..color = folderColor
      ..style = PaintingStyle.fill;

    final tabPath = Path()
      ..moveTo(tabStart, 0)
      ..lineTo(tabStart + tabWidth - 10, 0)
      ..quadraticBezierTo(tabStart + tabWidth, 0, tabStart + tabWidth, 10)
      ..lineTo(tabStart + tabWidth, tabHeight + 3)
      ..lineTo(tabStart + 26, tabHeight + 3)
      ..lineTo(tabStart, 0)
      ..close();

    final bodyRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, tabHeight * 0.45, size.width, size.height - tabHeight * 0.45),
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    );

    canvas.drawPath(tabPath, tabPaint);
    canvas.drawRRect(bodyRect, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant _FolderPainter oldDelegate) {
    return oldDelegate.folderColor != folderColor || oldDelegate.tabColor != tabColor;
  }
}
