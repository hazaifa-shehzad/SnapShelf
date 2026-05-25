import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import 'auth_header.dart';

class PasswordSuccessDialog extends StatelessWidget {
  const PasswordSuccessDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PasswordSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 26, 28, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 76,
              width: 96,
              decoration: BoxDecoration(
                color: AuthColors.lavenderBg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: AuthColors.primary,
                size: 42,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Password Updated Successfully',
              textAlign: TextAlign.center,
              style: AuthTextStyles.heading(size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'You can now log in with your new password',
              textAlign: TextAlign.center,
              style: AuthTextStyles.subtitle(size: 12),
            ),
            const SizedBox(height: 24),
            AuthPrimaryButton(
              text: 'Login',
              height: 48,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.login,
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
