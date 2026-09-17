import 'package:flutter/foundation.dart';

import '../models/progress_model.dart';
import '../repositories/progress_repository.dart';

class ProgressProvider extends ChangeNotifier {
  ProgressProvider({
    ProgressRepository? repository,
  }) : _repository = repository ?? ProgressRepository();

  final ProgressRepository _repository;

  List<ProgressModel> _progress = [];
  List<ProgressModel> _completedProgress = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<ProgressModel> get progress => _progress;
  List<ProgressModel> get completedProgress =>
      _completedProgress;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Future<void> loadProgress({
    int page = 1,
    int limit = 20,
  }) async {
    _setLoading(true);

    try {
      _progress = await _repository.getProgress(
        page: page,
        limit: limit,
      );

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
          await _repository.getCompletedProgress();

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
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      return await _repository.answerMinute(
        minuteId: minuteId,
        answer: answer,
      );
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}