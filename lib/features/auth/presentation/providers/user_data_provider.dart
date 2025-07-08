import 'package:diabary/domain/models/user_model.dart';
import 'package:diabary/domain/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? _userData;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setters
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  UserDataProvider(this._userRepository);

  Future<void> loadUserData(String uid) async {
    try {
      final user = await _userRepository.getUserById(uid);

      if (user == null) {
        _setError('Usuário não encontrado.');
      }
      _userData = user;
    } catch (e) {
      _setError('Erro ao carregar dados do usuário');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveUserData(UserModel user) async {
    _setLoading(true);
    try {
      await _userRepository.saveUser(user);
      _userData = user;
    } catch (e) {
      _setError('Erro ao salvar dados do usuário');
    } finally {
      _setLoading(false);
    }
  }

  void clearUserData() {
    _userData = null;
    notifyListeners();
  }
}
