import 'package:diabary/data/medications_service.dart';
import 'package:flutter/material.dart';
import 'package:diabary/domain/models/medication_model.dart';
import 'package:diabary/domain/models/medication_event_model.dart';

class MedicationsProvider with ChangeNotifier {
  final MedicationsService _service;

  String? _userId;
  List<MedicationModel> _medications = [];
  final Map<DateTime, List<MedicationEventModel>> _eventsByDate = {};
  bool _isLoading = false;
  String? _error;

  MedicationsProvider(this._service);

  List<MedicationModel> get medications => _medications;
  Map<DateTime, List<MedicationEventModel>> get eventsByDate => _eventsByDate;
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

  void setUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      if (_userId != null) loadMedications();
    }
  }

  Future<void> loadMedications() async {
    if (_userId == null) return;
    _setLoading(true);

    try {
      _medications = await _service.loadMedications(_userId!);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> addMedication(MedicationModel med) async {
    if (_userId == null) return null;
    try {
      final medId = await _service.addMedication(_userId!, med);
      await loadMedications();
      return medId;
    } catch (e) {
      _setError("Erro ao adicionar medicação");
      return null;
    }
  }

  Future<void> updateMedication(MedicationModel med) async {
    if (_userId == null) return;
    try {
      await _service.updateMedication(_userId!, med);
      await loadMedications();
    } catch (e) {
      _setError("Erro ao atualizar medicação");
    }
  }

  Future<void> markAsTaken(String medicationId, DateTime date) async {
    if (_userId == null) return;
    await _service.markAsTaken(_userId!, medicationId, date);
    await loadEventsForDate(date);
  }

  Future<void> markAsNotTaken(String medicationId, DateTime date) async {
    if (_userId == null) return;
    await _service.markAsNotTaken(_userId!, medicationId, date);
    await loadEventsForDate(date);
  }

  Future<void> loadEventsForDate(DateTime date) async {
    if (_userId == null) return;
    final events = await _service.getEventsForDate(_userId!, date);
    _eventsByDate[DateTime(date.year, date.month, date.day)] = events;
    notifyListeners();
  }

  Future<void> loadEventsInRange(DateTime start, DateTime end) async {
    for (final day in List.generate(
      end.difference(start).inDays + 1,
      (i) => DateTime(start.year, start.month, start.day + i),
    )) {
      await loadEventsForDate(day);
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    if (_userId == null) return;
    try {
      await _service.deleteMedication(_userId!, medicationId);
      await loadMedications();
    } catch (e) {
      _setError("Erro ao excluir medicação");
    }
  }

  Future<void> deleteAllMedications() async {
    if (_userId == null) return;
    try {
      await _service.deleteAllMedications(_userId!);
      _medications.clear();
      _eventsByDate.clear();
      notifyListeners();
    } catch (e) {
      _setError("Erro ao excluir todas as medicações");
    }
  }
}
