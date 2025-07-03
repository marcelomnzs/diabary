class MedicationEventModel {
  final String medicationId;
  final DateTime date;
  final bool wasTaken;

  MedicationEventModel({
    required this.medicationId,
    required this.date,
    required this.wasTaken,
  });

  Map<String, dynamic> toMap() => {
    'medicationId': medicationId,
    'date': date.toIso8601String(),
    'wasTaken': wasTaken,
  };

  factory MedicationEventModel.fromMap(Map<String, dynamic> map) {
    return MedicationEventModel(
      medicationId: map['medicationId'],
      date: DateTime.parse(map['date']),
      wasTaken: map['wasTaken'],
    );
  }
}
