import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const Color _text = Color(0xFF15151D);
  static const Color _muted = Color(0xFF6F7685);
  static const Color _primary = Color(0xFF8179DC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _BackButtonRow(),
              SizedBox(height: 24),
              Text(
                'Terms and conditions',
                style: TextStyle(
                  color: _text,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.45,
                ),
              ),
              SizedBox(height: 14),
              _SectionTitle('Introduction'),
              SizedBox(height: 12),
              _Paragraph(
                'Welcome to SnapShelf. These terms explain how you may use the app, save photos locally on your device, create albums, manage your profile, and control your account. By using the app, you agree to use it responsibly and keep your login details secure.',
              ),
              SizedBox(height: 12),
              _Bullet(
                'You are responsible for the photos, names, captions, and album information you save.',
              ),
              _Bullet(
                'Do not save content that violates another person\'s rights, privacy, or local laws.',
              ),
              _Bullet(
                'Keep your password private and notify support if you think your account has been accessed without permission.',
              ),
              SizedBox(height: 22),
              _SectionTitle('Account usage'),
              SizedBox(height: 12),
              _Paragraph(
                'The app is designed for personal photo organization and safe image viewing. You may create albums, browse all photos, open single photo views, update your profile, reset your password, and remove your account when needed.',
              ),
              SizedBox(height: 12),
              _Bullet(
                'Firestore stores metadata for album tracking and photo lists, while image files remain on your device.',
              ),
              _Bullet(
                'Saved photos should be your own or shared with permission.',
              ),
              _Bullet(
                'Account deletion can remove related Firestore metadata. Local files may also be removed with app data on the device.',
              ),
              SizedBox(height: 22),
              _SectionTitle('Service availability'),
              SizedBox(height: 12),
              _Paragraph(
                'We aim to keep the app simple, stable, and secure. Some features depend on Firebase Auth and Firestore availability. Image files stay in local app storage on your device.',
              ),
              SizedBox(height: 22),
              _SectionTitle('Changes to these terms'),
              SizedBox(height: 12),
              _Paragraph(
                'These terms may be updated when new features are added. Continued use of the app after an update means you accept the updated terms.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButtonRow extends StatelessWidget {
  const _BackButtonRow();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_rounded, size: 21),
      color: const Color(0xFF2F3037),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: TermsConditionsScreen._text,
        fontSize: 13.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: TermsConditionsScreen._muted,
        height: 1.55,
        fontSize: 11.6,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: TermsConditionsScreen._primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: _Paragraph(text)),
        ],
      ),
    );
  }
}
