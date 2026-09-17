import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService =
            storageService ?? StorageService.instance;

  final ApiClient _apiClient;
  final StorageService _storageService;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      },
    );

    return _handleAuthResponse(response);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    return _handleAuthResponse(response);
  }

  Future<UserModel> getCurrentUser() async {
    final token = _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw StateError('No authentication token found.');
    }

    final response = await _apiClient.get(
      ApiConstants.me,
      token: token,
    );

    final userJson = _extractUser(response);

    final user = UserModel.fromJson(userJson);

    await _storageService.saveUser(user.toJson());

    return user;
  }

  Future<UserModel> updateProfile({
    required String name,
  }) async {
    final token = _requireToken();

    final response = await _apiClient.patch(
      ApiConstants.profile,
      token: token,
      body: {
        'name': name.trim(),
      },
    );

    final user = UserModel.fromJson(
      _extractUser(response),
    );

    await _storageService.saveUser(user.toJson());

    return user;
  }

  Future<UserModel> updateInterests({
    required List<String> interests,
    String? level,
  }) async {
    final token = _requireToken();

    final body = <String, dynamic>{
      'interests': interests,
    };

    if (level != null) {
      body['level'] = level;
    }

    final response = await _apiClient.patch(
      ApiConstants.interests,
      token: token,
      body: body,
    );

    final user = UserModel.fromJson(
      _extractUser(response),
    );

    await _storageService.saveUser(user.toJson());

    return user;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = _requireToken();

    await _apiClient.patch(
      ApiConstants.password,
      token: token,
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> logout() async {
    await _storageService.clearSession();
  }

  bool isAuthenticated() {
    final token = _storageService.getToken();

    return token != null && token.isNotEmpty;
  }

  String _requireToken() {
    final token = _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw StateError('User is not authenticated.');
    }

    return token;
  }

  Future<UserModel> _handleAuthResponse(
    dynamic response,
  ) async {
    final outer = _asMap(response);
    final data = outer['data'] is Map
        ? Map<String, dynamic>.from(outer['data'] as Map)
        : outer;

    final token = data['token']?.toString();

    if (token == null || token.isEmpty) {
      throw StateError(
        'Authentication response did not contain a token.',
      );
    }

    await _storageService.saveToken(token);

    final user = UserModel.fromJson(
      _extractUser(data),
    );

    await _storageService.saveUser(user.toJson());

    return user;
  }

  Map<String, dynamic> _extractUser(dynamic response) {
    final data = _asMap(response);

    final user = data['user'];

    if (user is Map) {
      return Map<String, dynamic>.from(user);
    }

    return data;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    throw StateError(
      'Unexpected server response format.',
    );
  }
}