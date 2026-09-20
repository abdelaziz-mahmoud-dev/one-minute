import '../models/recall_model.dart';
import '../services/recall_service.dart';

class RecallRepository {
  RecallRepository({
    RecallService? recallService,
  }) : _recallService =
            recallService ?? RecallService();

  final RecallService _recallService;

  Future<List<RecallModel>> getRecallItems() {
    return _recallService.getRecallItems();
  }

  Future<Map<String, dynamic>> answerRecall({
    required String recallId,
    required String answer,
  }) {
    return _recallService.answerRecall(
      recallId: recallId,
      answer: answer,
    );
  }
}