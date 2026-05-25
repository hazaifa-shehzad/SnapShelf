import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/auth_footer_link.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    authProvider.updateRememberMe(_rememberMe);

    setState(() => _isLoading = true);
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!context.mounted) return;
    setState(() => _isLoading = false);

    if (!success) {
      showAuthSnackBar(
        context,
        authProvider.errorMessage ?? 'Login failed. Please try again.',
      );
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.home,
      (route) => false,
    );
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
                  title: 'Let’s Sign you in.',
                  subtitle:
                      'Access your account securely and continue where you left off',
                ),
                const SizedBox(height: 28),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      height: 22,
                      width: 22,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AuthColors.primary,
                        side: const BorderSide(color: AuthColors.primary),
                        onChanged: (value) {
                          setState(() => _rememberMe = value ?? false);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('Remember Me?', style: AuthTextStyles.small(color: AuthColors.primary)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteNames.forgotPassword);
                      },
                      child: Text(
                        'Forgot password?',
                        style: AuthTextStyles.small(color: AuthColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                AuthPrimaryButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: _login,
                ),
                const SizedBox(height: 34),
                const AuthSocialDivider(text: 'Or Sign up with'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    AuthSocialButton(
                      label: 'G',
                      textColor: const Color(0xFF4285F4),
                      onTap: () => showAuthSnackBar(context, 'Google login will connect later.'),
                    ),
                    const SizedBox(width: 14),
                    AuthSocialButton(
                      label: 'Apple',
                      icon: Icons.apple_rounded,
                      onTap: () => showAuthSnackBar(context, 'Apple login will connect later.'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AuthFooterLink(
                  normalText: "Don’t have an account? ",
                  actionText: 'Sign Up',
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(RouteNames.signup);
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
