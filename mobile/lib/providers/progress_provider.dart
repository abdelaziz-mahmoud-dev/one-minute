import 'package:flutter/foundation.dart';

import '../models/progress_model.dart';
import '../repositories/progress_repository.dart';

class ProgressProvider extends ChangeNotifier {
  ProgressProvider({
    ProgressRepository? repository,
  }) : _repository =
            repository ?? ProgressRepository();

  final ProgressRepository _repository;

  List<ProgressModel> _progress = [];
  List<ProgressModel> _completedProgress = [];

  ProgressSummary _summary =
      const ProgressSummary();

  ProgressPagination _pagination =
      const ProgressPagination();

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<ProgressModel> get progress => _progress;

  List<ProgressModel> get completedProgress =>
      _completedProgress;

  ProgressSummary get summary => _summary;

  ProgressPagination get pagination =>
      _pagination;

  bool get isLoading => _isLoading;

  bool get isSubmitting => _isSubmitting;

  String? get error => _error;

  Future<void> loadProgress({
    int page = 1,
    int limit = 20,
  }) async {
    _setLoading(true);

    try {
      final result =
          await _repository.getProgress(
        page: page,
        limit: limit,
      );

      _progress = result.progress;
      _summary = result.summary;
      _pagination = result.pagination;

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCompletedProgress() async {
    _setLoading(true);

    try {
      _completedProgress =
          await _repository
              .getCompletedProgress();

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> answerMinute({
    required String minuteId,
    required int answer,
  }) async {
    if (_isSubmitting) {
      return null;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final result =
          await _repository.answerMinute(
        minuteId: minuteId,
        answer: answer,
      );

      return result;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
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