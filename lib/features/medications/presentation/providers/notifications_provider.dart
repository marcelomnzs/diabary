import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:diabary/data/notifications_service.dart';

class NotificationsProvider with ChangeNotifier {
  final NotificationsService _notificationsService;

  List<PendingNotificationRequest> _notifications = [];
  bool _isLoading = false;
  String? _error;

  NotificationsProvider(this._notificationsService);

  // Getters
  List<PendingNotificationRequest> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    try {
      _setLoading(true);
      _notifications = await _notificationsService.loadNotifications();
    } catch (e) {
      _setError('Erro ao carregar notificações');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) async {
    try {
      _setLoading(true);
      await _notificationsService.scheduleWeeklyNotifications(
        title: title,
        body: body,
        hour: hour,
        minute: minute,
        weekdays: weekdays,
      );
      await loadNotifications();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rescheduleNotification({
    required String oldTitle,
    required String newTitle,
    required String body,
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) async {
    try {
      _setLoading(true);
      await _notificationsService.rescheduleNotification(
        oldTitle: oldTitle,
        newTitle: newTitle,
        body: body,
        hour: hour,
        minute: minute,
        weekdays: weekdays,
      );
      await loadNotifications();
    } catch (e) {
      _setError('Erro ao reagendar notificação');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      _setLoading(true);
      await _notificationsService.cancelAllNotifications();
      _notifications = [];
      notifyListeners();
    } catch (e) {
      _setError('Erro ao cancelar todas as notificações');
    } finally {
      _setLoading(false);
    }
  }

  void clear() {
    _notifications = [];
    notifyListeners();
  }
}
