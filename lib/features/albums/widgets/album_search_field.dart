import 'package:flutter/material.dart';

class AlbumSearchField extends StatelessWidget {
  const AlbumSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search by title',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 22),
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFECECF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: const Color(0xFF7B73DC),
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF1E1F27),
          fontWeight: FontWeight.w500,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 10.5,
            color: Color(0xFF9EA0AD),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 15,
            color: Color(0xFF9EA0AD),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 31,
            minHeight: 38,
          ),
          contentPadding: const EdgeInsets.only(top: 11, right: 12),
        ),
      ),
    );
  }
}
