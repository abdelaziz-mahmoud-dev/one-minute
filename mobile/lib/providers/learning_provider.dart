import 'package:flutter/foundation.dart';

import '../models/category_model.dart';
import '../models/learning_path_model.dart';
import '../models/minute_model.dart';
import '../repositories/learning_repository.dart';

class LearningProvider extends ChangeNotifier {
  LearningProvider({
    LearningRepository? repository,
  }) : _repository = repository ?? LearningRepository();

  final LearningRepository _repository;

  List<CategoryModel> _categories = [];
  List<LearningPathModel> _paths = [];
  LearningPathModel? _currentPath;
  MinuteModel? _currentMinute;

  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  List<LearningPathModel> get paths => _paths;
  LearningPathModel? get currentPath => _currentPath;
  MinuteModel? get currentMinute => _currentMinute;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _setLoading(true);

    try {
      _categories = await _repository.getCategories();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPaths({
    String? category,
    String? level,
  }) async {
    _setLoading(true);

    try {
      _paths = await _repository.getLearningPaths(
        category: category,
        level: level,
      );

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<LearningPathModel?> loadPath(String id) async {
    _setLoading(true);

    try {
      final path = await _repository.getLearningPath(id);

      _currentPath = path;
      _error = null;

      return path;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<MinuteModel?> loadMinute(String id) async {
    _setLoading(true);

    try {
      _currentMinute = await _repository.getMinute(id);
      _error = null;

      return _currentMinute;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void updateCurrentMinuteCompletion({
    required bool completed,
  }) {
    final minute = _currentMinute;

    if (minute == null) {
      return;
    }

    _currentMinute = MinuteModel(
      id: minute.id,
      title: minute.title,
      content: minute.content,
      summary: minute.summary,
      pathId: minute.pathId,
      pathTitle: minute.pathTitle,
      order: minute.order,
      xpReward: minute.xpReward,
      isCompleted: completed,
      question: minute.question,
      options: minute.options,
      correctAnswer: minute.correctAnswer,
      explanation: minute.explanation,
    );

    notifyListeners();
  }

  void clearCurrentMinute() {
    _currentMinute = null;
    notifyListeners();
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