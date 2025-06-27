import 'package:diabary/features/medications/presentation/providers/calendar_provider.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:diabary/features/medications/presentation/widgets/medications_calendar.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime focusedDay = context.watch<CalendarProvider>().focusedDay;
    final notifications = context.watch<NotificationsProvider>();

    return Scaffold(
      appBar: AppBar(
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
            ElevatedButton(
              onPressed: () {
                notifications.showNotification(title: "Title", body: "Body");
              },
              child: const Text('Enviar notificação'),
            ),

            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                notifications.scheduleNotification(
                  title: "Title",
                  body: "Teste 2",
                  hour: 21,
                  minute: 53,
                );

                await context.read<NotificationsProvider>().loadNotifications();
              },
              child: const Text('Enviar notificação programada'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                notifications.cancelAllNotifications();
                context.read<NotificationsProvider>().clear();
              },

              child: const Text('Limpar notificações agendadas'),
            ),
            SizedBox(height: 30),
            Text(
              'Lista de Notificações agendadas',
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
    );
  }

  String captalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
