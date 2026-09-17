import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthRepository? repository,
  }) : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _repository.isAuthenticated();

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      _user = await _repository.login(
        email: email,
        password: password,
      );

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      _user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCurrentUser() async {
    if (!_repository.isAuthenticated()) {
      return;
    }

    _setLoading(true);

    try {
      _user = await _repository.getCurrentUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
  }) async {
    _setLoading(true);

    try {
      _user = await _repository.updateProfile(
        name: name,
      );

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateInterests({
    required List<String> interests,
    String? level,
  }) async {
    _setLoading(true);

    try {
      _user = await _repository.updateInterests(
        interests: interests,
        level: level,
      );

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void updateLocalUser(UserModel? user) {
    if (user == null) return;

    _user = user;
    notifyListeners();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);

    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _repository.logout();

    _user = null;
    _error = null;

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}