import 'dart:io';

import 'package:flutter/material.dart';

class AppPhotoImage extends StatelessWidget {
  const AppPhotoImage({
    super.key,
    required this.localPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  final String localPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final WidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final file = File(localPath);

    if (localPath.trim().isEmpty || !file.existsSync()) {
      return errorBuilder?.call(context) ?? _defaultError();
    }

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorBuilder?.call(context) ?? _defaultError();
      },
    );
  }

  Widget _defaultError() {
    return Container(
      color: const Color(0xFFF2F4F7),
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image_outlined, color: Color(0xFF98A2B3)),
    );
  }
}
