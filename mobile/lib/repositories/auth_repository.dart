import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _authService.register(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    return _authService.login(
      email: email,
      password: password,
    );
  }

  Future<UserModel> getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Future<UserModel> updateProfile({
    required String name,
  }) {
    return _authService.updateProfile(
      name: name,
    );
  }

  Future<UserModel> updateInterests({
    required List<String> interests,
    String? level,
  }) {
    return _authService.updateInterests(
      interests: interests,
      level: level,
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _authService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> logout() {
    return _authService.logout();
  }

  bool isAuthenticated() {
    return _authService.isAuthenticated();
  }
}