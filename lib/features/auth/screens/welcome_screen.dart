import 'package:flutter/material.dart';

import '../../../core/routes/route_names.dart';
import '../widgets/auth_header.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.scaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const _WelcomeIllustration(),
              const SizedBox(height: 34),
              const AuthHeader(
                title: 'Welcome to SnapShelf',
                subtitle:
                    'Keep your favorite moments neatly organized. Upload photos, create albums, and find every memory again whenever you need it.',
                center: true,
                titleSize: 23,
              ),
              const Spacer(flex: 2),
              AuthPrimaryButton(
                text: 'Login',
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.login);
                },
              ),
              const SizedBox(height: 14),
              AuthOutlinedButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.signup);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 240,
      child: Image.asset(
        'assets/images/snapshelf_logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
