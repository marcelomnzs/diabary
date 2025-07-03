import 'package:diabary/features/medications/presentation/providers/calendar_provider.dart';
import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:diabary/features/medications/presentation/widgets/medications_calendar.dart';
import 'package:diabary/features/medications/presentation/widgets/medications_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<NotificationsProvider>().loadNotifications();
      context.read<MedicationsProvider>().loadMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime focusedDay = context.watch<CalendarProvider>().focusedDay;
    final medicationsProvider = context.watch<MedicationsProvider>();

    if (medicationsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        title: Text(
          'Medicamentos',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(19, 32.0, 0, 8.0),
                  child: Text(
                    captalizeFirstLetter(
                      DateFormat(
                        "EEEE, d 'de' MMM",
                        'pt_BR',
                      ).format(focusedDay),
                    ),
                    style: Theme.of(context).textTheme.headlineMedium!,
                  ),
                ),

                const Divider(thickness: 1),
                SizedBox(height: 8),
                MedicationsCalendar(),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Meus medicamentos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 15),
            Expanded(
              child: Consumer<NotificationsProvider>(
                builder: (context, provider, _) {
                  final notifications = provider.notifications;

                  if (notifications.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma notificação agendada.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (_, index) {
                      final n = notifications[index];
                      return ListTile(
                        title: Text(n.title ?? 'Sem título'),
                        subtitle: Text(n.body ?? 'Sem corpo'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SafeArea(
                  top: false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.4,
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      child: MedicationsForm(),
                    ),
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  String captalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
