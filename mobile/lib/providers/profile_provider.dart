import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({
    AuthRepository? repository,
  }) : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  UserModel? _user;

  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}