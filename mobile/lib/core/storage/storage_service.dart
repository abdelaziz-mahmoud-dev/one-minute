import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefs {
    if (_preferences == null) {
      throw StateError(
        'StorageService has not been initialized. '
        'Call StorageService.instance.init() first.',
      );
    }

    return _preferences!;
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(StorageKeys.token, token);
  }

  String? getToken() {
    return _prefs.getString(StorageKeys.token);
  }

  Future<void> removeToken() async {
    await _prefs.remove(StorageKeys.token);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString(
      StorageKeys.user,
      jsonEncode(user),
    );
  }

  Map<String, dynamic>? getUser() {
    final userJson = _prefs.getString(StorageKeys.user);

    if (userJson == null || userJson.isEmpty) {
      return null;
    }

    try {
      return Map<String, dynamic>.from(
        jsonDecode(userJson) as Map,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> removeUser() async {
    await _prefs.remove(StorageKeys.user);
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(
      StorageKeys.onboardingCompleted,
      completed,
    );
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(
          StorageKeys.onboardingCompleted,
        ) ??
        false;
  }

  Future<void> clearSession() async {
    await removeToken();
    await removeUser();
  }
}