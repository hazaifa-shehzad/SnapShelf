import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_photo_image.dart';
import '../../../providers/auth_provider.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/profile_setting_screen.dart';
import '../screens/terms_conditions_screen.dart';
import 'delete_account_dialog.dart';
import 'logout_dialog.dart';
import 'profile_menu_tile.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    this.onProfileTap,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onDeleteAccount,
    this.onLogout,
  });

  final VoidCallback? onProfileTap;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onDeleteAccount;
  final VoidCallback? onLogout;

  static const Color _primary = Color(0xFF8179DC);
  static const Color _drawerBg = Color(0xFFFCFCFF);
  static const Color _screenTint = Color(0xFFECEBFF);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final drawerWidth = size.width < 380 ? size.width * 0.73 : 292.0;
    final user = context.watch<AuthProvider>().user;

    return Drawer(
      width: drawerWidth,
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: _drawerBg,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
          border: Border(right: BorderSide(color: _primary, width: 5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 18, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _screenTint,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            Scaffold.maybeOf(context)?.closeDrawer(),
                        icon: const Icon(
                          Icons.menu_rounded,
                          size: 17,
                          color: _primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _Avatar(
                      avatarUrl: user?.avatarUrl,
                      initials: user?.initials ?? 'U',
                    ),
                  ],
                ),
                const SizedBox(height: 72),
                ProfileMenuTile(
                  icon: Icons.person_rounded,
                  title: 'Profile Setting',
                  iconBackgroundColor: const Color(0xFFFFD7EA),
                  iconColor: const Color(0xFFFF5FA0),
                  onTap: () => _openProfileSetting(context),
                ),
                ProfileMenuTile(
                  icon: Icons.edit_note_rounded,
                  title: 'Terms & Conditions',
                  iconBackgroundColor: const Color(0xFFE6EEFF),
                  iconColor: const Color(0xFF6597DD),
                  onTap: () => _openTerms(context),
                ),
                ProfileMenuTile(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  iconBackgroundColor: const Color(0xFFD8FBF8),
                  iconColor: const Color(0xFF25C7BD),
                  onTap: () => _openPrivacy(context),
                ),
                ProfileMenuTile(
                  icon: Icons.delete_rounded,
                  title: 'Delete Account',
                  iconBackgroundColor: const Color(0xFFFFDEDE),
                  iconColor: const Color(0xFFFF5959),
                  onTap: () => showDeleteAccountDialog(
                    context,
                    onDelete:
                        onDeleteAccount ??
                        () => _showMessage(
                          context,
                          'Delete account action confirmed.',
                        ),
                  ),
                ),
                const Spacer(),
                ProfileMenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  iconBackgroundColor: const Color(0xFFEDEBFF),
                  iconColor: _primary,
                  margin: EdgeInsets.zero,
                  onTap: () => _confirmLogout(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openProfileSetting(BuildContext context) {
    if (onProfileTap != null) {
      onProfileTap!();
      return;
    }
    final navigator = Navigator.of(context);
    Scaffold.maybeOf(context)?.closeDrawer();
    Future.delayed(const Duration(milliseconds: 150), () {
      navigator.push(
        MaterialPageRoute(builder: (_) => const ProfileSettingScreen()),
      );
    });
  }

  void _openTerms(BuildContext context) {
    if (onTermsTap != null) {
      onTermsTap!();
      return;
    }
    final navigator = Navigator.of(context);
    Scaffold.maybeOf(context)?.closeDrawer();
    Future.delayed(const Duration(milliseconds: 150), () {
      navigator.push(
        MaterialPageRoute(builder: (_) => const TermsConditionsScreen()),
      );
    });
  }

  void _openPrivacy(BuildContext context) {
    if (onPrivacyTap != null) {
      onPrivacyTap!();
      return;
    }
    final navigator = Navigator.of(context);
    Scaffold.maybeOf(context)?.closeDrawer();
    Future.delayed(const Duration(milliseconds: 150), () {
      navigator.push(
        MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
      );
    });
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showLogoutDialog(context);
    if (shouldLogout != true || !context.mounted) return;

    if (onLogout != null) {
      onLogout!();
      return;
    }

    _showMessage(context, 'Logout action confirmed.');
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.avatarUrl, required this.initials});

  final String? avatarUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl == null || avatarUrl!.trim().isEmpty
          ? _AvatarFallback(initials: initials)
          : AppPhotoImage(
              imageUrl: avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_) => _AvatarFallback(initials: initials),
            ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE0EF), Color(0xFFE7E4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        initials,
        maxLines: 1,
        style: const TextStyle(
          color: Color(0xFF8179DC),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
