import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diabary/domain/models/medication_model.dart';
import 'package:diabary/domain/models/medication_event_model.dart';

class MedicationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection('users').doc(userId).collection('medications');
  }

  Future<List<MedicationModel>> fetchMedications(String userId) async {
    final query = await _collection(userId).get();
    return query.docs.map((doc) {
      return MedicationModel.fromMap({...doc.data(), 'id': doc.id});
    }).toList();
  }

  Future<String> addMedication(String userId, MedicationModel med) async {
    final doc = await _collection(userId).add(med.toMap());
    await doc.update({'id': doc.id});

    return doc.id;
  }

  Future<void> updateMedication(String userId, MedicationModel med) async {
    if (med.id == null || med.id!.isEmpty) {
      throw ArgumentError('ID da medicação é obrigatório para atualização');
    }
    await _collection(userId).doc(med.id).update(med.toMap());
  }

  Future<void> deleteMedication(String userId, String medId) async {
    final medRef = _collection(userId).doc(medId);

    final events = await medRef.collection('events').get();
    for (final e in events.docs) {
      await e.reference.delete();
    }

    await medRef.delete();
  }

  Future<void> deleteAllMedications(String userId) async {
    final meds = await _collection(userId).get();

    for (final med in meds.docs) {
      await deleteMedication(userId, med.id);
    }
  }

  Future<void> saveEvent(
    String userId,
    String medId,
    MedicationEventModel event,
  ) async {
    final dateId = event.date.toIso8601String();
    await _collection(userId).doc(medId).collection('events').doc(dateId).set({
      'wasTaken': event.wasTaken,
      'date': event.date.toIso8601String(),
    });
  }

  Future<List<MedicationEventModel>> fetchEventsForDate(
    String userId,
    DateTime day,
  ) async {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    final query = await _collection(userId).get();
    List<MedicationEventModel> events = [];

    for (final doc in query.docs) {
      final medId = doc.id;

      final eventsSnapshot =
          await _collection(userId)
              .doc(medId)
              .collection('events')
              .where(
                'date',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
              )
              .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
              .get();

      for (final eventDoc in eventsSnapshot.docs) {
        final data = eventDoc.data();
        final eventDate = DateTime.parse(data['date']);

        events.add(
          MedicationEventModel.fromMap({
            ...data,
            'medicationId': medId,
            'date': eventDate.toIso8601String(),
          }),
        );
      }
    }

    return events;
  }
}
