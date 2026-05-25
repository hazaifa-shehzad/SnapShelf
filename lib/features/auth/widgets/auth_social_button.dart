import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_header.dart';

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.textColor,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 52,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AuthColors.textDark,
            side: BorderSide(color: AuthColors.border.withOpacity(.75)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: icon == null
              ? Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: textColor ?? AuthColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : Icon(icon, color: textColor ?? AuthColors.textDark, size: 24),
        ),
      ),
    );
  }
}

class AuthSocialDivider extends StatelessWidget {
  const AuthSocialDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AuthColors.border.withOpacity(.9))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(text, style: AuthTextStyles.small()),
        ),
        Expanded(child: Divider(color: AuthColors.border.withOpacity(.9))),
      ],
    );
  }
}
