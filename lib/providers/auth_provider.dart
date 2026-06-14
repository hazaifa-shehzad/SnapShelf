import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../data/services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    bool loadOnCreate = true,
    fb_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _isTestAuth = false,
       _auth = auth,
       _firestore = firestore {
    if (loadOnCreate) {
      checkSession();
    } else {
      _isLoading = false;
    }
  }

  AuthProvider.testUser(UserModel user)
    : _isTestAuth = true,
      _auth = null,
      _firestore = null,
      _isLoading = false,
      _isAuthenticated = true,
      _user = user;

  final bool _isTestAuth;
  final fb_auth.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  fb_auth.FirebaseAuth get _firebaseAuth =>
      _auth ?? fb_auth.FirebaseAuth.instance;
  FirebaseFirestore get _firebaseFirestore =>
      _firestore ?? FirebaseFirestore.instance;

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

  Future<void> checkSession() async {
    _setLoading(true);

    try {
      _rememberMe = await LocalStorageService.getRememberMe();

      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        _isAuthenticated = false;
        _user = null;
        _setLoading(false);
        return;
      }

      _user = await _getUserFromFirestore(currentUser.uid);

      _user ??= UserModel(
        id: currentUser.uid,
        name:
            currentUser.displayName ??
            _displayNameFromEmail(currentUser.email ?? 'user@gmail.com'),
        email: currentUser.email ?? '',
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;

      await LocalStorageService.saveLogin(
        email: _user!.email,
        name: _user!.name,
        rememberMe: _rememberMe,
      );
    } catch (e) {
      _errorMessage = _cleanError(e);
      _isAuthenticated = false;
      _user = null;
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

    try {
      final trimmedEmail = email.trim();

      if (trimmedEmail.isEmpty || password.trim().isEmpty) {
        _errorMessage = 'Please enter email and password.';
        _setLoading(false);
        return false;
      }

      await _firebaseAuth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password.trim(),
      );

      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        _errorMessage = 'Login failed. Please try again.';
        _setLoading(false);
        return false;
      }

      _user = await _getUserFromFirestore(firebaseUser.uid);

      if (_user == null) {
        _errorMessage = 'User profile was not found. Please contact support.';
        _setLoading(false);
        return false;
      }

      _isAuthenticated = true;

      await LocalStorageService.saveLogin(
        email: _user!.email,
        name: _user!.name,
        rememberMe: _rememberMe,
      );

      _setLoading(false);
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = _firebaseAuthError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _clearError();
    _setLoading(true);

    try {
      final trimmedName = name.trim();
      final trimmedEmail = email.trim();

      if (trimmedName.isEmpty ||
          trimmedEmail.isEmpty ||
          password.trim().isEmpty) {
        _errorMessage = 'Please fill all required fields.';
        _setLoading(false);
        return false;
      }

      if (password.trim().length < 6) {
        _errorMessage = 'Password should be at least 6 characters.';
        _setLoading(false);
        return false;
      }

      await _firebaseAuth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password.trim(),
      );

      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        _errorMessage = 'Signup failed. Please try again.';
        _setLoading(false);
        return false;
      }

      await firebaseUser.updateDisplayName(trimmedName);

      _user = UserModel(
        id: firebaseUser.uid,
        name: trimmedName,
        email: trimmedEmail,
        createdAt: DateTime.now(),
      );

      await _saveUserToFirestore(_user!);

      _user = await _getUserFromFirestore(firebaseUser.uid) ?? _user;

      _isAuthenticated = true;
      _rememberMe = true;

      await LocalStorageService.saveLogin(
        email: _user!.email,
        name: _user!.name,
        rememberMe: true,
      );

      _setLoading(false);
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = _firebaseAuthError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetCode(String email) async {
    _clearError();
    _setLoading(true);

    try {
      final trimmedEmail = email.trim();

      if (trimmedEmail.isEmpty) {
        _errorMessage = 'Please enter your email.';
        _setLoading(false);
        return false;
      }

      await _firebaseAuth.sendPasswordResetEmail(email: trimmedEmail);

      _setLoading(false);
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = _firebaseAuthError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateEmail(String email) async {
    _clearError();
    _setLoading(true);

    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || _user == null) {
      _errorMessage = 'Please enter a valid email address.';
      _setLoading(false);
      return false;
    }

    try {
      if (!_isTestAuth && _firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser!.verifyBeforeUpdateEmail(trimmedEmail);
      }

      _user = _user!.copyWith(email: trimmedEmail);

      await _firebaseFirestore.collection('users').doc(_user!.id).update({
        'email': _user!.email,
        'name': _user!.name,
        'displayName': _user!.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await LocalStorageService.saveLogin(
        email: _user!.email,
        name: _user!.name,
        rememberMe: _rememberMe,
      );

      _setLoading(false);
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = _firebaseAuthError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    _clearError();
    _setLoading(true);

    await Future<void>.delayed(const Duration(milliseconds: 400));

    final isValid = code.trim().length == 4 || code.trim().length == 6;

    if (!isValid) {
      _errorMessage = 'Please enter a valid verification code.';
    }

    _setLoading(false);
    return isValid;
  }

  Future<bool> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    _clearError();
    _setLoading(true);

    final isValid = password.isNotEmpty && password == confirmPassword;

    if (!isValid) {
      _errorMessage = 'Passwords do not match.';
      _setLoading(false);
      return false;
    }

    _setLoading(false);
    return true;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _clearError();
    _setLoading(true);

    try {
      final trimmedCurrentPassword = currentPassword.trim();
      final trimmedNewPassword = newPassword.trim();
      final trimmedConfirmPassword = confirmPassword.trim();

      if (trimmedCurrentPassword.isEmpty ||
          trimmedNewPassword.isEmpty ||
          trimmedConfirmPassword.isEmpty) {
        _errorMessage = 'Please fill all password fields.';
        _setLoading(false);
        return false;
      }

      if (trimmedNewPassword.length < 6) {
        _errorMessage = 'Password must be at least 6 characters.';
        _setLoading(false);
        return false;
      }

      if (trimmedNewPassword != trimmedConfirmPassword) {
        _errorMessage = 'Passwords do not match.';
        _setLoading(false);
        return false;
      }

      if (trimmedCurrentPassword == trimmedNewPassword) {
        _errorMessage = 'New password must be different.';
        _setLoading(false);
        return false;
      }

      if (_isTestAuth) {
        _setLoading(false);
        return true;
      }

      final currentUser = _firebaseAuth.currentUser;
      final email = currentUser?.email ?? _user?.email;

      if (currentUser == null || email == null || email.trim().isEmpty) {
        _errorMessage = 'No active user found.';
        _setLoading(false);
        return false;
      }

      final credential = fb_auth.EmailAuthProvider.credential(
        email: email.trim(),
        password: trimmedCurrentPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(trimmedNewPassword);

      _setLoading(false);
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = _firebaseAuthError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    if (!_isTestAuth) {
      await _firebaseAuth.signOut();
    }
    await LocalStorageService.clearSession();

    _isAuthenticated = false;
    _user = null;

    _setLoading(false);
  }

  Future<bool> deleteAccount() async {
    _clearError();
    _setLoading(true);

    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null || _user == null) {
        _errorMessage = 'No active user found.';
        _setLoading(false);
        return false;
      }

      await _firebaseFirestore.collection('users').doc(_user!.id).delete();
      await currentUser.delete();
      await LocalStorageService.clearSession();

      _isAuthenticated = false;
      _user = null;

      _setLoading(false);
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      _errorMessage = _firebaseAuthError(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = _cleanError(e);
      _setLoading(false);
      return false;
    }
  }

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    final docSnapshot = await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .get();

    if (!docSnapshot.exists || docSnapshot.data() == null) {
      return null;
    }

    final data = docSnapshot.data()!;

    final createdAtValue = data['createdAt'];
    DateTime createdAt = DateTime.now();

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    }

    return UserModel(
      id: data['id'] ?? uid,
      name:
          data['displayName'] ??
          data['name'] ??
          data['fullName'] ??
          _displayNameFromEmail(data['email'] ?? ''),
      email: data['email'] ?? '',
      avatarUrl: data['profileImageUrl'] ?? data['avatarUrl'],
      createdAt: createdAt,
    );
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firebaseFirestore.collection('users').doc(user.id).set({
      'id': user.id,
      'name': user.name,
      'displayName': user.name,
      'email': user.email,
      'avatarText': user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
      'profileImageUrl': '',
      'isActive': true,
      'createdAt': Timestamp.fromDate(user.createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
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

  String _firebaseAuthError(fb_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'requires-recent-login':
        return 'Please logout and login again before doing this action.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
