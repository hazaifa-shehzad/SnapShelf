import 'package:flutter/material.dart';

import '../../../core/widgets/app_photo_image.dart';
import 'photo_image_data.dart';

class PhotoOptionsSheet extends StatelessWidget {
  final PhotoImageData photo;
  final VoidCallback onView;
  final VoidCallback onDownload;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const PhotoOptionsSheet({
    super.key,
    required this.photo,
    required this.onView,
    required this.onDownload,
    required this.onDelete,
    required this.onShare,
  });

  static Future<void> show({
    required BuildContext context,
    required PhotoImageData photo,
    required VoidCallback onView,
    required VoidCallback onDownload,
    required VoidCallback onDelete,
    required VoidCallback onShare,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.18),
      builder: (_) {
        return PhotoOptionsSheet(
          photo: photo,
          onView: onView,
          onDownload: onDownload,
          onDelete: onDelete,
          onShare: onShare,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppPhotoImage(
                      localPath: photo.localPath,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_) => Container(
                        width: 44,
                        height: 44,
                        color: const Color(0xFFF2F4F7),
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo.id,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          photo.albumName ?? 'All Photos',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF2F4F7)),
            _OptionTile(
              icon: Icons.visibility_outlined,
              title: 'View',
              onTap: () => _closeThenRun(context, onView),
            ),
            _OptionTile(
              icon: Icons.download_rounded,
              title: 'Download',
              onTap: () => _closeThenRun(context, onDownload),
            ),
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete',
              isDestructive: true,
              onTap: () => _closeThenRun(context, onDelete),
            ),
            _OptionTile(
              icon: Icons.ios_share_rounded,
              title: 'Share',
              onTap: () => _closeThenRun(context, onShare),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _closeThenRun(BuildContext context, VoidCallback callback) {
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 120), callback);
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDestructive;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? const Color(0xFFEF4444)
        : const Color(0xFF111827);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 19, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: color.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}
