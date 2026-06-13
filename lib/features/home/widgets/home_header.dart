import 'package:flutter/material.dart';

import '../../../core/widgets/app_photo_image.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.initials = 'U',
    this.onMenuTap,
  });

  final String name;
  final String subtitle;
  final String? avatarUrl;
  final String initials;
  final VoidCallback? onMenuTap;

  static const Color _primary = Color(0xFF7C74E8);
  static const Color _textDark = Color(0xFF171725);
  static const Color _textMuted = Color(0xFF7D8193);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onMenuTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu_rounded, color: _primary, size: 21),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $name,',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _textDark,
                  fontSize: 20,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 38,
          width: 38,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: avatarUrl == null || avatarUrl!.trim().isEmpty
                ? _avatarFallback()
                : AppPhotoImage(
                    imageUrl: avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_) => _avatarFallback(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: const Color(0xFFFFE2E6),
      alignment: Alignment.center,
      child: Text(
        initials,
        maxLines: 1,
        style: const TextStyle(
          color: Color(0xFFEF7D8D),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
