import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../data/services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  bool _rememberMe = true;
  String? _errorMessage;
  UserModel? _user;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get rememberMe => _rememberMe;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  AuthProvider() {
    checkSession();
  }

  Future<void> checkSession() async {
    _setLoading(true);
    _isAuthenticated = await LocalStorageService.isLoggedIn();
    _rememberMe = await LocalStorageService.getRememberMe();

    if (_isAuthenticated) {
      final email = await LocalStorageService.getUserEmail();
      if (email != null && email.trim().isNotEmpty) {
        _user = _userFromEmail(email.trim());
      } else {
        _isAuthenticated = false;
      }
    }

    _setLoading(false);
  }

  void updateRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _clearError();
    _setLoading(true);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Please enter email and password.';
      _setLoading(false);
      return false;
    }

    _user = _userFromEmail(email.trim());
    _isAuthenticated = true;

    await LocalStorageService.saveLogin(
      email: _user!.email,
      name: _user!.name,
      rememberMe: _rememberMe,
    );

    _setLoading(false);
    return true;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _clearError();
    _setLoading(true);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      _errorMessage = 'Please fill all required fields.';
      _setLoading(false);
      return false;
    }

    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: email.trim(),
      createdAt: DateTime.now(),
    );
    _isAuthenticated = true;

    await LocalStorageService.saveLogin(
      email: _user!.email,
      name: _user!.name,
      rememberMe: true,
    );

    _setLoading(false);
    return true;
  }

  Future<bool> sendPasswordResetCode(String email) async {
    _clearError();
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _setLoading(false);
    return email.trim().isNotEmpty;
  }

  Future<void> updateEmail(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || _user == null) return;

    _user = _user!.copyWith(
      email: trimmedEmail,
      name: _displayNameFromEmail(trimmedEmail),
    );

    await LocalStorageService.saveLogin(
      email: _user!.email,
      name: _user!.name,
      rememberMe: _rememberMe,
    );
    notifyListeners();
  }

  Future<bool> verifyOtp(String code) async {
    _clearError();
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final isValid = code.trim().length == 4 || code.trim().length == 6;
    if (!isValid) _errorMessage = 'Please enter a valid verification code.';
    _setLoading(false);
    return isValid;
  }

  Future<bool> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    _clearError();
    _setLoading(true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final isValid = password.isNotEmpty && password == confirmPassword;
    if (!isValid) _errorMessage = 'Passwords do not match.';

    _setLoading(false);
    return isValid;
  }

  Future<void> logout() async {
    _setLoading(true);
    await LocalStorageService.clearSession();
    _isAuthenticated = false;
    _user = null;
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  UserModel _userFromEmail(String email) {
    return UserModel(
      id: email,
      name: _displayNameFromEmail(email),
      email: email,
      createdAt: DateTime.now(),
    );
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
}
