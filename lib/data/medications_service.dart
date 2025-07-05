import 'package:diabary/domain/models/medication_event_model.dart';
import 'package:diabary/domain/models/medication_model.dart';
import 'package:diabary/domain/repositories/medications_repository.dart';

class MedicationsService {
  final MedicationsRepository _repository;

  MedicationsService(this._repository);

  Future<List<MedicationModel>> loadMedications(String userId) {
    return _repository.fetchMedications(userId);
  }

  Future<void> addMedication(String userId, MedicationModel med) async {
    await _repository.addMedication(userId, med);
  }

  Future<void> updateMedication(String userId, MedicationModel med) async {
    await _repository.updateMedication(userId, med);
  }

  Future<void> deleteMedication(String userId, String medId) {
    return _repository.deleteMedication(userId, medId);
  }

  Future<void> deleteAllMedications(String userId) {
    return _repository.deleteAllMedications(userId);
  }

  Future<void> markAsTaken(String userId, String medId, DateTime date) {
    return _repository.saveEvent(
      userId,
      medId,
      MedicationEventModel(medicationId: medId, date: date, wasTaken: true),
    );
  }

  Future<void> markAsNotTaken(String userId, String medId, DateTime date) {
    return _repository.saveEvent(
      userId,
      medId,
      MedicationEventModel(medicationId: medId, date: date, wasTaken: false),
    );
  }

  Future<List<MedicationEventModel>> getEventsForDate(
    String userId,
    DateTime date,
  ) {
    return _repository.fetchEventsForDate(userId, date);
  }
}
