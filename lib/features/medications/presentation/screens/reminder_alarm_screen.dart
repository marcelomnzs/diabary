import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReminderAlarmScreen extends StatelessWidget {
  final String medicationId;

  const ReminderAlarmScreen({required this.medicationId, super.key});

  @override
  Widget build(BuildContext context) {
    final medication = context
        .read<MedicationsProvider>()
        .medications
        .firstWhere((m) => m.id == medicationId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.alarm,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 15),
            Text(
              'Hora de tomar:',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                color: Color.fromARGB(183, 255, 255, 255),
              ),
            ),
            Text(
              medication.nome,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontWeight: FontWeight.normal,
              ),
            ),

            if (medication.notas.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  medication.notas,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              height: 80,
              child: Dismissible(
                key: const Key("reminder_slider"),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    // Esquerda: não tomou
                    context.read<MedicationsProvider>().markAsNotTaken(
                      medicationId,
                      DateTime.now(),
                    );
                    Navigator.of(context).pop();
                  } else if (direction == DismissDirection.startToEnd) {
                    // Direita: tomou
                    context.read<MedicationsProvider>().markAsTaken(
                      medicationId,
                      DateTime.now(),
                    );
                    Navigator.of(context).pop();
                  }
                },
                background: Container(
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    size: 32,
                  ),
                ),
                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  color: Theme.of(context).colorScheme.errorContainer,
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 32,
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Text(
                    'Deslize para confirmar ou recusar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
