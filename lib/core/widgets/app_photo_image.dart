import 'dart:io';

import 'package:flutter/material.dart';

class AppPhotoImage extends StatelessWidget {
  const AppPhotoImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? errorBuilder;

  bool get _isNetworkImage {
    final uri = Uri.tryParse(imageUrl);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingBuilder?.call(context) ?? _defaultLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorBuilder?.call(context) ?? _defaultError();
        },
      );
    }

    return Image.file(
      File(imageUrl),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorBuilder?.call(context) ?? _defaultError();
      },
    );
  }

  Widget _defaultLoading() {
    return Container(
      color: const Color(0xFFF2F4F7),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
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
