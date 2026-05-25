import 'package:flutter/material.dart';

import '../screens/privacy_policy_screen.dart';
import '../screens/profile_setting_screen.dart';
import '../screens/terms_conditions_screen.dart';
import 'delete_account_dialog.dart';
import 'logout_dialog.dart';
import 'profile_menu_tile.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    this.userName = 'Hazaifa',
    this.avatarAssetPath,
    this.onProfileTap,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onDeleteAccount,
    this.onLogout,
  });

  final String userName;
  final String? avatarAssetPath;
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
          border: Border(
            right: BorderSide(color: _primary, width: 5),
          ),
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
                        onPressed: () => Scaffold.maybeOf(context)?.closeDrawer(),
                        icon: const Icon(Icons.menu_rounded, size: 17, color: _primary),
                      ),
                    ),
                    const Spacer(),
                    _Avatar(assetPath: avatarAssetPath),
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
                    onDelete: onDeleteAccount ?? () => _showMessage(context, 'Delete account action confirmed.'),
                  ),
                ),
                const Spacer(),
                ProfileMenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  iconBackgroundColor: const Color(0xFFEDEBFF),
                  iconColor: _primary,
                  margin: EdgeInsets.zero,
                  onTap: () => showLogoutDialog(
                    context,
                    onLogout: onLogout ?? () => _showMessage(context, 'Logout action confirmed.'),
                  ),
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
        MaterialPageRoute(builder: (_) => ProfileSettingScreen(avatarAssetPath: avatarAssetPath)),
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
      navigator.push(MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
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
      navigator.push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
    });
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.assetPath});

  final String? assetPath;

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
      child: assetPath == null
          ? const _AvatarFallback()
          : Image.asset(
              assetPath!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _AvatarFallback(),
            ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

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
      child: const Icon(Icons.person_rounded, color: Color(0xFF8179DC), size: 18),
    );
  }
}
