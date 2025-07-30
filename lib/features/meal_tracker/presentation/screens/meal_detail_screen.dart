import 'dart:convert';
import 'dart:typed_data';

import 'package:diabary/domain/models/meal.dart';
import 'package:flutter/material.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;

  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes =
        meal.photoBase64 != null ? base64Decode(meal.photoBase64!) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Refeição')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data: ${meal.date.day}/${meal.date.month}/${meal.date.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Total de Calorias: ${meal.totalCalories.toStringAsFixed(0)} kcal',
            ),
            const SizedBox(height: 16),
            const Text('Itens:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...meal.items.map(
              (item) => Text('- ${item.description} (${item.calories})'),
            ),
            const SizedBox(height: 20),
            if (imageBytes != null)
              Center(child: Image.memory(imageBytes, height: 200))
            else
              const Center(child: Text("Sem imagem")),
          ],
        ),
      ),
    );
  }
}
