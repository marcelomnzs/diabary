import 'dart:async';

import 'package:diabary/data/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService) {
    // Monitora alguma mudança na autenticação
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Setters
  void setError(String? error) {
    _error = error;
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

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
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
      await _authService.currentUser?.reload(); // <-- Força recarregar os dados
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

  void _setLoading(bool value) {
    _isLoading = value;
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
