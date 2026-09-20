import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';
import '../models/category_model.dart';
import '../models/learning_path_model.dart';
import '../models/minute_model.dart';

class LearningService {
  LearningService({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService =
            storageService ?? StorageService.instance;

  final ApiClient _apiClient;
  final StorageService _storageService;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(
      ApiConstants.categories,
      token: _storageService.getToken(),
    );

    final items = _extractList(response);

    return items
        .map(CategoryModel.fromJson)
        .toList();
  }

  Future<List<LearningPathModel>> getLearningPaths({
    String? category,
    String? level,
  }) async {
    final query = <String, String>{};

    if (category != null && category.isNotEmpty) {
      query['category'] = category;
    }

    if (level != null && level.isNotEmpty) {
      query['level'] = level;
    }

    final response = await _apiClient.get(
      ApiConstants.learningPaths,
      token: _storageService.getToken(),
      queryParameters: query.isEmpty ? null : query,
    );

    final items = _extractList(response);

    return items
        .map(LearningPathModel.fromJson)
        .toList();
  }

  Future<LearningPathModel> getLearningPath(
    String id,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.learningPath(id),
      token: _storageService.getToken(),
    );

    final data = _asMap(response)['data'];
    final dataMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    final pathMap = dataMap['path'] is Map
        ? Map<String, dynamic>.from(dataMap['path'] as Map)
        : dataMap;

    if (dataMap['minutes'] is List) {
      pathMap['minutes'] = dataMap['minutes'];
    }

    return LearningPathModel.fromJson(pathMap);
  }

  Future<MinuteModel> getMinute(
    String id,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.minute(id),
      token: _storageService.getToken(),
    );

    return MinuteModel.fromJson(
      _extractObject(response),
    );
  }

  List<Map<String, dynamic>> _extractList(
    dynamic response,
  ) {
    dynamic data = response;

    if (response is Map) {
      data = response['data'] ??
          response['items'] ??
          response['categories'] ??
          response['paths'] ??
          response['minutes'];
    }

    if (data is Map) {
      data = data['categories'] ??
          data['paths'] ??
          data['minutes'] ??
          data['items'];
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

  Map<String, dynamic> _extractObject(
    dynamic response,
  ) {
    if (response is Map<String, dynamic>) {
      dynamic data = response['data'] ?? response['item'] ?? response;

      if (data is Map) {
        final inner = data['minute'] ?? data['path'] ?? data['item'];

        if (inner is Map) {
          return Map<String, dynamic>.from(inner);
        }

        return Map<String, dynamic>.from(data);
      }

      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    throw StateError(
      'Unexpected server response format.',
    );
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