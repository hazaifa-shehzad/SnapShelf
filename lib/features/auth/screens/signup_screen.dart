import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_social_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@')) return 'Enter a valid email';
    return null;
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
    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    setState(() => _isLoading = true);
    final success = await authProvider.signup(
      name: _displayNameFromEmail(_emailController.text.trim()),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      showAuthSnackBar(
        context,
        authProvider.errorMessage ?? 'Signup failed. Please try again.',
      );
      return;
    }

    showAuthSnackBar(context, 'Account created successfully.');
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
  }

  String _displayNameFromEmail(String email) {
    final localPart = email.split('@').first.trim();
    if (localPart.isEmpty) return 'User';

    return localPart
        .split(RegExp(r'[._\-\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
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
                const AuthHeader(
                  title: 'Create a New Account',
                  subtitle: 'Join us and start your journey today',
                ),
                const SizedBox(height: 26),
                AuthTextField(
                  label: 'Email',
                  hint: 'Enter Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  label: 'Password',
                  hint: 'Enter Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  label: 'Confirm Password',
                  hint: 'Rewrite Password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 36),
                AuthPrimaryButton(
                  text: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: _signup,
                ),
                const SizedBox(height: 26),
                const AuthSocialDivider(text: 'Or Log In with'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AuthSocialButton(
                      label: 'G',
                      textColor: const Color(0xFF4285F4),
                      onTap: () => showAuthSnackBar(
                        context,
                        'Google signup will connect later.',
                      ),
                    ),
                    const SizedBox(width: 14),
                    AuthSocialButton(
                      label: 'Apple',
                      icon: Icons.apple_rounded,
                      onTap: () => showAuthSnackBar(
                        context,
                        'Apple signup will connect later.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AuthFooterLink(
                  normalText: 'Already have an account? ',
                  actionText: 'Log In',
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(RouteNames.login);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
