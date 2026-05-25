import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                'Privacy Policy',
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
                'Your privacy is important. This policy explains what information the photo storage app may use when you create an account, upload images, create albums, update profile settings, or delete your account.',
              ),
              SizedBox(height: 12),
              _Bullet('Profile information such as email address and avatar may be used to personalize your account.'),
              _Bullet('Photo and album data is used to show your uploads, albums, and photo detail screens.'),
              _Bullet('Password fields are handled through secure authentication when a backend is connected.'),
              SizedBox(height: 22),
              _SectionTitle('Information we collect'),
              SizedBox(height: 12),
              _Paragraph(
                'In the frontend version, sample data can be stored locally in memory for demo purposes. After backend integration, the app may store authentication data, profile details, album names, photo metadata, and uploaded images in your selected cloud service.',
              ),
              SizedBox(height: 12),
              _Bullet('We only request data needed for account access and photo organization.'),
              _Bullet('Uploaded photos should be visible only through your authenticated account once backend rules are connected.'),
              _Bullet('Delete account actions should also remove related cloud records when backend deletion is implemented.'),
              SizedBox(height: 22),
              _SectionTitle('How we protect data'),
              SizedBox(height: 12),
              _Paragraph(
                'The final production app should use authenticated routes, secure storage rules, protected API calls, and validation on both frontend and backend. Do not store raw passwords inside local app state or database records.',
              ),
              SizedBox(height: 22),
              _SectionTitle('Your control'),
              SizedBox(height: 12),
              _Paragraph(
                'You can update your profile, reset your password, remove photos, and request account deletion from the profile menu. Backend services should honor these actions with clear confirmation states.',
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
        color: PrivacyPolicyScreen._text,
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
        color: PrivacyPolicyScreen._muted,
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
              color: PrivacyPolicyScreen._primary,
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
