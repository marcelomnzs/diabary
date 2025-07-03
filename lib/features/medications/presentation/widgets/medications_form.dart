import 'package:diabary/domain/models/medication_model.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/week_days_provider.dart';
import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:diabary/features/medications/presentation/widgets/week_day_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final _formKey = GlobalKey<FormState>();

class MedicationsForm extends StatefulWidget {
  const MedicationsForm({super.key});

  @override
  State<MedicationsForm> createState() => _MedicationsFormState();
}

class _MedicationsFormState extends State<MedicationsForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationsProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 32.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Novo lembrete',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 23),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Metformina',
                labelText: 'Nome da medicação',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O campo não pode estar vazio';
                }
                return null;
              },
              controller: _nameController,
            ),
            const SizedBox(height: 15),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '850mg',
                labelText: 'Informações adicionais',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O campo não pode estar vazio';
                }
                return null;
              },
              controller: _infoController,
            ),
            const SizedBox(height: 15),
            // Botão para escolher horário
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Horário: ${_formatTimeOfDay(_selectedTime)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton(
                  onPressed: _pickTime,
                  child: const Text('Escolher horário'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const WeekDayPicker(),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final formValid = _formKey.currentState!.validate();
                  final selectedDaysInts =
                      context
                          .read<WeekDaysProvider>()
                          .selectedDaysList
                          .map((dayString) {
                            switch (dayString) {
                              case 'Segunda':
                                return 1;
                              case 'Terça':
                                return 2;
                              case 'Quarta':
                                return 3;
                              case 'Quinta':
                                return 4;
                              case 'Sexta':
                                return 5;
                              case 'Sábado':
                                return 6;
                              case 'Domingo':
                                return 7;
                              default:
                                return 0;
                            }
                          })
                          .where((v) => v != 0)
                          .toList();

                  final weekDaysProvider = context.read<WeekDaysProvider>();
                  final medicationsProvider =
                      context.read<MedicationsProvider>();

                  if (!formValid) return;

                  if (selectedDaysInts.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecione pelo menos um dia da semana.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final medication = MedicationModel(
                    id: '',
                    nome: _nameController.text.trim(),
                    notas: _infoController.text.trim(),
                    horario: _selectedTime,
                    diasSemana: selectedDaysInts,
                  );

                  try {
                    await medicationsProvider.addMedication(medication);

                    await notifications.scheduleNotification(
                      title: medication.nome,
                      body: medication.notas,
                      hour: _selectedTime.hour,
                      minute: _selectedTime.minute,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Medicação criada')),
                    );

                    _nameController.clear();
                    _infoController.clear();
                    weekDaysProvider.clearSelection();

                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (!mounted) return;
                      Navigator.pop(context);
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar medicação: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Criar medicação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _nameController.clear();
                _infoController.clear();
                context.read<WeekDaysProvider>().clearSelection();
                Navigator.pop(context);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
