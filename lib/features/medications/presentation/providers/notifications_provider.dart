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

  // Setters internos
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // Carrega notificações agendadas
  Future<void> loadNotifications() async {
    try {
      _setLoading(true);
      _notifications = await _notificationsService.getScheduledNotifications();
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
  }) async {
    try {
      _setLoading(true);
      await _notificationsService.scheduleNotification(
        title: title,
        body: body,
        hour: hour,
        minute: minute,
      );
      await loadNotifications();
    } catch (e) {
      _setError('Erro ao agendar notificação');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      _setLoading(true);
      await _notificationsService.showNotification(title: title, body: body);
    } catch (e) {
      _setError('Erro ao mostrar notificação');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cancelNotificationById(int id) async {
    try {
      _setLoading(true);
      await _notificationsService.cancelNotificationById(id);
      await loadNotifications();
    } catch (e) {
      _setError('Erro ao cancelar notificação');
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
