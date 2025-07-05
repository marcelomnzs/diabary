import 'package:diabary/domain/models/medication_model.dart';
import 'package:flutter/material.dart';

class MedicationCard extends StatelessWidget {
  final MedicationModel med;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicationCard(this.med, {super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 0.3),
          if (med.notas.isNotEmpty)
            Text(med.notas, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Horário: ', style: Theme.of(context).textTheme.labelLarge),
              Text(
                med.horario.format(context),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Dias: ', style: Theme.of(context).textTheme.labelLarge),
              Text(
                _formatDiasSemana(med.diasSemana),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                label: Text(
                  'Editar',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDelete,
                label: Text(
                  'Excluir medicação',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.primary,
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDiasSemana(List<int> dias) {
    const diasNomes = {
      1: 'Seg',
      2: 'Ter',
      3: 'Qua',
      4: 'Qui',
      5: 'Sex',
      6: 'Sáb',
      7: 'Dom',
    };

    return dias.map((d) => diasNomes[d] ?? '?').join(', ');
  }
}
