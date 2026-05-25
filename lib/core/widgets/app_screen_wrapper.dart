import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../utils/responsive.dart';

class AppScreenWrapper extends StatelessWidget {
  const AppScreenWrapper({
    super.key,
    required this.child,
    this.padding,
    this.safeArea = true,
    this.backgroundColor = AppColors.background,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: AppSizes.lg,
          ),
      child: child,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: safeArea ? SafeArea(child: content) : content,
    );
  }
}
