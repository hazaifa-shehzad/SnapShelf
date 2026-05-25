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
                title: 'Welcome to [App Name]',
                subtitle:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ipsum ipsum, tempus a sodales vel, tempus quis est. Morbi vehicula enim eu tortor cursus laoreet.',
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 190,
            width: 190,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEEFF),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 18,
            child: Container(
              height: 66,
              width: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF82B9F7),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.upload_rounded, color: Colors.white, size: 34),
            ),
          ),
          Positioned(
            left: 32,
            bottom: 44,
            child: _ImageTile(
              color: const Color(0xFFFF8FA3),
              rotation: -.16,
              icon: Icons.photo_outlined,
            ),
          ),
          Positioned(
            right: 35,
            bottom: 48,
            child: _ImageTile(
              color: const Color(0xFF817BE6),
              rotation: .12,
              icon: Icons.folder_outlined,
            ),
          ),
          Positioned(
            bottom: 28,
            child: _ImageTile(
              color: const Color(0xFFFFCBD7),
              rotation: 0,
              icon: Icons.image_outlined,
            ),
          ),
          Positioned(
            bottom: 8,
            left: 82,
            child: _ImageTile(
              color: const Color(0xFF7BA8FF),
              rotation: -.22,
              icon: Icons.landscape_outlined,
              small: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.color,
    required this.rotation,
    required this.icon,
    this.small = false,
  });

  final Color color;
  final double rotation;
  final IconData icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        height: small ? 54 : 78,
        width: small ? 54 : 78,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.white, width: 4),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AuthColors.primary.withOpacity(.13),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: small ? 24 : 34),
      ),
    );
  }
}
