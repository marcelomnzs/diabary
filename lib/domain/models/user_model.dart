class UserModel {
  final String id;
  final String email;
  final String? name;
  final bool onboardingCompleted;

  final DateTime? birthDate;
  final String? gender;
  final double? weight;
  final String? diabetesType;
  final String? diabetesDuration;
  final String? otherConditions;
  final bool usesMedication;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.onboardingCompleted = false,
    this.birthDate,
    this.gender,
    this.weight,
    this.diabetesType,
    this.diabetesDuration,
    this.otherConditions,
    this.usesMedication = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'onboardingCompleted': onboardingCompleted,
      'birthDate': birthDate?.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'diabetesType': diabetesType,
      'diabetesDuration': diabetesDuration,
      'otherConditions': otherConditions,
      'usesMedication': usesMedication,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'],
      name: map['name'],
      onboardingCompleted: map['onboardingCompleted'] ?? false,
      birthDate:
          map['birthDate'] != null ? DateTime.parse(map['birthDate']) : null,
      gender: map['gender'],
      weight: (map['weight'] as num?)?.toDouble(),
      diabetesType: map['diabetesType'],
      diabetesDuration: map['diabetesDuration'],
      otherConditions: map['otherConditions'],
      usesMedication: map['usesMedication'] ?? false,
    );
  }
}
