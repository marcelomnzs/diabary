import 'package:diabary/domain/models/medication_event_model.dart';
import 'package:diabary/features/medications/presentation/providers/calendar_provider.dart';
import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationsCalendar extends StatefulWidget {
  const MedicationsCalendar({super.key});

  @override
  State<MedicationsCalendar> createState() => _MedicationsCalendarState();
}

class _MedicationsCalendarState extends State<MedicationsCalendar> {
  @override
  void initState() {
    super.initState();

    // Carrega os eventos do mês atual
    Future.microtask(() {
      final focusedDay = context.read<CalendarProvider>().focusedDay;
      final firstDayOfMonth = DateTime(focusedDay.year, focusedDay.month, 1);
      final lastDayOfMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0);
      context.read<MedicationsProvider>().loadEventsInRange(
        firstDayOfMonth,
        lastDayOfMonth,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final medicationsProvider = context.watch<MedicationsProvider>();

    final focusedDay = calendarProvider.focusedDay;
    final selectedDay = calendarProvider.selectedDay;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TableCalendar(
        headerVisible: true,
        locale: "pt_BR",
        focusedDay: focusedDay,
        firstDay: DateTime.utc(2010, 10, 14),
        lastDay: DateTime.utc(2030, 3, 14),
        availableGestures: AvailableGestures.all,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        eventLoader: (day) {
          final normalized = DateTime(day.year, day.month, day.day);
          return medicationsProvider.eventsByDate[normalized] ?? [];
        },
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronVisible: true,
          rightChevronVisible: true,
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceTint,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: true,
          markersMaxCount: 3,
        ),
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            final weekDaysLabel = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
            final text = weekDaysLabel[day.weekday % 7];
            final isWeekend =
                day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday;

            return Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isWeekend ? Colors.black54 : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return null;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  events.take(3).map((event) {
                    final medicationEvent = event as MedicationEventModel;
                    final wasTaken = medicationEvent.wasTaken;
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            wasTaken
                                ? Theme.of(context).colorScheme.tertiaryFixed
                                : Theme.of(context).colorScheme.errorContainer,
                      ),
                    );
                  }).toList(),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) async {
          final calendar = context.read<CalendarProvider>();
          final provider = context.read<MedicationsProvider>();

          calendar.setFocusedDay(focusedDay);
          calendar.setSelectedDay(selectedDay);

          await provider.loadEventsForDate(selectedDay);

          final normalized = DateTime(
            selectedDay.year,
            selectedDay.month,
            selectedDay.day,
          );
          final events = provider.eventsByDate[normalized] ?? [];

          if (events.isEmpty) return;

          final medsMap = {
            for (var med in provider.medications) med.id!: med.nome,
          };

          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Medicações do dia"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        events.map((event) {
                          final name =
                              medsMap[event.medicationId] ??
                              "Medicação desconhecida";
                          final status =
                              event.wasTaken ? "✅ Tomou" : "❌ Não tomou";
                          return ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            title: Text(name),
                            trailing: Text(status),
                          );
                        }).toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Fechar"),
                    ),
                  ],
                ),
          );
        },

        onPageChanged: (focusedDay) {
          context.read<CalendarProvider>().setFocusedDay(focusedDay);

          // Carrega os eventos do novo mês visível
          final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
          final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);
          context.read<MedicationsProvider>().loadEventsInRange(
            firstDay,
            lastDay,
          );
        },
      ),
    );
  }
}
