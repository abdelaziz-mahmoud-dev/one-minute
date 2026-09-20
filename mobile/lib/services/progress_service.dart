import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';
import '../models/progress_model.dart';

class ProgressService {
  ProgressService({
    ApiClient? apiClient,
    StorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService =
            storageService ?? StorageService.instance;

  final ApiClient _apiClient;
  final StorageService _storageService;

  Future<ProgressPage> getProgress({
    int page = 1,
    int limit = 20,
  }) async {
    final token = _requireToken();

    final response = await _apiClient.get(
      ApiConstants.progress,
      token: token,
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );

    return _parseProgressPage(response);
  }

  Future<List<ProgressModel>> getCompletedProgress() async {
    final token = _requireToken();

    final response = await _apiClient.get(
      ApiConstants.completedProgress,
      token: token,
    );

    return _extractList(response)
        .map(ProgressModel.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> answerMinute({
    required String minuteId,
    required int answer,
  }) async {
    final token = _requireToken();

    final response = await _apiClient.post(
      ApiConstants.answerMinute(minuteId),
      token: token,
      body: {
        'answer': answer,
      },
    );

    final outer = response is Map
        ? Map<String, dynamic>.from(response)
        : <String, dynamic>{};

    final data = outer['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return outer;
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

  ProgressPage _parseProgressPage(
    dynamic response,
  ) {
    if (response is! Map) {
      return const ProgressPage();
    }

    final outer =
        Map<String, dynamic>.from(response);

    dynamic rawData = outer['data'];

    if (rawData is! Map) {
      rawData = outer;
    }

    final data =
        Map<String, dynamic>.from(rawData);

    final rawProgress = data['progress'];

    final progress = rawProgress is List
        ? rawProgress
            .whereType<Map>()
            .map(
              (item) =>
                  ProgressModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList()
        : <ProgressModel>[];

    final rawSummary = data['summary'];

    final summary = rawSummary is Map
        ? ProgressSummary.fromJson(
            Map<String, dynamic>.from(
              rawSummary,
            ),
          )
        : const ProgressSummary();

    final rawPagination =
        data['pagination'];

    final pagination =
        rawPagination is Map
            ? ProgressPagination.fromJson(
                Map<String, dynamic>.from(
                  rawPagination,
                ),
              )
            : const ProgressPagination();

    return ProgressPage(
      progress: progress,
      summary: summary,
      pagination: pagination,
    );
  }

  List<Map<String, dynamic>> _extractList(
    dynamic response,
  ) {
    dynamic data = response;

    if (response is Map) {
      data = response['data'] ??
          response['items'] ??
          response['progress'];
    }

    if (data is Map) {
      data = data['progress'] ??
          data['items'];
    }

    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map(
          (item) =>
              Map<String, dynamic>.from(item),
        )
        .toList();
  }
}

class ProgressPage {
  final List<ProgressModel> progress;
  final ProgressSummary summary;
  final ProgressPagination pagination;

  const ProgressPage({
    this.progress = const [],
    this.summary = const ProgressSummary(),
    this.pagination =
        const ProgressPagination(),
  });
}