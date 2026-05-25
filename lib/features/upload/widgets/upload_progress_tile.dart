import 'package:flutter/material.dart';

class UploadProgressTile extends StatelessWidget {
  const UploadProgressTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    this.onCancel,
  });

  final String title;
  final String subtitle;
  final double progress;
  final VoidCallback? onCancel;

  static const Color _primary = Color(0xFF7C74E8);
  static const Color _track = Color(0xFFE6E3FF);
  static const Color _textDark = Color(0xFF171725);
  static const Color _textMuted = Color(0xFF7D8193);

  @override
  Widget build(BuildContext context) {
    final double normalizedProgress = progress.clamp(0.0, 1.0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(18, 15, 13, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 11.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onCancel,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 18,
                  width: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB8B3F6), width: 1.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: _primary,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: normalizedProgress,
              minHeight: 6,
              color: _primary,
              backgroundColor: _track,
            ),
          ),
        ],
      ),
    );
  }
}
