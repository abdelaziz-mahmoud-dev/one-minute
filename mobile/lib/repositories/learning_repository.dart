import '../models/category_model.dart';
import '../models/learning_path_model.dart';
import '../models/minute_model.dart';
import '../services/learning_service.dart';

class LearningRepository {
  LearningRepository({
    LearningService? learningService,
  }) : _learningService =
            learningService ?? LearningService();

  final LearningService _learningService;

  Future<List<CategoryModel>> getCategories() {
    return _learningService.getCategories();
  }

  Future<List<LearningPathModel>> getLearningPaths({
    String? category,
    String? level,
  }) {
    return _learningService.getLearningPaths(
      category: category,
      level: level,
    );
  }

  Future<LearningPathModel> getLearningPath(
    String id,
  ) {
    return _learningService.getLearningPath(id);
  }

  Future<MinuteModel> getMinute(String id) {
    return _learningService.getMinute(id);
  }
}