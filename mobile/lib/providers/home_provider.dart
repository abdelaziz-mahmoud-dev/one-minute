import 'package:flutter/foundation.dart';

import '../models/dashboard_model.dart';
import '../models/minute_model.dart';
import '../repositories/dashboard_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    DashboardRepository? repository,
  }) : _repository =
            repository ?? DashboardRepository();

  final DashboardRepository _repository;

  DashboardModel? _dashboard;
  MinuteModel? _dailyMinute;

  bool _isLoading = false;
  bool _isRefreshing = false;

  String? _error;
  String? _dailyError;

  DashboardModel? get dashboard => _dashboard;
  MinuteModel? get dailyMinute => _dailyMinute;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;

  String? get error => _error;
  String? get dailyError => _dailyError;

  Future<void> loadHome() async {
    _setLoading(true);

    _error = null;
    _dailyError = null;

    try {
      await Future.wait([
        _loadDashboard(),
        _loadDailyMinute(),
      ]);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();

    _error = null;
    _dailyError = null;

    try {
      await Future.wait([
        _loadDashboard(),
        _loadDailyMinute(),
      ]);
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> _loadDashboard() async {
    try {
      _dashboard =
          await _repository.getDashboard();

      _error = null;
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> _loadDailyMinute() async {
    try {
      _dailyMinute =
          await _repository.getDailyMinute();

      _dailyError = null;
    } catch (e) {
      _dailyError = e.toString();
    }
  }

  void clearErrors() {
    _error = null;
    _dailyError = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}