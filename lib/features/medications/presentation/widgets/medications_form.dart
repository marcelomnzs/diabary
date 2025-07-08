import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diabary/domain/models/medication_model.dart';
import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/week_days_provider.dart';
import 'package:diabary/features/medications/presentation/widgets/week_day_picker.dart';

class MedicationsForm extends StatefulWidget {
  final MedicationModel? initialData;

  const MedicationsForm({super.key, this.initialData});

  @override
  State<MedicationsForm> createState() => _MedicationsFormState();
}

class _MedicationsFormState extends State<MedicationsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      final med = widget.initialData!;
      _nameCtrl.text = med.nome;
      _infoCtrl.text = med.notas;
      _selectedTime = med.horario;

      // Já deixa os dias da semana definidos
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WeekDaysProvider>().setSelectedDays(med.diasSemana);
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _infoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _format(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;
    final notifications = context.watch<NotificationsProvider>();
    final weekDaysProvider = context.read<WeekDaysProvider>();
    final medicationsProvider = context.read<MedicationsProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Editar lembrete' : 'Novo lembrete',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nome da medicação',
                hintText: 'Ex: Metformina',
              ),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'O campo é obrigatório'
                          : null,
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: _infoCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Informações adicionais',
                hintText: '850 mg',
              ),
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Horário: ${_format(_selectedTime)}',
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
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final selectedInts = weekDaysProvider.selectedDaysListInts;
                  if (selectedInts.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecione pelo menos um dia da semana.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final med = MedicationModel(
                    id: isEditing ? widget.initialData!.id : '',
                    nome: _nameCtrl.text.trim(),
                    notas: _infoCtrl.text.trim(),
                    horario: _selectedTime,
                    diasSemana: selectedInts,
                  );

                  try {
                    if (isEditing) {
                      medicationsProvider.updateMedication(med);

                      await notifications.rescheduleNotification(
                        oldTitle: widget.initialData!.nome,
                        newTitle: med.nome,
                        body: med.notas,
                        hour: med.horario.hour,
                        minute: med.horario.minute,
                        weekdays: med.diasSemana,
                        medId: med.id!,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Medicação atualizada')),
                      );
                    } else {
                      final medId = await medicationsProvider.addMedication(
                        med,
                      );

                      await notifications.scheduleNotification(
                        title: med.nome,
                        body: med.notas,
                        hour: _selectedTime.hour,
                        minute: _selectedTime.minute,
                        weekdays: selectedInts,
                        medId: medId!,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Medicação criada')),
                      );
                    }

                    _nameCtrl.clear();
                    _infoCtrl.clear();
                    weekDaysProvider.clearSelection();
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isEditing ? 'Salvar alterações' : 'Criar medicação',
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
                _nameCtrl.clear();
                _infoCtrl.clear();
                weekDaysProvider.clearSelection();
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
