import 'package:flutter/material.dart';

import '../data/dummy/dummy_user.dart';
import '../data/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = DummyUser.currentUser;
  bool _isLoading = false;

  UserModel get user => _user;
  bool get isLoading => _isLoading;

  Future<void> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
  }) async {
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _user = _user.copyWith(
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim(),
      avatarUrl: avatarUrl,
    );
    _setLoading(false);
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final isValid = currentPassword.isNotEmpty &&
        newPassword.length >= 6 &&
        newPassword == confirmPassword;
    _setLoading(false);
    return isValid;
  }

  Future<void> deleteAccount() async {
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
