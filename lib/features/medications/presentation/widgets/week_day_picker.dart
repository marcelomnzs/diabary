import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/week_days_provider.dart'; // ajuste o caminho conforme necessário

class WeekDayPicker extends StatelessWidget {
  const WeekDayPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final weekDaysProvider = Provider.of<WeekDaysProvider>(context);
    final daysMap = weekDaysProvider.selectedDays;

    final List<String> shortLabels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
    final List<String> fullLabels = [
      'Domingo',
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dias da semana', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            final fullDay = fullLabels[index];
            final shortLabel = shortLabels[index];
            final isSelected = daysMap[fullDay] ?? false;

            return FilterChip(
              label: Text(shortLabel),
              selected: isSelected,
              onSelected: (_) {
                weekDaysProvider.toggleDay(fullDay);
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              showCheckmark: false,
              labelStyle: TextStyle(
                color:
                    isSelected ? Theme.of(context).colorScheme.onPrimary : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
