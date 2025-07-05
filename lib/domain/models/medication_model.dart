import 'package:flutter/material.dart';

class MedicationModel {
  final String? id;
  final String nome;
  final String notas;
  final TimeOfDay horario;
  final List<int> diasSemana; //1 = segunda, 7 = domingo
  final bool tomado;

  MedicationModel({
    required this.id,
    required this.nome,
    required this.notas,
    required this.horario,
    required this.diasSemana,
    this.tomado = false,
  });

  MedicationModel copyWith({
    String? id,
    String? nome,
    String? notas,
    TimeOfDay? horario,
    List<int>? diasSemana,
    bool? tomado,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      notas: notas ?? this.notas,
      horario: horario ?? this.horario,
      diasSemana: diasSemana ?? this.diasSemana,
      tomado: tomado ?? this.tomado,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'notas': notas,
    'horario': '${horario.hour}:${horario.minute}',
    'diasSemana': diasSemana,
  };

  factory MedicationModel.fromMap(Map<String, dynamic> json) {
    final timeParts = (json['horario'] as String).split(':');
    return MedicationModel(
      id: json['id'],
      nome: json['nome'],
      notas: json['notas'],
      horario: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      diasSemana:
          (json['diasSemana'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }
}
