import 'package:flutter/material.dart';

class MedicationModel {
  final String nome;
  final String notas;
  final TimeOfDay horario;
  final bool tomado;

  MedicationModel({
    required this.nome,
    required this.notas,
    required this.horario,
    this.tomado = false,
  });

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'notas': notas,
    'horario': '${horario.hour}:${horario.minute}',
    'tomado': tomado,
  };

  factory MedicationModel.fromMap(Map<String, dynamic> json) {
    final timeParts = (json['horario'] as String).split(':');
    return MedicationModel(
      nome: json['nome'],
      notas: json['notas'],
      horario: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      tomado: json['tomado'] ?? false,
    );
  }
}

