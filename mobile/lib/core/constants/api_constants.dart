class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.32:3000/api';

  // Health
  static const String health = '/health';

  // Authentication
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String profile = '/auth/profile';
  static const String interests = '/auth/interests';
  static const String password = '/auth/password';

  // Learning
  static const String categories = '/learning/categories';
  static const String learningPaths = '/learning/paths';

  static String learningPath(String id) =>
      '/learning/paths/$id';

  static String minute(String id) =>
      '/learning/minutes/$id';

  // Daily
  static const String daily = '/daily';

  // Progress
  static const String progress = '/progress';
  static const String completedProgress = '/progress/completed';

  static String answerMinute(String id) =>
      '/progress/minutes/$id/answer';

  // Recall
  static const String recall = '/recall';

  static String answerRecall(String id) =>
      '/recall/$id/answer';

  // Dashboard
  static const String dashboard = '/dashboard';
}