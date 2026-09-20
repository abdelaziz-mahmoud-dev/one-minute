import 'package:flutter/foundation.dart';

import '../models/recall_model.dart';
import '../repositories/recall_repository.dart';

class RecallProvider extends ChangeNotifier {
  RecallProvider({
    RecallRepository? repository,
  }) : _repository =
            repository ?? RecallRepository();

  final RecallRepository _repository;

  List<RecallModel> _items = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;

  List<RecallModel> get items => _items;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;

  Future<void> loadRecall() async {
    _setLoading(true);
    _error = null;

    try {
      _items = await _repository.getRecallItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> answerRecall({
    required String recallId,
    required int score,
  }) async {
    if (_isSubmitting) {
      return false;
    }

    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.answerRecall(
        recallId: recallId,
        score: score,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearItems() {
    _items = [];
    _error = null;
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