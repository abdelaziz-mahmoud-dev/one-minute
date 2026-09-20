import 'package:flutter/foundation.dart';

import '../models/recall_model.dart';
import '../repositories/recall_repository.dart';

class RecallProvider extends ChangeNotifier {
  RecallProvider({
    RecallRepository? repository,
  }) : _repository = repository ?? RecallRepository();

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

    try {
      _items = await _repository.getRecallItems();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> answerRecall({
    required String recallId,
    required String answer,
  }) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      return await _repository.answerRecall(
        recallId: recallId,
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

  void clearItems() {
    _items = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}