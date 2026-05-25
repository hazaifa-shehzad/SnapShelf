import 'package:flutter/material.dart';
import 'auth_header.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.normalText,
    required this.actionText,
    required this.onTap,
  });

  final String normalText;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            normalText,
            style: AuthTextStyles.small(color: AuthColors.textDark),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: AuthTextStyles.small(color: AuthColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
