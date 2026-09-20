import '../models/progress_model.dart';
import '../services/progress_service.dart';

class ProgressRepository {
  ProgressRepository({
    ProgressService? progressService,
  }) : _progressService =
            progressService ?? ProgressService();

  final ProgressService _progressService;

  Future<List<ProgressModel>> getProgress({
    int page = 1,
    int limit = 20,
  }) {
    return _progressService.getProgress(
      page: page,
      limit: limit,
    );
  }

  Future<List<ProgressModel>> getCompletedProgress() {
    return _progressService.getCompletedProgress();
  }

  Future<Map<String, dynamic>> answerMinute({
    required String minuteId,
    required int answer,
  }) {
    return _progressService.answerMinute(
      minuteId: minuteId,
      answer: answer,
    );
  }
}