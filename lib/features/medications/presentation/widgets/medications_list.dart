import 'package:diabary/features/medications/presentation/widgets/medications_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:diabary/features/medications/presentation/widgets/medication_card.dart';

class MedicationsList extends StatefulWidget {
  const MedicationsList({super.key});

  @override
  State<MedicationsList> createState() => _MedicationsListState();
}

class _MedicationsListState extends State<MedicationsList> {
  Object? _expandedId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicationsProvider>();
    final medications = provider.medications;
    final error = provider.error;
    final isLoading = provider.isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Erro: $error'));
    }

    if (medications.isEmpty) {
      return const Center(child: Text('Nenhuma medicação cadastrada.'));
    }

    return ListView.builder(
      itemCount: medications.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final med = medications[index];
        final isExpanded = _expandedId == (med.id ?? index);

        return GestureDetector(
          onTap: () {
            setState(() {
              _expandedId = isExpanded ? null : (med.id ?? index);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(33, 0, 0, 0),
                  blurRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 4,
                          ),
                          child: Text(
                            med.nome,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),

                if (isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: MedicationCard(
                      med,
                      onEdit: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => MedicationsForm(initialData: med),
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  'Confirmar exclusão',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                content: Text(
                                  'Deseja excluir a medicação "${med.nome}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<MedicationsProvider>()
                                          .deleteMedication(med.id!);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Excluir',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
