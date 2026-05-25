import 'package:flutter/material.dart';
import '../widgets/auth_header.dart';
import '../widgets/password_success_dialog.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, this.isChangePassword = false});

  final bool isChangePassword;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';
    if (confirmPassword.isEmpty) return 'Confirm password is required';
    if (confirmPassword != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (widget.isChangePassword) {
      showAuthSnackBar(context, 'Password changed successfully.');
      Navigator.maybePop(context);
    } else {
      await PasswordSuccessDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isChangePassword
        ? 'Set a New Password'
        : 'Set a New Password';

    return Scaffold(
      backgroundColor: AuthColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 18, 26, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: AuthBackButton(),
                ),
                const SizedBox(height: 20),
                AuthHeader(
                  title: title,
                  subtitle: 'Create a strong password to secure your account',
                ),
                const SizedBox(height: 28),
                if (widget.isChangePassword) ...[
                  AuthTextField(
                    label: 'Old Password',
                    hint: 'Enter Old Password',
                    controller: _oldPasswordController,
                    isPassword: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 18),
                ],
                AuthTextField(
                  label: 'New Password',
                  hint: 'Enter New Password',
                  controller: _newPasswordController,
                  isPassword: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  label: 'Confirm New Password',
                  hint: 'Rewrite New Password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 44),
                AuthPrimaryButton(
                  text: 'Reset',
                  isLoading: _isLoading,
                  onPressed: _resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
