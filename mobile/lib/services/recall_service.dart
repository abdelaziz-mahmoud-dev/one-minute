import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';
import '../models/recall_model.dart';

class RecallService {
  RecallService({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService =
            storageService ?? StorageService.instance;

  final ApiClient _apiClient;
  final StorageService _storageService;

  Future<List<RecallModel>> getRecallItems() async {
    final token = _requireToken();

    final response = await _apiClient.get(
      ApiConstants.recall,
      token: token,
    );

    return _extractList(response)
        .map(RecallModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> answerRecall({
    required String recallId,
    required int score,
  }) async {
    if (score < 0 || score > 5) {
      throw ArgumentError(
        'Recall score must be between 0 and 5.',
      );
    }

    final token = _requireToken();

    final response = await _apiClient.post(
      ApiConstants.answerRecall(recallId),
      token: token,
      body: {
        'score': score,
      },
    );

    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    return {
      'success': true,
    };
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

  List<Map<String, dynamic>> _extractList(
    dynamic response,
  ) {
    dynamic data = response;

    if (response is Map) {
      data = response['data'] ??
          response['items'] ??
          response['recall'];
    }

    if (data is Map) {
      data = data['recalls'] ??
          data['items'] ??
          data['data'];
    }

    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }
}