import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'auth_header.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({
    super.key,
    required this.controller,
    this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 66,
      height: 66,
      textStyle: AuthTextStyles.heading(size: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AuthColors.border.withOpacity(.8)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );

    return Pinput(
      controller: controller,
      length: 4,
      autofocus: true,
      keyboardType: TextInputType.number,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: AuthColors.primary, width: 1.4),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: AuthColors.primary.withOpacity(.75)),
        ),
      ),
      onCompleted: onCompleted,
    );
  }
}
