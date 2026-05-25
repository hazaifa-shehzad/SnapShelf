import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
    this.onPasswordChanged,
  });

  final ValueChanged<String>? onPasswordChanged;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _hideOldPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;
  bool _isSubmitting = false;

  static const Color _primary = Color(0xFF8179DC);
  static const Color _text = Color(0xFF15151D);
  static const Color _muted = Color(0xFF8A91A3);
  static const Color _fieldBorder = Color(0xFFE0E2EA);

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 21),
                  color: const Color(0xFF2F3037),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Set a New Password',
                  style: TextStyle(
                    color: _text,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Create a strong password to secure your account',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 26),
                _PasswordField(
                  label: 'Old Password',
                  hintText: 'Enter Old Password',
                  controller: _oldPasswordController,
                  obscureText: _hideOldPassword,
                  onToggleVisibility: () => setState(() => _hideOldPassword = !_hideOldPassword),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) return 'Old password is required';
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                _PasswordField(
                  label: 'New Password',
                  hintText: 'Enter New Password',
                  controller: _newPasswordController,
                  obscureText: _hideNewPassword,
                  onToggleVisibility: () => setState(() => _hideNewPassword = !_hideNewPassword),
                  validator: _newPasswordValidator,
                ),
                const SizedBox(height: 22),
                _PasswordField(
                  label: 'Confirm New Password',
                  hintText: 'Rewrite New Password',
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirmPassword,
                  onToggleVisibility: () => setState(() => _hideConfirmPassword = !_hideConfirmPassword),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) return 'Confirm password is required';
                    if (value != _newPasswordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 51,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      disabledBackgroundColor: _primary.withOpacity(0.55),
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Reset',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _newPasswordValidator(String? value) {
    final password = value?.trim() ?? '';
    if (password.isEmpty) return 'New password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password == _oldPasswordController.text.trim()) return 'New password must be different';
    return null;
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    widget.onPasswordChanged?.call(_newPasswordController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset successfully.')),
    );
    Navigator.of(context).maybePop();
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _ChangePasswordScreenState._text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: const TextStyle(
            color: _ChangePasswordScreenState._text,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFFA7ACB8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                size: 18,
                color: const Color(0xFFB0B5C2),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _ChangePasswordScreenState._fieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _ChangePasswordScreenState._fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: _ChangePasswordScreenState._primary, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
