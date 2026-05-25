import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../widgets/auth_header.dart';
import '../widgets/otp_input_field.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _otpController = TextEditingController();
  int _seconds = 20;
  Timer? _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 20);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 0) {
        timer.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _verify() async {
    if (_otpController.text.trim().length != 4) {
      showAuthSnackBar(context, 'Please enter the 4-digit code.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushNamed(RouteNames.resetPassword);
  }

  String get _timerText {
    final seconds = _seconds.toString().padLeft(2, '0');
    return '00:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 24),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: AuthBackButton(),
              ),
              const SizedBox(height: 20),
              const AuthHeader(
                title: 'Please check your email',
                subtitle: 'A verification code has been sent to your email',
              ),
              const SizedBox(height: 28),
              OtpInputField(
                controller: _otpController,
                onCompleted: (_) => FocusScope.of(context).unfocus(),
              ),
              const SizedBox(height: 46),
              AuthPrimaryButton(
                text: 'Verify',
                isLoading: _isLoading,
                onPressed: _verify,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _seconds == 0
                        ? () {
                            showAuthSnackBar(context, 'Verification code resent.');
                            _startTimer();
                          }
                        : null,
                    child: Text(
                      'Send code again',
                      style: AuthTextStyles.small(
                        color: _seconds == 0
                            ? AuthColors.primary
                            : AuthColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _timerText,
                    style: AuthTextStyles.small(color: AuthColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
