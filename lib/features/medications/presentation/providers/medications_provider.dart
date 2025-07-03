import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabary/domain/models/medication_event_model.dart';
import 'package:diabary/domain/models/medication_model.dart';
import 'package:flutter/material.dart';

class MedicationsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _userId;
  List<MedicationModel> _medications = [];
  final Map<DateTime, List<MedicationEventModel>> _eventsByDate = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MedicationModel> get medications => _medications;
  Map<DateTime, List<MedicationEventModel>> get eventsByDate => _eventsByDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Setters internos
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setUserId(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      if (_userId != null) loadMedications();
    }
  }

  CollectionReference<Map<String, dynamic>> _userMedicationsCollection() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('medications');
  }

  Future<void> loadMedications() async {
    if (_userId == null) return;
    _setLoading(true);

    try {
      final query = await _userMedicationsCollection().get();
      _medications =
          query.docs.map((doc) {
            return MedicationModel.fromMap({...doc.data(), 'id': doc.id});
          }).toList();
      notifyListeners();
    } catch (e) {
      setError('Erro ao carregar medicações');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addMedication(MedicationModel med) async {
    if (_userId == null) return;

    try {
      final doc = await _userMedicationsCollection().add(med.toMap());
      _medications.add(med.copyWith(id: doc.id));
      notifyListeners();
    } catch (e) {
      setError('Erro ao adicionar medicação');
    }
  }

  Future<void> markAsTaken(String medicationId, DateTime date) async {
    await _saveEvent(medicationId, date, true);
  }

  Future<void> markAsNotTaken(String medicationId, DateTime date) async {
    await _saveEvent(medicationId, date, false);
  }

  Future<void> _saveEvent(
    String medicationId,
    DateTime date,
    bool tomou,
  ) async {
    if (_userId == null) return;

    final day = DateTime(date.year, date.month, date.day);

    try {
      await _userMedicationsCollection()
          .doc(medicationId)
          .collection('events')
          .doc(day.toIso8601String())
          .set({'tomou': tomou});

      await loadEventsForDate(day);
    } catch (e) {
      setError('Erro ao salvar lembrete');
    }
  }

  Future<void> loadEventsForDate(DateTime date) async {
    if (_userId == null) return;

    final day = DateTime(date.year, date.month, date.day);
    final query = await _userMedicationsCollection().get();

    final Map<DateTime, List<MedicationEventModel>> dayEvents = {};

    for (final med in query.docs) {
      final medId = med.id;

      final doc =
          await _userMedicationsCollection()
              .doc(medId)
              .collection('events')
              .doc(day.toIso8601String())
              .get();

      if (doc.exists) {
        final event = MedicationEventModel.fromMap({
          ...doc.data()!,
          'medicationId': medId,
          'date': day.toIso8601String(),
        });

        dayEvents.putIfAbsent(day, () => []).add(event);
      }
    }

    _eventsByDate[day] = dayEvents[day] ?? [];
    notifyListeners();
  }

  Future<void> loadEventsInRange(DateTime start, DateTime end) async {
    final days = List<DateTime>.generate(
      end.difference(start).inDays + 1,
      (i) => DateTime(start.year, start.month, start.day + i),
    );

    for (final day in days) {
      await loadEventsForDate(day);
    }
  }
}
