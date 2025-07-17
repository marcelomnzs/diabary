import 'dart:async';

import 'package:diabary/data/auth_service.dart';
import 'package:diabary/domain/models/user_model.dart';
import 'package:diabary/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  final UserRepository _userRepository;
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _onboardingCompleted = false;
  UserModel? _userData;

  AuthProvider(this._authService, this._userRepository) {
    // Monitora alguma mudança na autenticação
    _authService.authStateChanges.listen((user) async {
      _user = user;

      if (user != null) {
        await _userRepository.createUserDocIfNotExists(user);
        final userModel = await _userRepository.getUserById(user.uid);
        _onboardingCompleted = userModel?.onboardingCompleted == true;
      } else {
        _onboardingCompleted = false;
      }
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get onboardingCompleted => _onboardingCompleted;
  UserModel? get userData => _userData;

  // Setters
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setOnboardingCompleted(bool value) {
    _onboardingCompleted = value;
    notifyListeners();
  }

  // Auth Functions
  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      await _authService.signIn(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      _setLoading(true);
      await _authService.createAccount(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      await _authService.resetPassword(email: email);
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUsername(String username) async {
    try {
      _setLoading(true);
      await _authService.updateUsername(username: username);
      await _authService.currentUser?.reload();
      _user = _authService.currentUser;
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount(String email, String password) async {
    try {
      _setLoading(true);
      await _authService.deleteAccount(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPasswordFromCurrentPassword(
    String currentPassword,
    String newPassword,
    String email,
  ) async {
    try {
      _setLoading(true);
      await _authService.resetPasswordFromCurrentPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        email: email,
      );
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);

      await _authService.signOut();

      _user = null;
      _userData = null;

      notifyListeners();
    } on FirebaseAuthException catch (exception) {
      _error = _parseFirebaseError(exception.code);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeOnboarding() async {
    if (_user == null) return;

    await _userRepository.saveUser(
      UserModel(
        id: _user!.uid,
        email: _user!.email!,
        name: _user!.displayName ?? '',
        onboardingCompleted: true,
      ),
    );

    _onboardingCompleted = true;
    notifyListeners();
  }

  String _parseFirebaseError(String code) {
    const Map<String, String> messages = {
      'user-not-found': 'Usuário não encontrado',
      'wrong-password': 'Senha incorreta',
      'email-already-in-use': 'E-mail já cadastrado',
      'invalid-email': 'E-mail inválido',
      'weak-password': 'A senha não corresponde aos parâmetros de segurança',
    };

    return messages[code] ?? 'Erro desconhecido';
  }
}
