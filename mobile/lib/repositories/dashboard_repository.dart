import '../models/dashboard_model.dart';
import '../models/minute_model.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  DashboardRepository({
    DashboardService? dashboardService,
  }) : _dashboardService =
            dashboardService ?? DashboardService();

  final DashboardService _dashboardService;

  Future<DashboardModel> getDashboard() {
    return _dashboardService.getDashboard();
  }

  Future<MinuteModel> getDailyMinute() {
    return _dashboardService.getDailyMinute();
  }
}