import 'package:flutter/foundation.dart';

import '../models/dashboard_model.dart';
import '../models/minute_model.dart';
import '../repositories/dashboard_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    DashboardRepository? repository,
  }) : _repository = repository ?? DashboardRepository();

  final DashboardRepository _repository;

  DashboardModel? _dashboard;
  MinuteModel? _dailyMinute;

  bool _isLoading = false;
  String? _error;

  DashboardModel? get dashboard => _dashboard;
  MinuteModel? get dailyMinute => _dailyMinute;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadHome() async {
    _setLoading(true);

    try {
      final results = await Future.wait([
        _repository.getDashboard(),
        _repository.getDailyMinute(),
      ]);

      _dashboard = results[0] as DashboardModel;
      _dailyMinute = results[1] as MinuteModel;

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await loadHome();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}