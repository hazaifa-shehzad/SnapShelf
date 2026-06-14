import 'package:flutter/material.dart';

import '../../../core/widgets/app_photo_image.dart';
import 'photo_image_data.dart';

class PhotoGridCard extends StatelessWidget {
  final PhotoImageData photo;
  final VoidCallback onTap;
  final VoidCallback onMoreTap;

  const PhotoGridCard({
    super.key,
    required this.photo,
    required this.onTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      photo.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF111827),
                        fontSize: 7.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      onPressed: onMoreTap,
                      padding: EdgeInsets.zero,
                      splashRadius: 18,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 15,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Hero(
                  tag: 'photo-${photo.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: _LocalPhoto(localPath: photo.localPath),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocalPhoto extends StatelessWidget {
  final String localPath;

  const _LocalPhoto({required this.localPath});

  @override
  Widget build(BuildContext context) {
    return AppPhotoImage(
      localPath: localPath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_) {
        return Container(
          color: const Color(0xFFF2F4F7),
          alignment: Alignment.center,
          child: const Icon(
            Icons.broken_image_outlined,
            color: Color(0xFF98A2B3),
          ),
        );
      },
    );
  }
}
