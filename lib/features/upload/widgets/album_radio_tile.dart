import 'package:flutter/material.dart';

class AlbumRadioTile extends StatelessWidget {
  const AlbumRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  static const Color _primary = Color(0xFF7C74E8);
  static const Color _textDark = Color(0xFF171725);

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: Radio<String>(
                value: value,
                groupValue: groupValue,
                activeColor: _primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: _textDark,
                  fontSize: 13.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
