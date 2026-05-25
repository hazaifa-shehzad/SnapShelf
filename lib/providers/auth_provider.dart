import 'package:flutter/material.dart';

import '../data/dummy/dummy_user.dart';
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
      final name = await LocalStorageService.getUserName();
      _user = DummyUser.currentUser.copyWith(
        email: email ?? DummyUser.currentUser.email,
        name: name ?? DummyUser.currentUser.name,
      );
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

    _user = DummyUser.currentUser.copyWith(email: email.trim());
    _isAuthenticated = true;

    await LocalStorageService.saveLogin(
      email: email.trim(),
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

    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
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
}
