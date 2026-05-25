import 'package:flutter/material.dart';

Future<bool?> showLogoutDialog(
  BuildContext context, {
  VoidCallback? onLogout,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => LogoutDialog(onLogout: onLogout),
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({
    super.key,
    this.onCancel,
    this.onLogout,
  });

  final VoidCallback? onCancel;
  final VoidCallback? onLogout;

  static const Color _primary = Color(0xFF8179DC);
  static const Color _text = Color(0xFF191922);
  static const Color _muted = Color(0xFF7D8392);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LogoutIcon(),
              const SizedBox(height: 12),
              const Text(
                'Logout',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you sure you want to logout your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted,
                  height: 1.45,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          onCancel?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _muted,
                          side: const BorderSide(color: Color(0xFFD0D5DD)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          onLogout?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutIcon extends StatelessWidget {
  const _LogoutIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEBFF),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Icon(
            Icons.logout_rounded,
            color: LogoutDialog._primary,
            size: 32,
          ),
        ],
      ),
    );
  }
}
