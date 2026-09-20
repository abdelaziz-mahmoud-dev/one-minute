import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';
import '../models/dashboard_model.dart';
import '../models/minute_model.dart';

class DashboardService {
  DashboardService({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService =
            storageService ?? StorageService.instance;

  final ApiClient _apiClient;
  final StorageService _storageService;

  Future<DashboardModel> getDashboard() async {
    final token = _requireToken();

    final response = await _apiClient.get(
      ApiConstants.dashboard,
      token: token,
    );

    return DashboardModel.fromJson(
      _extractObject(
        response,
        key: 'dashboard',
      ),
    );
  }

  Future<MinuteModel> getDailyMinute() async {
    final token = _requireToken();

    final response = await _apiClient.get(
      ApiConstants.daily,
      token: token,
    );

    return MinuteModel.fromJson(
      _extractObject(
        response,
        key: 'minute',
      ),
    );
  }

  String _requireToken() {
    final token = _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw StateError(
        'User is not authenticated.',
      );
    }

    return token;
  }

  Map<String, dynamic> _extractObject(
    dynamic response, {
    required String key,
  }) {
    if (response is! Map) {
      throw StateError(
        'Unexpected server response format.',
      );
    }

    final outer =
        Map<String, dynamic>.from(response);

    dynamic data =
        outer['data'] ??
        outer[key] ??
        outer;

    if (data is Map) {
      final inner = data[key];

      if (inner is Map) {
        return Map<String, dynamic>.from(
          inner,
        );
      }

      return Map<String, dynamic>.from(
        data,
      );
    }

    throw StateError(
      'Invalid $key response format.',
    );
  }
}